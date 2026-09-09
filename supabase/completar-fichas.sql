-- ============================================================
--  CAPIAF · Completar fichas con el formulario de inscripción (2021) y los logos ya publicados
--  Solo llena campos vacíos. Ejecutar en Supabase → SQL Editor.
-- ============================================================
create temp table fx (cuit text, direccion text, numero text, barrio text, agc text, responsable text, celular text, dni_url text, logo_url text);
insert into fx values
('27266906264', 'Vilela', '2393', 'Nuñez', 'si', 'Leticia Pompei', '1150105445', 'https://drive.google.com/open?id=1yLNumoIt1l7uu6Y7zqXsp4sdWyfy7nMj, https://drive.google.com/open?id=10foQ26tVYMsE7Lw0jj3RXNDS_m6-AQz2', 'https://pilates.org.ar/logos/centropilates.jpg'),
('27334030208', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/concepto_pilates.jpg'),
('27270087103', 'Julian Alvares', '563', 'Villa Crespo', 'si', 'Maria Julia Grisafi', '1134426102', 'https://drive.google.com/open?id=1YwCIPKFVPKp2rb-wcvDf2SJir08uCAoW, https://drive.google.com/open?id=1LfTUss9bLq3aW1XTQjK8lduZAuhQpL5P', null),
('27319285275', 'Av. Rivadavia', '10814', 'Liniers', 'si', 'María Soledad Vélez', '5491122186304', 'https://drive.google.com/open?id=1-9WKmSsNz3JG6wJtjP7eoRSCzt8vf83j, https://drive.google.com/open?id=1b7LnDTeJzLKjgDlWsWTphj_D47ZwNjrX', 'https://pilates.org.ar/logos/bive_pilates.jpg'),
('27148075129', 'San José de Calasanz', '15', 'Caballito', 'si', 'Adriana Rybar', '1164855830', 'https://drive.google.com/open?id=1vqC4Hxj4CFHIUYh1sQK8_HMOcJxZmPJE, https://drive.google.com/open?id=1JGQ5XbG_v-wedhGOfWt2MmEdUwDGgrA4', 'https://pilates.org.ar/logos/tu_espacio.jpg'),
('20255404459', 'Moldes', '1596', 'Belgrano', 'si', 'Federico Dupont', '1158307836', 'https://drive.google.com/open?id=1KaSYu5toFPdWoz3VR5QyzMpIABEBmyLm, https://drive.google.com/open?id=11RBIs076WVQLXn3VBUzzG94nqWEwe20e', 'https://pilates.org.ar/logos/espacio_balance.jpg'),
('20225005339', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/ginkgo_pilates.jpg'),
('27276586977', 'Isabel la Católica', '362', 'Barracas', 'si', 'María Fernanda Mattera', '1158331810', 'https://drive.google.com/open?id=1Oy3P7SNVsDRP7Nf06uo-3kYGd7MtBCVb, https://drive.google.com/open?id=1u-U464ZKADLgtlAdEaqUPhdkZxqlmGg6', 'https://pilates.org.ar/logos/ayres_de_barracas.png'),
('27302193032', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/espacio_luz_yoga_y_pilates.jpg'),
('27313635436', 'Aguero y Santa Fe', null, 'Recoleta', 'si', 'Carolina Vazquez', '1137629676', 'https://drive.google.com/open?id=1b42y810b_gtjxtLbFgJJrWigf0JDalK8, https://drive.google.com/open?id=1simLvacz8OKiD_4snrmlTeNO9JOdt1eZ', 'https://pilates.org.ar/logos/ame_pilates.jpg'),
('27316416468', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/holistica_yoga_and_pilates.jpg'),
('23314476344', 'Superi', '3100', 'Coghlan', 'si', 'Luciana Delbuono', '1531506149', null, 'https://pilates.org.ar/logos/delbuono_pilates.jpg'),
('27318971744', 'Baez', '372', 'Palermo', null, 'Barbara Ercole', '1531782001', 'https://drive.google.com/open?id=1TYhqwGpP6UHAOrtnRpOWtNBtzyUFO1x8', 'https://pilates.org.ar/logos/bae_pilates.jpg'),
('27331957998', 'Av Rivadavia', '6433', 'Flores', null, 'Bárbara valerga', '0111566153421', null, 'https://pilates.org.ar/logos/dhara_pilates.png'),
('27319377706', 'Camargo', '402', 'Villa Crespo', 'si', 'Lila Morena Acuña', '1167419477', null, 'https://pilates.org.ar/logos/cuerpoespiral_pilates.jpg'),
('27256592539', 'Piedras', '1670', 'Barracas', null, 'Gabriela Baschiera', '1141578378', 'https://drive.google.com/open?id=1LxQBMPU_MasItDA_4cR43Heo6Frdo_2H, https://drive.google.com/open?id=1wXVmBdsQLcXNWNF_2yesDGOcGT2iXENf', null),
('27233261454', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/cinesia_pilates.jpg'),
('20329490875', 'Austria', '2282', 'Recoleta', 'si', 'Fernando Franco', '1534756495', 'https://drive.google.com/open?id=12GYLGxJKNj8jLa66t23hWq68WxeInzEf, https://drive.google.com/open?id=1Ab3AHDmlQUo4zagya1NHsIdzxNEwxC7g', 'https://pilates.org.ar/logos/studio_recoleta_pilates.png'),
('23263979494', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/dyna-mov_pilates.jpg'),
('27356371696', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/casa_de_movimiento.png'),
('23264619114', 'Florida y Paraguay', null, 'Retiro', null, 'Monica Lizarriaga', '1557575831', null, 'https://pilates.org.ar/logos/plena_pilates.jpg'),
('23255020684', 'Anibal Troilo', '976', 'Almagro', 'si', 'Myriam Quintana', '1159124511', null, 'https://pilates.org.ar/logos/gloss_fit.png'),
('27178027730', 'Guatemala', '4375', 'Palermo', 'si', 'Fabiana Tallarico', '1551466195', 'https://drive.google.com/open?id=151awVUSoD9Z4AzQnD6vuu3W7kTHI0Byv, https://drive.google.com/open?id=199_IJ1kKL7XzGUz3j8Honqq1SYsedHNs', null),
('27332106851', 'Cuenca', '2118', 'Villa del Parque', 'si', 'Daniela Gutiérrez', '1151463550', 'https://drive.google.com/open?id=1UEDDG5BlNlGiK-l9trlua3dLK0wumngP, https://drive.google.com/open?id=1xL2OH0Ojc2qOlSeronyiKj-DIpCG-Dvw', 'https://pilates.org.ar/logos/danez_pilates_and_funcional.jpg'),
('27924864708', 'Fraga', '599', 'Colegiales', 'si', 'Elena Tato', '1558095798', 'https://drive.google.com/open?id=15yk-8JA9JYTEljUqLJ870DPYaac1hJjO, https://drive.google.com/open?id=1L44fba5QGvqFGA8t2wGxA5SziEoQsN-S', 'https://pilates.org.ar/logos/naapura_cuerpo_y_equilibrio.png'),
('27298667970', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/aprile_pilates.png'),
('27337113708', 'Tonelero', '7400', 'Liniers', null, 'Carolina Gaguin', '1154654107', null, 'https://pilates.org.ar/logos/iluminar_pilates_and_bienestar.png'),
('27318263561', 'General Urquiza', '1180', 'San Cristóbal', 'si', 'Josefina Gabriela Falcone', '1132003208', 'https://drive.google.com/open?id=1JuL29j1MIHCDSchHSEKXfd_8mRAdZ0pR', null),
('27318594061', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/indigo_pilates.png'),
('27311504997', 'Escalada', '15', 'Villa Luro', null, 'Guadalupe Fuentes Cufre', '1141966503', 'https://drive.google.com/open?id=1H5rv2PEIEbBAnxY1MQ8A_PgajbY1x5mJ, https://drive.google.com/open?id=1Xx4YCPZHQEgVsSlZ4DbbYtWV7HRwZS3z', null),
('20349980933', 'Virrey Avilés', '3153', 'Colegiales', null, 'Gabriel Bergas', '1173680470', 'https://drive.google.com/open?id=1k-RLZcjMgjaoP5RcKEP68ff-lVmdS_lP, https://drive.google.com/open?id=1IvsO8nGQuhSgn63lQzcm5TX-VE5yaGxR', 'https://pilates.org.ar/logos/dipfusion_pilates_lab.jpg'),
('27361179922', 'Julián Alvarez', '2672', 'Palermo', 'si', 'María Laura epelde', '91126337622', 'https://drive.google.com/open?id=1AZeDG_qs6xw6pbuYWlUpXtaTrNQRNkYb, https://drive.google.com/open?id=1MK0Lbg25c_FqlHgrXasb5eYLNt_Htbfa', 'https://pilates.org.ar/logos/corporal_centro_de_bienestar_fisico.png'),
('27326180004', 'Guardia Vieja y Aguero', null, 'Almagro', null, 'Gabriela Reta', '1132195798', 'https://drive.google.com/open?id=1BMBawBo3Pn4HR8dud3DkVVvq_naJAF2t, https://drive.google.com/open?id=1Jpj2Twi144h0SLQi6OqYgYbhssr2DfM5', 'https://pilates.org.ar/logos/munay_pilates.jpg'),
('27129751539', 'Angel Gallardo', '717', 'Villa Crespo', 'si', 'Nazarena Arabean', '1144199626', null, 'https://pilates.org.ar/logos/health_studio_pilates.png'),
('20312070392', 'Jerónimo Salguero', '518', 'Almagro', 'si', 'Martín shimojo', '1159762915', 'https://drive.google.com/open?id=1AI6fuWH0uJY9Cuua5YaF_xFHlr5ZAVTe, https://drive.google.com/open?id=1-rIByBhQu2I7T7YzQEuZLmiOUljQSUC5', null),
('27329834285', 'Pacheco', '2735', 'Villa Urquiza', 'si', 'Lucía brenlla', '1564534923', 'https://drive.google.com/open?id=1NCktA4TilfKtKASD9kbs6YhfSvSFYVLt, https://drive.google.com/open?id=1W9wUqo5CvDhZwHO0WaSGl2y9iPFmbRZ1', 'https://pilates.org.ar/logos/pilates_bren.jpg'),
('27317037703', 'Mariano Acha', '3168', 'Villa Urquiza', 'si', 'Ana Sabrina Rubio', '1141947590', 'https://drive.google.com/open?id=1WGXrfd9pQRLSxp5Wa0oeLeqz3oCzuEcB, https://drive.google.com/open?id=1iis_DPdjU4x_nqkpFrpyaQhDjeTZVk7K', 'https://pilates.org.ar/logos/el_atelier_pilates.jpg'),
('27146181371', 'Balnco Encalada', '5202', 'Villa Urquiza', 'si', 'Albert Monica', null, null, null),
('27279380687', 'Amberes', '1071', 'Caballito', 'si', 'Jimena Di giacomo', '1130675544', 'https://drive.google.com/open?id=1s8OqDSeaGm4v2TBlcdbPQgNlPJWyL0tM, https://drive.google.com/open?id=1yYC2qJ2NhaaNrhfMTPxn63TzlPA1z_w6', 'https://pilates.org.ar/logos/mixtura_pilates.png'),
('20928818854', 'palpa', '2468', 'Colegiales', null, 'Jorge De Césaro', '1559332818', 'https://drive.google.com/open?id=1PG_q5Yf38Acy_Lel-I09POx5wtm1pCsc, https://drive.google.com/open?id=1ELUoeKwovPcQSKiLBoUy_nefvbTkSX8_', 'https://pilates.org.ar/logos/energia_vital_pilates.png'),
('20320334358', 'Carranza', '2317', 'Palermo', 'si', 'Juan Arnaldi', '1132279625', 'https://drive.google.com/open?id=1PCvSZy2tFGWbT6cQ4AwG7-d0osr8mpxu, https://drive.google.com/open?id=1jgnTCPuVSuDosavO8aU0rGIuQ54B-z1V', 'https://pilates.org.ar/logos/pura_vida_yoga_y_pilates.png'),
('27242285544', 'Avenida Francisco Beiro', '4492', 'Villa Devoto', 'si', 'Natalia Nuñez Cavadini', '1173694467', 'https://drive.google.com/open?id=1mTD_AnsZXo3Kc3-M1lZGdFI1mJhRQHnQ', 'https://pilates.org.ar/logos/movepilates.png'),
('27344193555', 'Cabello', '3627', 'Palermo', null, 'Giselle Sosa', '1166416619', 'https://drive.google.com/open?id=1UFppK_cac8kQxC9zFERZC825pSgTElR0, https://drive.google.com/open?id=1I71StigrbkbJzh7AJZ85hyVlpT0hwJaK', 'https://pilates.org.ar/logos/palace_pilates.jpg'),
('27296685092', 'Dorrego', '2381', 'Palermo', 'si', 'María Celeste Martin', '1132504451', 'https://drive.google.com/open?id=1vcK71xXYNOsZLWXNoVa0GItUjWCeYkqX, https://drive.google.com/open?id=1GrCV3wNsDzPBzKXIHyA4y8OvIP3DqQkl', 'https://pilates.org.ar/logos/malvon_pilates.jpg'),
('23307305674', 'Darregueyra', '2387', 'Palermo', 'si', 'Tatiana Ramirez', '1121853020', 'https://drive.google.com/open?id=1cIDMd1MWBKhEX_C12UQYGIE2XgVa-vhS, https://drive.google.com/open?id=1nVZj0x4HEBKOtCBKxlC7VVRlPGCJyYTj', 'https://pilates.org.ar/logos/palermo_pilates.png'),
('27305263600', 'Av. Quintana', '326', 'Recoleta', 'si', 'María Laura Mattioli', '1123126843', 'https://drive.google.com/open?id=1CpYw7ZqHL79BghzeWKoNtNAoTyn1l5ul, https://drive.google.com/open?id=11YGFv8XapHC5G73_zbD2LwagagEBJzw5', 'https://pilates.org.ar/logos/tempo_libero_pilates.webp'),
('27295038050', 'Jovellanos', '294', 'Barracas', 'si', 'Clara Pérez Fiorentini', '1164468759', 'https://drive.google.com/file/d/1e7HiVxJQrOT5tXvcqqxNtwC7sxTd9dCF/view?usp=drive_link', null),
('27215329785', 'Julián alvarez', '1148', 'Villa Crespo', null, 'Gabriela laura Marino', '1126459432', 'https://drive.google.com/open?id=1XtiDKkMP4V_Y57g5KD9NH_24TCYwDLW-, https://drive.google.com/open?id=1cx2Oh7uIjxovatSCnwrXqJukKooLDuY5', 'https://pilates.org.ar/logos/bienestar_en_equilibrio.png'),
('27357280740', 'Velasco', '1481', 'Villa Crespo', null, 'Giovanna Carimati', '1130583794', 'https://drive.google.com/open?id=1gH1r3NvaFSJx3U6xUf7qeGQn8Tq4g9iJ', 'https://pilates.org.ar/logos/raisa_pilates.png'),
('20225034835', 'Mendoza', '2743', 'Belgrano', 'si', 'Alejandro Faiferman', '1165951790', 'https://drive.google.com/open?id=1KcE1rPsDPMb_zsWAwjDN5cyW6IhWK9pC, https://drive.google.com/open?id=1248UT0E8szsYKMqgcwSs_uLfzBbtzhcZ', null),
('27345334578', 'Rodriguez Peña', '336', 'Balvanera', 'si', 'Ariadna Perez', '1565561210', 'https://drive.google.com/open?id=1KYZ_I1ZmP1q33pXea0nV6XRXfUqfGVWj, https://drive.google.com/open?id=15PHXO98QBhbxwlB6KPVir6Xkv9CECc99', 'https://pilates.org.ar/logos/teseo_pilates_funcional.jpg'),
('23209567644', 'Av Boedo', '1700', 'Boedo', null, 'Agustina Cabral', '1150223756', null, 'https://pilates.org.ar/logos/piuke.png'),
('20290382492', 'Armenia', '2294', 'Palermo', null, 'Emmanuel Lucieri', '1155252681', 'https://drive.google.com/open?id=1CAcmVEPRJTFDFDZeUJY1s0-k_QHhKoic, https://drive.google.com/open?id=1DCguVi78-HYRziQwEFLfC28ERddT7aj5', 'https://pilates.org.ar/logos/club_palermo_pilates.png'),
('27306836981', 'Crisologo Larralde', '3811', 'Saavedra', 'si', 'Camila Filace', '5493364627585', 'https://drive.google.com/open?id=1ARlRXEqIR-WFuRpWI3jDxaRxKwOWHGMz, https://drive.google.com/open?id=1B0nzk5r6l31vna1E9lekN4rIn8HWWcHZ', 'https://pilates.org.ar/logos/dominio_pilates.jpg'),
('27280304021', 'Lope de Vega', '2959', 'Villa Devoto', 'si', 'Andrea Scursatone', '67441390', 'https://drive.google.com/open?id=1AcgWoyCHrjLMGKR4bPdrSxmN_Rz6dJKC, https://drive.google.com/open?id=1B1uGwD0148sLWS0Hv7vnYHmXeP_REFa1', 'https://pilates.org.ar/logos/inspiracion_pilates.webp'),
('20259995613', 'Charcas', '5033', 'Palermo', 'si', 'Marcelo Perez', '1140278519', 'https://drive.google.com/open?id=1zIYAHU88LD7ncosAJJ10engBLYB4d8S9', 'https://pilates.org.ar/logos/toulouse_pilates.jpg'),
('27269487467', 'Aizpurua', '2834', 'Villa Urquiza', null, 'Paula Sosa', '1136841331', 'https://drive.google.com/open?id=1u8R3r_t3k1mkqJN0B2gcEMhoPlLNJ3ZB, https://drive.google.com/open?id=14Y2iMNJTbEwq8vDm_AAGiTuZWyODEnzG', 'https://pilates.org.ar/logos/pillpi_espacio_corporal.png'),
('27369505241', 'Pasco', '729', 'Balvanera', 'si', 'Melisa Fernandes dos Reis', '1165980312', 'https://drive.google.com/open?id=1MnV_nMKIXJ_sq_jcohOTIgxQYVHEz_Q7, https://drive.google.com/open?id=1ogbSTa41RXfJLmz3U4kL8_PYnGBT3hJf', null),
('30710883986', null, null, null, null, null, null, null, 'https://pilates.org.ar/logos/body_life_pilates.jpg'),
('27223636719', 'Habana', '3760', 'Villa Devoto', null, 'Pilar Bravo Hansen', '1164536971', 'https://drive.google.com/open?id=1qYdLfaLBFoBFTkaRLVAEEr4XDHftKtAr, https://drive.google.com/open?id=1tsQ8GAzTiClM4lTd1iJqraTLRghHiYMT', null);

update public.estudios e set
  direccion       = coalesce(nullif(e.direccion,''), fx.direccion),
  numero          = coalesce(nullif(e.numero,''), fx.numero),
  barrio          = coalesce(nullif(e.barrio,''), fx.barrio),
  agc             = coalesce(nullif(e.agc,''), fx.agc),
  responsable     = coalesce(nullif(e.responsable,''), fx.responsable),
  telefono        = coalesce(nullif(e.telefono,''), fx.celular),
  tel_responsable = coalesce(nullif(e.tel_responsable,''), fx.celular),
  dni_url         = coalesce(nullif(e.dni_url,''), case when e.dni_frente_url is null then fx.dni_url end),
  logo_url        = coalesce(nullif(e.logo_url,''), fx.logo_url)
from fx where e.cuit = fx.cuit;

select 'CON LOGO' as control, count(*) from public.estudios where logo_url is not null and cuit is not null
union all select 'CON DNI', count(*) from public.estudios where (dni_url is not null or dni_frente_url is not null) and cuit is not null
union all select 'CON DIRECCION', count(*) from public.estudios where direccion is not null and numero is not null and cuit is not null
union all select 'CON AGC', count(*) from public.estudios where agc is not null and cuit is not null;
