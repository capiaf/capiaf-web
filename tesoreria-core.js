/* Informe de Tesorería CAPIAF — lógica de cálculo (sin DOM).
   Se usa desde tesoreria.html. Todo se procesa en el navegador. */
(function (root) {
  'use strict';

  const CONFIG = {
    cuota: { '2026-01': 15000, '2026-11': 50000 },           // valor de la cuota por período (desde)
    categoriasCuota: ['cuota social'],
    categoriasSede: ['sede adicional', 'sedes adicionales'],
    categoriasRendimiento: ['rendimiento fci', 'rendimientos fci'],
    egresos: {                                                 // categoría Siguefit (normalizada) -> línea
      'paramedic': 'Paramedic',
      'matafuegos': 'Matafuegos (Domer)', 'matafuegos domer': 'Matafuegos (Domer)',
      'administracion': 'Administración',
      'honorarios': 'Honorarios y trámites', 'igj': 'Honorarios y trámites', 'tramites': 'Honorarios y trámites',
      'dominio web': 'Sistemas y servicios', 'hosting': 'Sistemas y servicios', 'sistemas': 'Sistemas y servicios',
      'cargo de mercado pago': 'Comisiones Mercado Pago', 'comisiones mercado pago': 'Comisiones Mercado Pago',
      'impuesto sobre los creditos y debitos': 'Imp. créditos y débitos',
      'gastos bancarios': 'Gastos bancarios',
      'eventos': 'Otros egresos',
    },
    egresosRecurrentes: ['Administración', 'Comisiones Mercado Pago', 'Imp. créditos y débitos'],
    medioEsperado: { 'Comisiones Mercado Pago': 'Mercado Pago' },
    duplicadosOk: [['2026-08-19', 'dominio web', 8500]],
    primeraCuotaProporcional: true,
    mesesParaBaja: 3,
    paramedicDesde: '2026-11', paramedicMinimo: 80,
    objetivoMargen: { '2026-11': 30000 },
    toleranciaConciliacion: 1000,
  };
  const LINEAS_EGR = ['Paramedic', 'Matafuegos (Domer)', 'Administración', 'Honorarios y trámites', 'Sistemas y servicios',
    'Comisiones Mercado Pago', 'Imp. créditos y débitos', 'Gastos bancarios', 'Otros egresos'];
  const LINEAS_ING = ['Cuotas del período', 'Cuotas atrasadas', 'Cuotas adelantadas', 'Sedes adicionales', 'Rendimientos FCI', 'Otros ingresos'];
  const MESES = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

  // ---------- utilidades ----------
  const norm = s => String(s == null ? '' : s).normalize('NFKD').replace(/[\u0300-\u036f]/g, '').trim().toLowerCase();
  const per = (y, m) => y * 12 + (m - 1);                       // m: 1..12
  const perStr = p => String(p % 12 + 1).padStart(2, '0') + '/' + Math.floor(p / 12);
  const perDate = d => per(d.getFullYear(), d.getMonth() + 1);
  const ymd = d => d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  const vigente = (tabla, p) => { let v = null; Object.keys(tabla).sort().forEach(k => { const [y, m] = k.split('-').map(Number); if (per(y, m) <= p) v = tabla[k]; }); return v; };
  const sum = a => a.reduce((s, x) => s + x, 0);
  const r2 = x => Math.round(x * 100) / 100;
  const fmt = x => (x < 0 ? '-' : '') + '$' + Math.abs(Math.round(x)).toLocaleString('es-AR');
  const numAR = s => Number(String(s).replace(/\./g, '').replace(',', '.'));

  function toDate(v) {
    if (v instanceof Date) return new Date(v.getFullYear(), v.getMonth(), v.getDate());
    if (typeof v === 'number') { const d = new Date(Math.round((v - 25569) * 864e5)); return new Date(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()); }
    const m = String(v).match(/(\d{4})-(\d{2})-(\d{2})|(\d{2})\/(\d{2})\/(\d{4})/);
    if (!m) return null;
    return m[1] ? new Date(+m[1], +m[2] - 1, +m[3]) : new Date(+m[6], +m[5] - 1, +m[4]);
  }

  // ---------- Siguefit (.xlsx → filas) ----------
  // rows: array de arrays (SheetJS sheet_to_json {header:1}). Devuelve objetos con las columnas por nombre.
  function leerSiguefit(rows) {
    const h = rows.findIndex(r => r && String(r[0]).trim() === 'Fecha');
    if (h < 0) throw new Error('No encontré la fila de encabezados ("Fecha") en el exporte de Siguefit.');
    const cols = rows[h].map(c => String(c == null ? '' : c).trim());
    const out = [];
    for (const r of rows.slice(h + 1)) {
      if (!r || r[0] == null || r[0] === '') continue;
      const o = {}; cols.forEach((c, i) => { if (c) o[c] = r[i]; });
      o.Fecha = toDate(o.Fecha); o.Importe = Number(o.Importe) || 0;
      if (o.Fecha) out.push(o);
    }
    return out;
  }
  function tipoExporte(rows) {
    const h = rows.find(r => r && String(r[0]).trim() === 'Fecha') || [];
    const s = h.map(norm).join('|');
    if (s.includes('categoria de pago')) return 'pagos';
    if (s.includes('categoria de egreso')) return 'egresos';
    return null;
  }

  // ---------- Extractos Galicia (texto del PDF) ----------
  function leerCuentaGalicia(text) {
    const t = text.replace(/\s+/g, ' ');
    if (!/Cuenta Corriente en Pesos/i.test(t)) throw new Error('El PDF no parece un resumen de cuenta corriente de Galicia.');
    const tot = t.match(/Total \$ ?([\d.]+,\d{2}) -\$ ?([\d.]+,\d{2}) \$ ?(-?[\d.]+,\d{2})/);
    if (!tot) throw new Error('No encontré la línea "Total" del resumen de cuenta.');
    const creditos = numAR(tot[1]), debitos = numAR(tot[2]), saldoFinal = numAR(tot[3]);
    const fechas = (t.match(/\d{2}\/\d{2}\/\d{4}/g) || []).slice(0, 2).map(toDate).sort((a, b) => a - b);
    return { saldoInicial: r2(saldoFinal - creditos + debitos), creditos, debitos, saldoFinal, desde: fechas[0], hasta: fechas[1] };
  }
  function leerInversionesGalicia(text) {
    const t = text.replace(/\s+/g, ' ');
    const pos = t.match(/Posicion al (\d{2}\/\d{2}\/\d{4})/i);
    if (!pos) throw new Error('El PDF no parece un extracto de inversiones (FCI) de Galicia.');
    const corte = t.search(/Movimientos \/ Operaciones|No se han informado Movimientos/i);
    const tenencias = corte > 0 ? t.slice(0, corte) : t;
    const fondos = [...tenencias.matchAll(/(FIMA [A-Z ]+? CLASE [A-Z]) ([\d.]+,\d+) \$ ?([\d.]+,\d+) \$ ?([\d.]+,\d{2})/g)]
      .map(m => ({ fondo: m[1], cuotas: numAR(m[2]), valorCuota: numAR(m[3]), valorizado: numAR(m[4]) }));
    const movs = [...t.matchAll(/(\d{2}\/\d{2}\/\d{4}) (RESCATE|SUSCRIPCION) ([\d.]+,\d+) \$ ?([\d.]+,\d+) \$ ?([\d.]+,\d{2})/g)]
      .map(m => ({ fecha: toDate(m[1]), tipo: m[2], monto: numAR(m[5]) }));
    return {
      fecha: toDate(pos[1]), fondos, movimientos: movs,
      valuacion: r2(sum(fondos.map(f => f.valorizado))),
      suscripciones: r2(sum(movs.filter(m => m.tipo === 'SUSCRIPCION').map(m => m.monto))),
      rescates: r2(sum(movs.filter(m => m.tipo === 'RESCATE').map(m => m.monto))),
    };
  }

  // ---------- Cálculo del informe ----------
  // prev: cierre del mes anterior {saldo_fin: número, fondos: {galicia, fci, mp_disp, mp_acred}}
  function calcular({ pagos, egresos, anio, mes, prev, cuenta, inversiones, manual }) {
    manual = manual || {};
    const P = per(anio, mes);
    const ini = new Date(anio, mes - 1, 1), fin = new Date(anio, mes, 0), iniAnio = new Date(anio, 0, 1);
    const controles = [];
    const enMes = d => d >= ini && d <= fin;

    pagos = pagos.filter(r => r.Fecha <= fin).map(r => {
      const cat = norm(r['Categoría de Pago']);
      return Object.assign({}, r, {
        cat, per: Number(r['Año']) * 12 + Number(r['Mes']) - 1,
        esCuota: CONFIG.categoriasCuota.includes(cat), esSede: CONFIG.categoriasSede.includes(cat),
        esRend: CONFIG.categoriasRendimiento.includes(cat),
      });
    });
    egresos = egresos.filter(r => r.Fecha <= fin).map(r => Object.assign({}, r, {
      linea: CONFIG.egresos[norm(r['Categoría de Egreso'])] || 'Otros egresos',
    }));

    const ingresos = desde => {
      const o = {}; LINEAS_ING.forEach(k => o[k] = 0);
      pagos.filter(r => r.Fecha >= desde).forEach(r => {
        const pc = perDate(r.Fecha);
        const k = r.esCuota ? (r.per === pc ? 'Cuotas del período' : r.per < pc ? 'Cuotas atrasadas' : 'Cuotas adelantadas')
          : r.esSede ? 'Sedes adicionales' : r.esRend ? 'Rendimientos FCI' : 'Otros ingresos';
        o[k] += r.Importe;
      });
      return o;
    };
    const egr = desde => {
      const o = {}; LINEAS_EGR.forEach(k => o[k] = 0);
      egresos.filter(r => r.Fecha >= desde).forEach(r => { o[r.linea] += r.Importe; });
      return o;
    };
    const ingMes = ingresos(ini), ingAcu = ingresos(iniAnio), egrMes = egr(ini), egrAcu = egr(iniAnio);
    const totIng = sum(Object.values(ingMes)), totEgr = sum(Object.values(egrMes));

    // Saldo económico: arrastra el cierre anterior con los movimientos de Siguefit del mes
    const saldoIni = prev ? prev.saldo_fin : null;
    const saldoFin = saldoIni == null ? null : r2(saldoIni + totIng - totEgr);
    if (!prev) controles.push({ nivel: 'error', txt: 'No hay cierre del mes anterior guardado: el informe sale sin saldo inicial ni conciliación.' });

    // Fondos según extractos
    const f = {
      galicia: cuenta ? cuenta.saldoFinal : null,
      fci: inversiones ? inversiones.valuacion : null,
      mp_disp: manual.mp_disp != null && manual.mp_disp !== '' ? Number(manual.mp_disp) : null,
      mp_acred: manual.mp_acred != null && manual.mp_acred !== '' ? Number(manual.mp_acred) : 0,
    };
    const fondosCompletos = f.galicia != null && f.fci != null && f.mp_disp != null;
    const totalFondos = fondosCompletos ? r2(f.galicia + f.fci + f.mp_disp + f.mp_acred) : null;
    const conc = fondosCompletos && saldoFin != null ? r2(totalFondos - saldoFin) : null;

    // Controles de los extractos
    if (cuenta) {
      if (cuenta.hasta && perDate(cuenta.hasta) !== P) controles.push({ nivel: 'error', txt: `El resumen de cuenta es hasta el ${cuenta.hasta.toLocaleDateString('es-AR')}, no corresponde al mes informado.` });
      if (prev && prev.fondos && prev.fondos.galicia != null && Math.abs(cuenta.saldoInicial - prev.fondos.galicia) >= 1)
        controles.push({ nivel: 'error', txt: `Saldo inicial del resumen Galicia ${fmt(cuenta.saldoInicial)} distinto del cierre anterior guardado ${fmt(prev.fondos.galicia)}.` });
    } else controles.push({ nivel: 'aviso', txt: 'Falta el resumen de cuenta Galicia.' });
    let rendCalc = null;
    if (inversiones) {
      if (perDate(inversiones.fecha) !== P) controles.push({ nivel: 'error', txt: `El extracto de inversiones es al ${inversiones.fecha.toLocaleDateString('es-AR')}, no corresponde al mes informado.` });
      if (prev && prev.fondos && prev.fondos.fci != null) {
        rendCalc = r2(inversiones.valuacion - prev.fondos.fci - inversiones.suscripciones + inversiones.rescates);
        const cargado = r2(sum(pagos.filter(r => r.esRend && enMes(r.Fecha)).map(r => r.Importe)));
        if (Math.abs(rendCalc - cargado) >= 1)
          controles.push({ nivel: 'error', txt: `Rendimiento FCI según extracto ${fmt(rendCalc)} (${rendCalc.toLocaleString('es-AR', { minimumFractionDigits: 2 })}); cargado en Siguefit ${fmt(cargado)}.` });
      }
    } else controles.push({ nivel: 'aviso', txt: 'Falta el extracto de inversiones (FCI).' });
    if (f.mp_disp == null) controles.push({ nivel: 'aviso', txt: 'Falta el saldo disponible de Mercado Pago.' });
    if (conc != null && Math.abs(conc) >= CONFIG.toleranciaConciliacion)
      controles.push({ nivel: 'error', txt: `Conciliación: fondos ${fmt(totalFondos)} vs. saldo Siguefit ${fmt(saldoFin)} (dif. ${fmt(conc)}).` });

    // Socios (desde los pagos de cuota)
    const cq = pagos.filter(r => r.esCuota);
    const estado = (pHasta, corte) => {
      const g = {};
      cq.filter(r => r.Fecha <= corte).forEach(r => { (g[r.DNI] = g[r.DNI] || { ps: new Set(), nombre: r.Cliente }).ps.add(r.per); });
      const out = {};
      Object.entries(g).forEach(([cuit, v]) => {
        const p0 = Math.min(...v.ps), venc = [], pend = [];
        for (let p = p0; p <= pHasta; p++) if (!v.ps.has(p)) { pend.push(p); if (p < pHasta) venc.push(p); }
        out[cuit] = { venc, pend, pagoMes: v.ps.has(pHasta), nombre: v.nombre };
      });
      return out;
    };
    const eFin = estado(P, fin), eIni = estado(P - 1, new Date(anio, mes - 1, 0));
    const B = CONFIG.mesesParaBaja;
    const actFin = Object.keys(eFin).filter(k => eFin[k].venc.length < B);
    const actIni = Object.keys(eIni).filter(k => eIni[k].venc.length < B);
    const altas = actFin.filter(k => !actIni.includes(k)), bajas = actIni.filter(k => !actFin.includes(k));
    const mora1 = actFin.filter(k => eFin[k].venc.length === 1), mora2 = actFin.filter(k => eFin[k].venc.length >= 2);
    const pagaron = actFin.filter(k => eFin[k].pagoMes);
    const aCobrar = sum(actFin.flatMap(k => eFin[k].pend.map(p => vigente(CONFIG.cuota, p) || 0)));
    const adelantadas = sum(cq.filter(r => r.per > P).map(r => r.Importe));

    // Controles de carga
    const ok = new Set(CONFIG.duplicadosOk.map(([d, c, i]) => d + '|' + c + '|' + i));
    const vistos = {};
    egresos.forEach(r => { const k = ymd(r.Fecha) + '|' + norm(r['Categoría de Egreso']) + '|' + r.Importe + '|' + r['Medio de pago']; vistos[k] = (vistos[k] || 0) + 1; });
    Object.entries(vistos).forEach(([k, n]) => {
      const [d, c, i] = k.split('|'); const fecha = new Date(+d.slice(0, 4), +d.slice(5, 7) - 1, +d.slice(8, 10));
      if (n > 1 && !ok.has(`${d}|${c}|${i}`) && fecha >= iniAnio) controles.push({ nivel: 'aviso', txt: `Egreso posiblemente duplicado: ${d.split('-').reverse().join('/')} ${c} ${fmt(+i)}` });
    });
    const dupC = {}; cq.forEach(r => { const k = r.DNI + '|' + r.per; (dupC[k] = dupC[k] || []).push(r); });
    Object.values(dupC).filter(a => a.length > 1).forEach(a => controles.push({ nivel: 'aviso', txt: `Cuota ${perStr(a[0].per)} registrada ${a.length} veces: ${a[0].Cliente}` }));
    const primera = {}; cq.forEach(r => { primera[r.DNI] = Math.min(primera[r.DNI] ?? Infinity, r.per); });
    cq.filter(r => enMes(r.Fecha)).forEach(r => {
      const v = vigente(CONFIG.cuota, r.per);
      if (!v) return;
      if (r.Importe < v && CONFIG.primeraCuotaProporcional && primera[r.DNI] === r.per) return;
      if (r.Importe !== v) controles.push({ nivel: 'aviso', txt: `Importe distinto a la cuota vigente: ${r.Cliente}, cuota ${perStr(r.per)}, ${fmt(r.Importe)} (vigente ${fmt(v)})` });
    });
    [...new Set(egresos.filter(r => r.Fecha >= iniAnio && !CONFIG.egresos[norm(r['Categoría de Egreso'])]).map(r => r['Categoría de Egreso']))]
      .forEach(c => controles.push({ nivel: 'aviso', txt: `Categoría de egreso sin mapear (va a Otros egresos): "${c}"` }));
    Object.entries(CONFIG.medioEsperado).forEach(([l, med]) => egresos.filter(r => r.Fecha >= iniAnio && r.linea === l && r['Medio de pago'] !== med)
      .forEach(r => controles.push({ nivel: 'aviso', txt: `"${l}" del ${r.Fecha.toLocaleDateString('es-AR')} cargado con medio "${r['Medio de pago']}" (se esperaba "${med}")` })));
    CONFIG.egresosRecurrentes.forEach(l => { if (!egrMes[l]) controles.push({ nivel: 'aviso', txt: `Sin "${l}" registrado en el mes. ¿Falta cargarlo?` }); });
    mora1.concat(mora2).forEach(k => controles.push({ nivel: 'info', txt: `Adeuda ${eFin[k].venc.length} cuota(s) vencida(s): ${eFin[k].nombre} (${eFin[k].venc.map(perStr).join(', ')})` }));
    bajas.forEach(k => controles.push({ nivel: 'info', txt: `Pasa a baja por ${B} o más cuotas impagas: ${eFin[k].nombre}` }));

    const n = actFin.length, sedesAd = Number(manual.sedes_adicionales) || 0;
    const cobradoCuotas = ingMes['Cuotas del período'] + ingMes['Cuotas atrasadas'] + ingMes['Cuotas adelantadas'] + ingMes['Sedes adicionales'];
    return {
      anio, mes, periodo: `${anio}-${String(mes).padStart(2, '0')}`, titulo: `${MESES[mes - 1]} ${anio}`,
      ingMes, ingAcu, egrMes, egrAcu, totIng, totEgr,
      totIngAcu: sum(Object.values(ingAcu)), totEgrAcu: sum(Object.values(egrAcu)),
      saldoIni, saldoFin, fondos: f, fondosCompletos, totalFondos, conc, rendCalc,
      aCobrar, adelantadas, aPagar: Number(manual.a_pagar) || 0,
      socIni: actIni.length, altas: altas.length, bajas: bajas.length, socFin: n, alDia: pagaron.length,
      mora1: mora1.length, mora2: mora2.length, sedesPm: n + sedesAd,
      cobranza: n ? pagaron.length / n : null,
      margen: n ? (cobradoCuotas - egrMes['Paramedic'] - egrMes['Matafuegos (Domer)']) / n : null,
      objetivo: vigente(CONFIG.objetivoMargen, P),
      paramedicActivo: P >= per(...CONFIG.paramedicDesde.split('-').map(Number)),
      observaciones: (manual.observaciones || []).filter(Boolean).slice(0, 3),
      controles,
    };
  }

  const api = { CONFIG, LINEAS_EGR, LINEAS_ING, MESES, leerSiguefit, tipoExporte, leerCuentaGalicia, leerInversionesGalicia, calcular };
  if (typeof module !== 'undefined' && module.exports) module.exports = api; else root.TesoreriaCore = api;
})(typeof window !== 'undefined' ? window : this);
