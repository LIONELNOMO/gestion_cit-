-- ============================================
-- GESTION CITE — Schema Supabase
-- Coller ce SQL dans : SQL Editor > New Query
-- ============================================

-- 1. Table chambres
CREATE TABLE chambres (
  id            int PRIMARY KEY,
  nom_locataire text NOT NULL,
  actif         bool DEFAULT true,
  created_at    timestamptz DEFAULT now()
);

-- 2. Table paiements
CREATE TABLE paiements (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  chambre_id     int NOT NULL REFERENCES chambres(id) ON DELETE CASCADE,
  eau            int DEFAULT 0,
  lumiere        int DEFAULT 0,
  total          int DEFAULT 0,
  periode        text NOT NULL,
  date_paiement  date DEFAULT CURRENT_DATE,
  created_at     timestamptz DEFAULT now()
);

-- 3. Table extras paiement
CREATE TABLE paiement_extras (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  paiement_id  bigint NOT NULL REFERENCES paiements(id) ON DELETE CASCADE,
  label        text NOT NULL,
  montant      int NOT NULL
);

-- 4. Table depenses
CREATE TABLE depenses (
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  description   text NOT NULL,
  montant       int NOT NULL,
  categorie     text DEFAULT 'Autre',
  note          text,
  date_depense  date DEFAULT CURRENT_DATE,
  created_at    timestamptz DEFAULT now()
);

-- Index pour performance
CREATE INDEX idx_paiements_chambre ON paiements(chambre_id);
CREATE INDEX idx_paiements_periode ON paiements(periode);
CREATE INDEX idx_depenses_date ON depenses(date_depense);
CREATE INDEX idx_depenses_categorie ON depenses(categorie);

-- Activer Row Level Security (obligatoire sur Supabase)
ALTER TABLE chambres ENABLE ROW LEVEL SECURITY;
ALTER TABLE paiements ENABLE ROW LEVEL SECURITY;
ALTER TABLE paiement_extras ENABLE ROW LEVEL SECURITY;
ALTER TABLE depenses ENABLE ROW LEVEL SECURITY;

-- Politique : accès public (anon) pour l'instant
-- Tu pourras restreindre plus tard avec un login
CREATE POLICY "Acces public chambres" ON chambres FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acces public paiements" ON paiements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acces public extras" ON paiement_extras FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acces public depenses" ON depenses FOR ALL USING (true) WITH CHECK (true);
