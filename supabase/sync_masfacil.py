"""
Sincroniza las cuotas de CAPIAF facturadas en Facturo Más Fácil hacia Supabase (tabla `cuotas`).

Correr como job diario en Railway (o como endpoint interno protegido) dentro del proyecto de Más Fácil.
Variables de entorno necesarias en Railway:
  CAPIAF_SUPABASE_URL          = https://rpxckpqptdgkkwaqtgzz.supabase.co
  CAPIAF_SUPABASE_SERVICE_KEY  = service_role key del proyecto (NUNCA la publishable; nunca en el HTML)
  CAPIAF_CUIT                  = CUIT de CAPIAF (para filtrar los comprobantes emitidos por la Cámara)

Qué hace:
  1. Lee de la base de Más Fácil las facturas emitidas por CAPIAF cuyo concepto es la cuota social,
     una por socio y período (mes), con su estado de cobro (importado de Siguefit).
  2. Resuelve el estudio en Supabase por CUIT (estudios.cuit, y como fallback sedes.cuit).
  3. Hace upsert en `cuotas` (estudio_id + periodo). El trigger de Supabase recalcula mora y baja Paramedic.

Adaptar la función `leer_cuotas_masfacil()` al modelo real de Más Fácil (es la única parte que depende de él).
"""
import os, re, json, datetime as dt
import urllib.request

SB_URL = os.environ["CAPIAF_SUPABASE_URL"].rstrip("/")
SB_KEY = os.environ["CAPIAF_SUPABASE_SERVICE_KEY"]
HDR = {"apikey": SB_KEY, "Authorization": f"Bearer {SB_KEY}", "Content-Type": "application/json"}


def sb(method, path, payload=None, extra=None):
    hdr = dict(HDR, **(extra or {}))
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request(f"{SB_URL}/rest/v1/{path}", data=data, headers=hdr, method=method)
    with urllib.request.urlopen(req) as r:
        body = r.read()
        return json.loads(body) if body else None


def norm_cuit(v):
    return re.sub(r"\D", "", str(v or ""))


def leer_cuotas_masfacil():
    """
    TODO: reemplazar por la consulta real a la DB de Más Fácil.
    Debe devolver una lista de dicts con:
      cuit        -> CUIT del socio facturado
      periodo     -> 'YYYY-MM-01' (mes de la cuota; tomar del período del servicio de la factura)
      tipo        -> 'plena' | 'transitoria'   (inferible por importe o por ítem de la factura)
      sedes_extra -> int (cantidad de ítems "sede adicional" en la factura)
      importe     -> float
      factura     -> 'PPPP-NNNNNNNN'
      estado      -> 'pagada' | 'pendiente' | 'anulada'
      fecha_pago  -> 'YYYY-MM-DD' | None
    Ejemplo (SQLAlchemy):
      rows = session.query(Factura).filter(Factura.emisor_cuit == os.environ['CAPIAF_CUIT'],
                                           Factura.concepto.ilike('%cuota social%')).all()
    """
    raise NotImplementedError


def mapa_cuit_estudio():
    """CUIT (normalizado) -> estudio_id. Primero estudios, después sedes con CUIT propio."""
    m = {}
    for s in sb("GET", "sedes?select=cuit,estudio_id&cuit=not.is.null"):
        m.setdefault(norm_cuit(s["cuit"]), s["estudio_id"])
    for e in sb("GET", "estudios?select=id,cuit&cuit=not.is.null"):
        m[norm_cuit(e["cuit"])] = e["id"]          # el CUIT del estudio manda sobre el de una sede
    return m


def main():
    mapa = mapa_cuit_estudio()
    filas, sin_match = [], []
    for c in leer_cuotas_masfacil():
        est = mapa.get(norm_cuit(c["cuit"]))
        if not est:
            sin_match.append(c["cuit"])
            continue
        filas.append({
            "estudio_id": est,
            "periodo": c["periodo"],
            "tipo": c.get("tipo", "plena"),
            "sedes_extra": int(c.get("sedes_extra", 0)),
            "importe": c.get("importe"),
            "factura": c.get("factura"),
            "estado": c["estado"],
            "fecha_pago": c.get("fecha_pago"),
            "fuente": "masfacil",
            "updated_at": dt.datetime.utcnow().isoformat(),
        })
    if filas:
        sb("POST", "cuotas?on_conflict=estudio_id,periodo", filas,
           {"Prefer": "resolution=merge-duplicates,return=minimal"})
    print(f"upsert: {len(filas)} cuotas · sin CUIT en Supabase: {sorted(set(sin_match))}")


if __name__ == "__main__":
    main()
