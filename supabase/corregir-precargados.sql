-- Precargados vuelven a "pendiente" (no pasaron la validación del portal ni se publican)
update public.estudios set aprobado = false where user_id is null;

-- La nómina Paramedic ya no depende de la aprobación: cuenta ser socio activo con CUIT
create or replace view public.paramedic_nomina with (security_invoker = true) as
  select e.nro_socio, e.nombre as estudio, 'Sede principal' as sede,
         coalesce(e.razon_social,'') as razon_social, coalesce(e.cuit,'') as cuit,
         e.direccion, e.numero, e.piso, e.barrio, e.telefono, e.email,
         e.paramedic_estado, e.paramedic_alta, e.paramedic_baja, e.preaviso_vence
    from public.estudios e
   where coalesce(e.activo, true) and e.cuit is not null
  union all
  select e.nro_socio, e.nombre, coalesce(s.nombre,'Sede'),
         coalesce(s.razon_social, e.razon_social,''), coalesce(s.cuit, e.cuit,''),
         s.direccion, s.numero, null, s.barrio, e.telefono, e.email,
         e.paramedic_estado, e.paramedic_alta, e.paramedic_baja, e.preaviso_vence
    from public.sedes s join public.estudios e on e.id = s.estudio_id
   where coalesce(e.activo, true) and e.cuit is not null;

select 'APROBADOS' as control, count(*) from public.estudios where aprobado
union all select 'PENDIENTES', count(*) from public.estudios where not aprobado
union all select 'SOCIOS (activos con CUIT)', count(*) from public.estudios where coalesce(activo,true) and cuit is not null;
