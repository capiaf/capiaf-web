-- ============================================================
--  CAPIAF · Sistema de cupones para beneficios de proveedores
--  Ejecutar en Supabase → SQL Editor (una sola vez)
-- ============================================================

-- 0) Flag de cuota al día en estudios (lo maneja Tesorería desde el admin)
alter table public.estudios
  add column if not exists cuota_al_dia boolean not null default true;

-- 1) Catálogo de beneficios
create table if not exists public.beneficios (
  id            uuid primary key default gen_random_uuid(),
  proveedor     text not null,
  titulo        text not null,          -- "20% en recarga de matafuegos"
  descripcion   text,                   -- detalle del beneficio
  condiciones   text,                   -- letra chica: mínimos, zonas, exclusiones
  contacto      text,                   -- web / whatsapp / email del proveedor
  dias_validez  int  not null default 7,-- vigencia de cada cupón generado
  activo        boolean not null default true,
  vigencia_hasta date,                  -- null = sin fecha de fin
  orden         int not null default 100,
  created_at    timestamptz not null default now()
);

-- 2) Cupones emitidos
create table if not exists public.cupones (
  id           uuid primary key default gen_random_uuid(),
  codigo       text not null unique,
  beneficio_id uuid not null references public.beneficios(id) on delete cascade,
  estudio_id   uuid not null references public.estudios(id) on delete cascade,
  creado_en    timestamptz not null default now(),
  vence_en     timestamptz not null,
  usado_en     timestamptz,
  nota         text                     -- lo que anota el proveedor al canjear
);
create index if not exists cupones_estudio_idx   on public.cupones(estudio_id);
create index if not exists cupones_beneficio_idx on public.cupones(beneficio_id);

-- 3) RLS
alter table public.beneficios enable row level security;
alter table public.cupones    enable row level security;

create or replace function public.es_admin() returns boolean
language sql stable as $$
  select coalesce(auth.jwt() ->> 'email', '') = 'info@pilates.org.ar';
$$;

drop policy if exists beneficios_leer_socios on public.beneficios;
create policy beneficios_leer_socios on public.beneficios
  for select to authenticated
  using (activo and (vigencia_hasta is null or vigencia_hasta >= current_date) or public.es_admin());

drop policy if exists beneficios_admin on public.beneficios;
create policy beneficios_admin on public.beneficios
  for all to authenticated
  using (public.es_admin()) with check (public.es_admin());

drop policy if exists cupones_leer_propios on public.cupones;
create policy cupones_leer_propios on public.cupones
  for select to authenticated
  using (
    public.es_admin()
    or estudio_id in (select id from public.estudios where user_id = auth.uid())
  );
-- No hay policy de insert/update: sólo se escribe vía las funciones de abajo.

-- 4) Generar cupón (socio logueado)
create or replace function public.generar_cupon(p_beneficio uuid)
returns json
language plpgsql security definer set search_path = public as $$
declare
  v_est   record;
  v_ben   record;
  v_cup   record;
  v_cod   text;
  v_alfa  text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; -- sin 0/O/1/I/L
  i int;
begin
  if auth.uid() is null then
    raise exception 'No autenticado';
  end if;

  select * into v_est from estudios where user_id = auth.uid() order by created_at limit 1;
  if v_est is null then raise exception 'Estudio no encontrado'; end if;
  if not coalesce(v_est.aprobado, false) then raise exception 'Tu estudio todavía no está aprobado por la Cámara.'; end if;
  if v_est.activo = false then raise exception 'Tu estudio figura como inactivo.'; end if;
  if not coalesce(v_est.cuota_al_dia, true) then raise exception 'Para usar beneficios tenés que estar al día con la cuota social.'; end if;

  select * into v_ben from beneficios
   where id = p_beneficio and activo and (vigencia_hasta is null or vigencia_hasta >= current_date);
  if v_ben is null then raise exception 'Beneficio no disponible'; end if;

  -- Si ya tiene un cupón vigente sin usar para este beneficio, lo devuelve (no genera otro)
  select * into v_cup from cupones
   where estudio_id = v_est.id and beneficio_id = v_ben.id
     and usado_en is null and vence_en > now()
   order by creado_en desc limit 1;

  if v_cup is null then
    loop
      v_cod := 'CAP-';
      for i in 1..4 loop v_cod := v_cod || substr(v_alfa, 1 + floor(random()*length(v_alfa))::int, 1); end loop;
      v_cod := v_cod || '-';
      for i in 1..2 loop v_cod := v_cod || substr(v_alfa, 1 + floor(random()*length(v_alfa))::int, 1); end loop;
      exit when not exists (select 1 from cupones where codigo = v_cod);
    end loop;

    insert into cupones (codigo, beneficio_id, estudio_id, vence_en)
    values (v_cod, v_ben.id, v_est.id, now() + (v_ben.dias_validez || ' days')::interval)
    returning * into v_cup;
  end if;

  return json_build_object(
    'codigo', v_cup.codigo,
    'vence_en', v_cup.vence_en,
    'creado_en', v_cup.creado_en,
    'beneficio', v_ben.titulo,
    'proveedor', v_ben.proveedor
  );
