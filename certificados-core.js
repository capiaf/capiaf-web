// Emparejador de certificados de Paramedic contra el padron de domicilios.
// El PDF trae tres datos: razon social, CUIT y direccion. El CUIT solo no
// alcanza (11 titulares tienen mas de un domicilio), pero CUIT + direccion
// es unico en el padron.
const soloDigitos = s => String(s || '').replace(/\D/g, '');

const sinAcentos = s => String(s || '').normalize('NFD').replace(/[̀-ͯ]/g, '');

// "Av. Francisco Beiró 4492" y "AVENIDA FRANCISCO BEIRO 4492" tienen que dar igual
const normDir = s => sinAcentos(s).toLowerCase()
  .replace(/\bavda?\b\.?/g, 'av').replace(/\bavenida\b/g, 'av')
  .replace(/\bdr\b\.?/g, 'dr').replace(/\bgral\b\.?/g, 'general')
  .replace(/\bcnel\b\.?/g, 'coronel').replace(/\bpte\b\.?/g, 'presidente')
  .replace(/[^a-z0-9]+/g, ' ').trim();

// El numero de puerta es lo mas discriminante: "Rivadavia 9.823" -> 9823
const alturaDe = s => {
  const m = normDir(s).match(/(\d[\d ]*)\s*$/) || normDir(s).match(/(\d+)/);
  return m ? m[1].replace(/\s/g, '') : '';
};
const calleDe = s => normDir(s).replace(/\d/g, '').replace(/\s+/g, ' ').trim();

function emparejar(cert, domicilios) {
  const cuit = soloDigitos(cert.cuit);
  const porCuit = domicilios.filter(d => soloDigitos(d.cuit) === cuit);

  if (porCuit.length === 1) return { dom: porCuit[0], confianza: 'alta', via: 'CUIT único' };

  if (porCuit.length > 1) {
    const exacto = porCuit.filter(d => normDir(d.dir) === normDir(cert.dir));
    if (exacto.length === 1) return { dom: exacto[0], confianza: 'alta', via: 'CUIT + dirección' };
    const porAltura = porCuit.filter(d => alturaDe(d.dir) === alturaDe(cert.dir) && alturaDe(cert.dir));
    if (porAltura.length === 1) return { dom: porAltura[0], confianza: 'media', via: 'CUIT + altura' };
    return { dom: null, confianza: 'ninguna', via: `CUIT repetido en ${porCuit.length} domicilios, la dirección no desempata`, candidatos: porCuit };
  }

  // Sin CUIT en el padrón: ultimo intento por direccion, siempre a revisar
  const porDir = domicilios.filter(d => normDir(d.dir) === normDir(cert.dir));
  if (porDir.length === 1) return { dom: porDir[0], confianza: 'baja', via: 'solo por dirección, el CUIT no está en el padrón' };
  return { dom: null, confianza: 'ninguna', via: 'no se encontró el CUIT ni la dirección' };
}

// En el navegador cuelga de window; en node se exporta para los tests.
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { emparejar, soloDigitos, normDir, alturaDe, calleDe };
} else {
  window.certMatcher = { emparejar, soloDigitos, normDir, alturaDe, calleDe };
}
