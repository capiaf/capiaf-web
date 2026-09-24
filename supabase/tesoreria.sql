-- Informe de Tesorería CAPIAF: cierres mensuales
-- Guarda solo el resultado de cada cierre (saldos y resumen del informe). Los archivos no se suben.
-- Acceso exclusivo para info@pilates.org.ar (RLS).

create table if not exists public.tesoreria_cierres (
  periodo     text primary key check (periodo ~ '^\d{4}-\d{2}$'),
  saldo_fin   numeric not null,          -- saldo económico al cierre (Siguefit)
  fondos      jsonb   not null,          -- {galicia, fci, mp_disp, mp_acred} según extractos
  informe     jsonb,                     -- datos del informe para volver a verlo
  controles   jsonb,
  updated_at  timestamptz not null default now(),
  updated_by  text default (auth.jwt() ->> 'email')
);

alter table public.tesoreria_cierres enable row level security;

drop policy if exists "tesoreria solo admin" on public.tesoreria_cierres;
create policy "tesoreria solo admin" on public.tesoreria_cierres
  for all to authenticated
  using ((auth.jwt() ->> 'email') = 'info@pilates.org.ar')
  with check ((auth.jwt() ->> 'email') = 'info@pilates.org.ar');

-- Cierre de arranque al 31/07/2026 (extractos Galicia cuenta y FCI, saldo MP relevado por Tesorería)
insert into public.tesoreria_cierres (periodo, saldo_fin, fondos, informe)
values ('2026-07', 11125987.26,
        '{"galicia": 1380445.24, "fci": 8810902.02, "mp_disp": 934640, "mp_acred": 0}',
        '{"nota": "Cierre de arranque según extractos al 31/07/2026"}')
on conflict (periodo) do nothing;
