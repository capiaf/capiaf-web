-- ============================================================
--  CAPIAF · Precarga de socios de Siguefit que no tienen usuario en el portal
--  + función para que el estudio reclame su ficha al registrarse con el mismo mail.
--  Ejecutar en Supabase → SQL Editor. Idempotente: no duplica.
-- ============================================================

create temp table sf (nro text, nombre text, razon text, titular text, email text, cuit text,
                      telefono text, direccion text, numero text, barrio text);
insert into sf values
('1', 'Tu Espacio', 'Adriana Mabel Rybar', 'Adriana Mabel Rybar', 'amrybar@yahoo.com.ar', '27148075129', '1164855830', 'San José de Calasanz', '15', null),
('22', 'Dyna-mov  Pilates', 'Alejandra San Martin', 'Alejandra San Martin', 'sanmartinilusiones@gmail.com', '23263979494', '1162140795', 'Gurruchaga', '403', 'Villa Crespo'),
('7', 'Mundo Pilates', 'Alejandro Faiferman', 'Alejandro Faiferman', 'alefaiferman@gmail.com', '20225034835', '1165951790', 'Mendoza', '2743', null),
('105', 'Suru Pilates', 'Alexandra Belen Argañaraz', 'Alexandra Belen Argañaraz', 'alex_bel88@hotmail.com', '23339111464', '1155798812', 'Avenida Corrientes', '1629', null),
('67', 'El Atelier Pilates', 'Ana Sabrina Rubio', 'Ana Sabrina Rubio', 'sabrirubio@gmail.com', '27317037703', '1141947590', 'Mariano Acha', '3168', 'Villa Urquiza'),
('91', 'Wellness Atelier Pilates & Bienestar', 'Anabela Pezet Vila', 'Anabela Pezet Vila', 'anaj.pv@gmail.com', '27345314712', '1121554802', 'Avenida Rivadavia', '5040', null),
('92', 'Aluminé Estudio De Pilates', 'Ananquel Rocío Corredoira', 'Ananquel Rocío Corredoira', 'ananqueltransportesescolares@gmail.com', '27338611523', '1159666421', 'Montiel', '1793', null),
('66', 'Inspiración Pilates', 'Andrea Scursatone', 'Andrea Scursatone', 'dariowgonzalez@yahoo.com.ar', '27280304021', '1167441390', 'Tinogasta', '5285', null),
('15', 'Teseo Pilates Funcional', 'Ariadna Perez', 'Ariadna Perez', 'arihagnep@gmail.com', '27345334578', '1165561210', 'Rodríguez Peña', '335', 'San Nicolás'),
('72', 'Bae Pilates', 'Barbara Ercole', 'Barbara Ercole', 'yobaps@hotmail.com', '27318971744', '1131782001', 'Avenida Luis María Campos', '311', 'Palermo'),
('32', 'Dhara Pilates', 'Barbara Valerga', 'Barbara Valerga', 'dharapilates@gmail.com', '27331957998', '1166153421', 'Coronel Ramón Lorenzo Falcón', '2212', 'Flores'),
('93', 'Bg Estudio Integral', 'Betiana González', 'Betiana González', 'betti.gonzalezmt@gmail.com', '23378603404', '154229457', 'Aráoz', '2739', null),
('5', 'Dominio Pilates', 'Camila Filace', 'Camila Filace', 'camilafilace@hotmail.com', '27306836981', '3364627585', 'Crisólogo Larralde', '3811', null),
('31', 'Iluminar Pilates&bienestar', 'Carolina Gaguin', 'Carolina Gaguin', 'carolinagaguin@gmail.com', '27337113708', '1154654107', 'Tonelero', '7400', 'Liniers'),
('80', 'Concepto Pilates', 'Carolina Torelli', 'Carolina Torelli', 'conceptopilatesreformer@gmail.com', '27334030208', '1131544798', 'Avenida de los Incas', '4790', 'Parque Chas'),
('81', 'ÂMe Pilates Body Ballet', 'Carolina Vazquez', 'Carolina Vazquez', 'carochevaz@gmail.com', '27313635436', '1137629676', 'Agüero', '1595', 'Barrio Norte'),
('94', 'Esencia Pilates', 'Cecilia Silva', 'Cecilia Silva', 'gcfitness@gmail.com', '27284979821', '1122493852', 'Formosa', '279', null),
('13', 'Dipfusionpilateslab', 'Christian Gabriel Dip', 'Christian Gabriel Dip', 'cgabrieldip@gmail.com', '20349980933', '1124079922', 'Virrey Avilés', '3153', 'Colegiales'),
('9', 'Pilates Studio Barracas', 'Clara Pérez Fiorentini', 'Clara Pérez Fiorentini', 'pilatestudioba@gmail.com', '27295038050', '1164468759', 'Jovellanos', '294', 'Barracas'),
('16', 'Danez Pilates & Funcional', 'Daniela Gutiérrez', 'Daniela Gutiérrez', 'danezcuenca@gmail.com', '27332106851', '1140898877', 'Cuenca', '2118', 'Villa Santa Rita'),
('85', 'Cinesia Pilates', 'Debora Boda', 'Debora Boda', 'cinesiapilates@gmail.com', '27233261454', '1155718926', 'Espinosa', '2024', 'La Paternal'),
('64', 'Naapura Cuerpo Y Equilibrio', 'Elena Tato', 'Elena Tato', 'naylaalvarez@yahoo.com.ar', '27924864708', '1158095798', 'Fraga', '599', 'Chacarita'),
('29', 'Club Palermo Pilates', 'Emmanuel Lucieri', 'Emmanuel Lucieri', 'info@clubpalermopilates.com.ar', '20290382492', '1155252681', 'Armenia', '2294', 'Palermo'),
('95', 'Body Life Pilates', null, 'Fabiana Diaz', 'fitnessdesignsa@gmail.com', '30710883986', '1151150607', null, null, null),
('4', 'Fabiana Tallarico Pilates', 'Fabiana Tallarico', 'Fabiana Tallarico', 'fabiana.pilates4451@gmail.com', '27178027730', '1151466195', 'Guatemala', '4375', null),
('108', 'Estudio Fluxus', 'Federico Bagnato', 'Federico Bagnato', 'fluxuspilates@gmail.com', '20332732510', '11 36781859', 'Quito', '3886', null),
('71', 'Espacio Balance', 'Federico Dupont', 'Federico Dupont', 'fedeperezmail@gmail.com', '20255404459', '1158207836', 'Moldes', '1596', 'Belgrano'),
('18', 'Studio Recoleta Pilates', 'Fernando Franco', 'Fernando Franco', 'fernandosanto17@hotmail.com', '20329490875', '1134756495', 'Austria', '2282', 'Recoleta'),
('104', 'Biofeel', 'Florencia Casóliba', 'Florencia Casóliba', 'florcasoliba@yahoo.com.ar', '27267735862', '1162133360', 'Quintana', '4640', null),
('36', 'Tan Tiem Pilates', 'Gabriela Baschiera', 'Gabriela Baschiera', 'gabybaschiera@yahoo.com.ar', '27256592539', '1141578378', 'Ituzaingó', '701', 'Barracas'),
('24', 'Bienestar y Equilibrio Pilates', 'Gabriela Marino', 'Gabriela Marino', 'marinogabrielalau@gmail.com', '27215329785', '1126459432', 'Julián Álvarez', '1148', null),
('42', 'Munay Pilates', 'Gabriela Reta', 'Gabriela Reta', 'cgabrielareta@gmail.com', '27326180004', '1132195798', 'Guardia Vieja', '3318', 'Almagro'),
('49', 'Raisa Pilates', 'Giovanna Carimati', 'Giovanna Carimati', 'giovannacarimati@gmail.com', '27357280740', '1130583794', 'Juan Ramírez de Velasco', '1481', 'Villa Crespo'),
('44', 'Palace Pilates', 'Giselle Sosa', 'Giselle Sosa', 'palacepilates1@gmail.com', '27344193555', '11 66416619', 'Cabello', '3627', 'Palermo'),
('19', 'Fuentes Cufré', 'Guadalupe', 'Guadalupe', 'guadalupecufre@gmail.com', '27311504997', '1141966503', 'Ramón Falcón', '6500', 'Liniers'),
('96', 'Ginkgo Pilates', 'Hernan Rocha Maradini', 'Hernan Rocha Maradini', 'hernirocha@gmail.com', '20225005339', '1139231434', 'Valle', '207', null),
('87', 'Holistica Yoga & Pilates', 'Jesica Josiowicz', 'Jesica Josiowicz', 'jesicajosiowicz@gmail.com', '27316416468', '1161036293', 'Virrey Liniers', '71', 'Almagro'),
('55', 'Mixtura Pilates', 'Jimena Di Giacomo', 'Jimena Di Giacomo', 'mixtura.pilates.estetica@gmail.com', '27279380687', '1130675544', 'Nicolas Repetto', '1293', 'Caballito'),
('78', 'Energia Vital Pilates', 'Jorge Danilo Barboza De Cesaro', 'Jorge Danilo Barboza De Cesaro', 'energiavitalpilates@gmail.com', '20928818854', '1159332818', 'Palpa', '2468', 'Colegiales'),
('82', 'Corpuspilates', 'Josefina Falcone', 'Josefina Falcone', 'josefinafalcone@hotmail.com', '27318263561', '1132003208', 'General Urquiza', '1180', 'San Cristóbal'),
('37', 'Pura Vida Yoga Y Pilates', 'Juan Arnaldi', 'Juan Arnaldi', 'juanarnaldi@hotmail.com', '20320334358', '132279625', 'Adolfo P. Carranza', '2137', 'Palermo'),
('109', 'Juan Sosa Pilates Estudio', 'Juan Daniel Sosa Jardinez', 'Juan Daniel Sosa Jardinez', 'juandanielsosajardinez@gmail.com', '20406322425', '1161188178', 'Avenida Corrientes', '3859', null),
('23', 'Centropilates', 'Leticia Pompei', 'Leticia Pompei', 'pompeileticia@gmail.com', '27266906264', '1150105445', 'Avenida Santa Fe', '3312', null),
('40', 'Health Studio Pilates', 'Lidia Beatriz Dominguez', 'Lidia Beatriz Dominguez', 'lidiaarabean@gmail.com', '27129751539', '1144199626', 'Avenida Ángel Gallardo', '717', null),
('25', 'Cuerpoespiral', 'Lila Morena Acuña', 'Lila Morena Acuña', 'cuerpoespiral@gmail.com', '27319377706', '1167419477', 'Malabia', '376', null),
('43', 'Pilates Bren', 'Lucia Brenlla', 'Lucia Brenlla', 'lucia-brenlla@hotmail.com', '27329834285', '1164534923', 'Cullen', '5209', null),
('27', 'Delbuono Pilates', 'Luciana Delbuono', 'Luciana Delbuono', 'delbuonopilates@gmail.com', '23314476344', '1131506149', 'Superí', '3100', null),
('107', 'Pilates Para Vos Microcentro', 'Magali Brey Medina Mathyas', 'Magali Brey Medina Mathyas', 'magali.brey@yahoo.com.ar', '27367393756', '1168000875', 'Tucumán', '811', null),
('10', 'Toulouse Pilates', 'Marcelo Perez', 'Marcelo Perez', 'marceloperez2003@hotmail.com', '20259995613', '1140278519', 'Bonpland', '2363', 'Palermo Hollywood'),
('2', 'Malvon Pilates', 'Maria Celeste Martin', 'Maria Celeste Martin', 'malvonpilates@gmail.com', '27296685092', '1132504451', 'Avenida Dorrego', '2381', 'Palermo Hollywood'),
('98', 'Casa Porasy', 'María Florencia Castillo', 'María Florencia Castillo', 'mflorenciac.92@gmail.com', '27350048303', '1134236434', 'Almirante Francisco Juan Seguí', '343', null),
('86', 'Piuké', 'Maria Jose Battiman', 'Maria Jose Battiman', 'agucabral@yahoo.com.ar', '23209567644', '1150223756', 'Avenida Boedo', '1780', 'Boedo'),
('26', 'Bienestar En Movimiento', 'Maria Julia Grisafi', 'Maria Julia Grisafi', 'mjuliagrisafi@gmail.com', '27270087103', '1134426102', 'Julián Álvarez', '563', 'Villa Crespo'),
('103', 'Maria Laura Studio', 'Maria Laura Berardo', 'Maria Laura Berardo', 'berardomarialaura@gmail.com', '27230109171', '1149161451', 'Jerónimo Salguero', '2142', null),
('34', 'Corporal Centro De Bienestar Físico', 'María Laura Epelde', 'María Laura Epelde', 'corporal.pilates@hotmail.com', '27361179922', '1126467438', 'Julián Álvarez', '2672', 'Palermo'),
('14', 'Tempo Libero Pilates', 'Maria Laura Mattioli', 'Maria Laura Mattioli', 'lalimattioli_1983@hotmail.com', '27305263600', '1136840415', 'Avenida Presidente Manuel Quintana', '326', 'Barrio Norte'),
('56', 'Genki Pilates', 'Martin Shimojo', 'Martin Shimojo', 'helllman@hotmail.com', '20312070392', '1159762915', 'Jerónimo Salguero', '518', null),
('57', 'Estudio Core Ba Pilates', 'Melisa Fernandes Dos Reis', 'Melisa Fernandes Dos Reis', 'melisafdosreis@gmail.com', '27369505241', '1165980312', 'Pasco', '796', 'Balvanera'),
('33', 'Pilates Urquiza', 'Monica Albert', 'Monica Albert', 'urquizapilates@gmail.com', '27146181371', '1158219289', 'Blanco Encalada', '5202', 'Villa Urquiza'),
('45', 'Plena Pilates', 'Monica Lizarriaga', 'Monica Lizarriaga', 'mlizarriaga@gmail.com', '23264619114', '1157575831', 'Paraguay', '643', 'Retiro'),
('21', 'Gloss Fit', 'Myriam Lorena Quintana', 'Myriam Lorena Quintana', 'myri38@hotmail.com', '23255020684', '1159124511', 'Aníbal Troilo', '976', 'Almagro'),
('99', 'Aprile Pilates', 'Natalia Capellano', 'Natalia Capellano', 'natiuma82@hotmail.com', '27298667970', '1153852010', null, null, null),
('77', 'Ayres De Barracas', 'Natalia Marchetti', 'Natalia Marchetti', 'nataliajmarchetti@hotmail.com', '27276586977', '1140444907', 'Isabel la Católica', '362', null),
('6', 'Movepilates', 'Natalia Nuñez Cavadini', 'Natalia Nuñez Cavadini', 'ncavadini@hotmail.com', '27242285544', '1173694467', 'Avenida Francisco Beiró', '4492', null),
('88', 'Casa De Movimiento', 'Noelia Confalonieri', 'Noelia Confalonieri', 'confalonierinoelia@gmail.com', '27356371696', '1135034468', 'Libertad', '400', 'San Nicolás'),
('83', 'Norma Novelino', 'Norma Novelino', 'Norma Novelino', 'nnovelino@yahoo.com.ar', '27131274438', '1141632100', 'Avenida Varela', '1153', 'Flores'),
('106', 'Kynur', 'Nuria Mariela Báez Grosso', 'Nuria Mariela Báez Grosso', 'mariela.nbg@gmail.com', '27310134584', '1130078844', 'Amenábar', '30', null),
('100', 'Nuri Fit Pilates', 'Nurit Lilian Schapiro', 'Nurit Lilian Schapiro', 'nuritschapira@hotmail.com', '27188760754', null, null, null, null),
('101', 'Espacio Luz Yoga Y Pilates', 'Paula Sol Santillán', 'Paula Sol Santillán', 'sol.santillan@gmail.com', '27302193032', '1156022520', null, null, 'Flores'),
('35', 'Pillpi Espacio Corporal', 'Paula Sosa', 'Paula Sosa', 'paulasosa.fitness@gmail.com', '27269487467', '1136841331', 'Aizpurúa', '2834', 'Villa Urquiza'),
('73', 'Romanza.ba', 'Pilar Bravo Hansen', 'Pilar Bravo Hansen', 'pbravohansen@yahoo.com.ar', '27223636719', '1164536971', 'Habana', '3760', null),
('102', 'Club Pilates', 'Sati Devi Gimenez', 'Sati Devi Gimenez', 'satigimenez@gmail.com', '27399113038', '1157335720', 'Sarmiento', '4101', null),
('12', 'Bive Pilates', 'Soledad Velez', 'Soledad Velez', 'soledadvelez@hotmail.com', '27319285275', '1160020765', 'Avenida Rivadavia', '10814', 'Liniers'),
('53', 'Palermo Pilates', 'Tatiana Ramirez', 'Tatiana Ramirez', 'taty_614@hotmail.com', '23307305674', '1121853020', 'Darregueyra', '2387', null),
('89', 'Indigo Pilates', 'Violeta Matorras', 'Violeta Matorras', 'vaio@live.com.ar', '27318594061', '1150512727', 'Malvinas Argentinas', '292', 'Caballito');

