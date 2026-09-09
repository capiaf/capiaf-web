-- Registro de recordatorios enviados (anti-spam)
alter table public.estudios
  add column if not exists recordatorio_enviado_at timestamptz,
  add column if not exists recordatorios_enviados  int not null default 0;