end $$;

-- 5) Validar cupón (público: lo usa el proveedor sin cuenta)
create or replace function public.validar_cupon(p_codigo text)
returns json
language plpgsql security definer set search_path = public as $$
declare
  v record; v_estado text;
begin
  select c.codigo, c.vence_en, c.usado_en, c.creado_en,
         e.nombre as estudio, e.nro_socio, e.aprobado, e.activo, e.cuota_al_dia,
         b.titulo as beneficio, b.proveedor, b.descripcion, b.condiciones
    into v
    from cupones c
    join estudios e on e.id = c.estudio_id
    join beneficios b on b.id = c.beneficio_id
   where c.codigo = upper(trim(p_codigo));

  if v is null then
    return json_build_object('estado', 'inexistente');
  end if;

  v_estado := case
    when v.usado_en is not null then 'usado'
    when v.vence_en < now() then 'vencido'
    when not coalesce(v.aprobado,false) or v.activo = false or not coalesce(v.cuota_al_dia,true) then 'suspendido'
    else 'vigente' end;

  return json_build_object(
    'estado', v_estado,
    'codigo', v.codigo,
    'estudio', v.estudio,
    'nro_socio', v.nro_socio,
    'beneficio', v.beneficio,
    'proveedor', v.proveedor,
    'descripcion', v.descripcion,
    'condiciones', v.condiciones,
    'creado_en', v.creado_en,
    'vence_en', v.vence_en,
    'usado_en', v.usado_en
  );
end $$;

-- 6) Canjear cupón (público: el proveedor lo marca como usado)
create or replace function public.canjear_cupon(p_codigo text, p_nota text default null)
returns json
language plpgsql security definer set search_path = public as $$
declare
  v json;
begin
  v := validar_cupon(p_codigo);
  if v ->> 'estado' <> 'vigente' then
    return v;
  end if;
  update cupones set usado_en = now(), nota = left(p_nota, 200)
   where codigo = upper(trim(p_codigo)) and usado_en is null;
  return validar_cupon(p_codigo);
end $$;

-- 7) Permisos
revoke all on function public.generar_cupon(uuid)      from public;
revoke all on function public.validar_cupon(text)      from public;
revoke all on function public.canjear_cupon(text,text) from public;
grant execute on function public.generar_cupon(uuid)      to authenticated;
grant execute on function public.validar_cupon(text)      to anon, authenticated;
grant execute on function public.canjear_cupon(text,text) to anon, authenticated;

-- 8) Estadísticas para el admin (por beneficio)
create or replace view public.cupones_stats as
  select b.id as beneficio_id, b.proveedor, b.titulo, b.activo,
         count(c.id)                                  as generados,
         count(c.id) filter (where c.usado_en is not null) as canjeados,
         count(c.id) filter (where c.usado_en is null and c.vence_en > now()) as vigentes,
         max(c.usado_en) as ultimo_canje
    from beneficios b
    left join cupones c on c.beneficio_id = b.id
   group by b.id;

-- ============================================================
-- Ejemplo de carga (editar y descomentar):
-- insert into public.beneficios (proveedor, titulo, descripcion, condiciones, contacto, dias_validez)
-- values ('Matafuegos XYZ', '20% en recarga y control anual de matafuegos',
--         'Descuento exclusivo para estudios socios de CAPIAF sobre lista de precios vigente.',
--         'Presentar el cupón antes de facturar. No acumulable con otras promociones.',
--         'https://wa.me/54911XXXXXXXX', 7);
-- ============================================================