-- 1) Crear ficha aprobada (sin usuario) para cada socio activo que no exista por CUIT ni por mail
insert into public.estudios (nombre, email, telefono, direccion, numero, barrio, responsable,
                             razon_social, cuit, nro_socio, aprobado, activo, paramedic_estado)
select sf.nombre, sf.email, sf.telefono, sf.direccion, sf.numero, sf.barrio, sf.titular,
       sf.razon, sf.cuit, sf.nro, true, true, 'pendiente'
  from sf
 where not exists (select 1 from public.estudios e
                    where e.cuit = sf.cuit or lower(trim(e.email)) = sf.email);

-- 2) Completar CUIT/razón social en fichas existentes que aún no lo tengan (por nro, mail o nombre)
update public.estudios e set cuit = sf.cuit, razon_social = coalesce(nullif(e.razon_social,''), nullif(sf.razon,''))
  from sf where e.cuit is null and (trim(e.nro_socio) = sf.nro or lower(trim(e.email)) = sf.email
     or regexp_replace(lower(e.nombre),'[^a-z0-9]','','g') = regexp_replace(lower(sf.nombre),'[^a-z0-9]','','g'));

-- 3) Reclamar ficha: al iniciar sesión, si hay una ficha precargada con el mismo mail y sin usuario, se la asigna
create or replace function public.reclamar_ficha()
returns uuid language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if auth.uid() is null then return null; end if;
  select id into v_id from estudios where user_id = auth.uid() limit 1;
  if v_id is not null then return v_id; end if;
  update estudios set user_id = auth.uid()
   where user_id is null and lower(trim(email)) = lower(coalesce(auth.jwt() ->> 'email',''))
   returning id into v_id;
  return v_id;
end $$;
grant execute on function public.reclamar_ficha() to authenticated;

-- ── Control ──
select 'TOTAL APROBADOS' as control, count(*)::text as n from public.estudios where aprobado and coalesce(activo,true)
union all select 'CON CUIT', count(*)::text from public.estudios where aprobado and cuit is not null
union all select 'SIN USUARIO (precargados)', count(*)::text from public.estudios where user_id is null
union all select 'SOCIOS SIGUEFIT NO ENCONTRADOS', count(*)::text from sf where not exists (select 1 from public.estudios e where e.cuit = sf.cuit);
