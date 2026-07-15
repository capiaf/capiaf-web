-- ══════════════════════════════════════════════
-- CAPIAF — Setup de base de datos en Supabase
-- Ejecutar en Supabase > SQL Editor
-- ══════════════════════════════════════════════

-- 1. Tabla de perfiles de estudios
CREATE TABLE IF NOT EXISTS estudios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  email TEXT,
  telefono TEXT,
  instagram TEXT,
  direccion TEXT,
  numero TEXT,
  barrio TEXT,
  localidad TEXT DEFAULT 'Buenos Aires',
  lat NUMERIC(10,7),
  lng NUMERIC(10,7),
  logo_url TEXT,
  descripcion TEXT,
  aprobado BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabla de sedes adicionales
CREATE TABLE IF NOT EXISTS sedes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  estudio_id UUID REFERENCES estudios(id) ON DELETE CASCADE,
  nombre TEXT,
  direccion TEXT,
  numero TEXT,
  barrio TEXT,
  lat NUMERIC(10,7),
  lng NUMERIC(10,7),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Row Level Security — cada estudio solo ve sus propios datos
ALTER TABLE estudios ENABLE ROW LEVEL SECURITY;
ALTER TABLE sedes ENABLE ROW LEVEL SECURITY;

-- Políticas para estudios
CREATE POLICY "Usuarios ven su propio estudio"
  ON estudios FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuarios editan su propio estudio"
  ON estudios FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Usuarios crean su estudio"
  ON estudios FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Admin ve todo (reemplazar con tu email)
CREATE POLICY "Admin ve todo"
  ON estudios FOR ALL
  USING (auth.email() = 'camaradepilatescaba@gmail.com');

-- Políticas para sedes
CREATE POLICY "Usuarios ven sus sedes"
  ON sedes FOR SELECT
  USING (estudio_id IN (SELECT id FROM estudios WHERE user_id = auth.uid()));

CREATE POLICY "Usuarios editan sus sedes"
  ON sedes FOR ALL
  USING (estudio_id IN (SELECT id FROM estudios WHERE user_id = auth.uid()));

-- 4. Storage bucket para logos
INSERT INTO storage.buckets (id, name, public)
VALUES ('logos', 'logos', true)
ON CONFLICT DO NOTHING;

CREATE POLICY "Logos públicos"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'logos');

CREATE POLICY "Usuarios suben su logo"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'logos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Usuarios actualizan su logo"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'logos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- 5. Función para updated_at automático
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER estudios_updated_at
  BEFORE UPDATE ON estudios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ✅ Setup completo
