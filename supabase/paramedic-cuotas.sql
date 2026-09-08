-- ============================================================
--  CAPIAF · Cobertura Paramedic + registro de cuotas
--  Ejecutar en Supabase → SQL Editor (una sola vez)
-- ============================================================

-- 1) Datos fiscales y estado Paramedic en estudios
alter table public.estudios
  add column if not exists cuit             text,
  add column if not exists razon_social     text,
  add column if not exists paramedic_estado text not null default 'pendiente'
      check (paramedic_estado in ('pendiente','activo','transitorio','baja')),
  add column if not exists paramedic_alta   date,
  add column if not exists paramedic_baja   date,
  add column if not exists preaviso_vence   date,   -- solo para 'transitorio'
  add column if not exists paramedic_nota   text;

-- 2) Override fiscal por sede (si la sede está habilitada a nombre de otro CUIT)
alter table public.sedes
  add column if not exists cuit         text,
  add column if not exists razon_social text;

-- 3) Valores de cuota vigentes por período (histórico)
create table if not exists public.cuota_valores (
  vigencia_desde   date primary key,
  base_plena       numeric(12,2) not null,
  base_transitoria numeric(12,2) not null,
  extra_sede       numeric(12,2) not null
);
insert into public.cuota_valores (vigencia_desde, base_plena, base_transitoria, extra_sede)
values ('2026-10-01', 50000, 40000, 20000)
on conflict (vigencia_desde) do nothing;

-- 4) Cuotas por estudio y período (fuente: Facturo Más Fácil)
create table if not exists public.cuotas (
  id          uuid primary key default gen_random_uuid(),
  estudio_id  uuid not null references public.estudios(id) on delete cascade,
  periodo     date not null,                      -- siempre día 1 del mes
  tipo        text not null default 'plena' check (tipo in ('plena','transitoria')),
  sedes_extra int  not null default 0,
  importe     numeric(12,2),
  factura     text,                               -- "0003-00001234"
  estado      text not null default 'pendiente' check (estado in ('pendiente','pagada','anulada')),
  fecha_pago  date,
  fuente      text not null default 'masfacil',
  updated_at  timestamptz not null default now(),
  unique (estudio_id, periodo)
);
create index if not exists cuotas_estudio_idx on public.cuotas(estudio_id);

alter table public.cuota_valores enable row level security;
alter table public.cuotas        enable row level security;

drop policy if exists cuota_valores_leer on public.cuota_valores;
create policy cuota_valores_leer on public.cuota_valores
  for select to authenticated using (true);
drop policy if exists cuota_valores_admin on public.cuota_valores;
create policy cuota_valores_admin on public.cuota_valores
  for all to authenticated using (public.es_admin()) with check (public.es_admin());

drop policy if exists cuotas_leer on public.cuotas;
create policy cuotas_leer on public.cuotas
  for select to authenticated
  using (public.es_admin() or estudio_id in (select id from public.estudios where user_id = auth.uid()));
drop policy if exists cuotas_admin on public.cuotas;
create policy cuotas_admin on public.cuotas
  for all to authenticated using (public.es_admin()) with check (public.es_admin());
-- El job de Más Fácil escribe con la service key (bypassea RLS).

-- 5) Cálculo del importe de cuota según tipo y cantidad de sedes extra
create or replace function public.calcular_cuota(p_estudio uuid, p_periodo date)
returns numeric language sql stable as $$
  select case when e.paramedic_estado = 'transitorio' then v.base_transitoria else v.base_plena end
         + v.extra_sede * (select count(*) from public.sedes s where s.estudio_id = e.id)
    from public.estudios e
    join lateral (
      select * from public.cuota_valores where vigencia_desde <= p_periodo
      order by vigencia_desde desc limit 1
    ) v on true
   where e.id = p_estudio;
$$;

-- 6) Mora: dos cuotas impagas vencidas → cuota_al_dia = false y baja de Paramedic
create or replace function public.recalcular_mora(p_estudio uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_impagas int;
begin
  select count(*) into v_impagas
    from cuotas
   where estudio_id = p_estudio
     and estado = 'pendiente'
     and periodo < date_trunc('month', current_date);   -- solo períodos ya vencidos

  update estudios set cuota_al_dia = (v_impagas < 2) where id = p_estudio;

  if v_impagas >= 2 then
    update estudios
       set paramedic_estado = 'baja', paramedic_baja = current_date,
           paramedic_nota = coalesce(paramedic_nota,'') || ' Baja automática por mora (' || v_impagas || ' cuotas).'
     where id = p_estudio and paramedic_estado in ('activo','transitorio');
  end if;
end $$;

create or replace function public.trg_cuotas_mora() returns trigger
language plpgsql as $$
begin
  perform public.recalcular_mora(coalesce(new.estudio_id, old.estudio_id));
  return null;
end $$;

drop trigger if exists cuotas_mora on public.cuotas;
create trigger cuotas_mora
  after insert or update or delete on public.cuotas
  for each row execute function public.trg_cuotas_mora();

-- 7) Nómina Paramedic: una fila por domicilio cubierto (sede principal + adicionales)
create or replace view public.paramedic_nomina with (security_invoker = true) as
  select e.nro_socio, e.nombre as estudio, 'Sede principal' as sede,
         coalesce(e.razon_social,'') as razon_social, coalesce(e.cuit,'') as cuit,
         e.direccion, e.numero, e.piso, e.barrio, e.telefono, e.email,
         e.paramedic_estado, e.paramedic_alta, e.paramedic_baja, e.preaviso_vence
    from public.estudios e
   where e.aprobado and coalesce(e.activo, true)
  union all
  select e.nro_socio, e.nombre, coalesce(s.nombre,'Sede'),
         coalesce(s.razon_social, e.razon_social,''), coalesce(s.cuit, e.cuit,''),
         s.direccion, s.numero, null, s.barrio, e.telefono, e.email,
         e.paramedic_estado, e.paramedic_alta, e.paramedic_baja, e.preaviso_vence
    from public.sedes s join public.estudios e on e.id = s.estudio_id
   where e.aprobado and coalesce(e.activo, true);
-- security_invoker: la vista respeta el RLS de estudios/sedes (solo el admin la ve completa)

-- 8) Validación básica de CUIT (dígito verificador) — la usa el portal vía RPC
create or replace function public.cuit_valido(p text) returns boolean
language plpgsql immutable as $$
declare d text := regexp_replace(coalesce(p,''), '\D', '', 'g');
        pesos int[] := array[5,4,3,2,7,6,5,4,3,2];
        s int := 0; dv int;
begin
  if length(d) <> 11 then return false; end if;
  for i in 1..10 loop s := s + substr(d,i,1)::int * pesos[i]; end loop;
  dv := 11 - (s % 11);
  if dv = 11 then dv := 0; elsif dv = 10 then dv := 9; end if;
  return dv = substr(d,11,1)::int;
end $$;
