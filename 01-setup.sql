-- ============================================================
-- SETUP COMPLETO — Teste DISC para Candidatos
-- Rode este script UMA VEZ no SQL Editor do seu projeto Supabase
-- ============================================================

-- Extensão necessária para gerar o hash da senha padrão abaixo
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. USUÁRIOS (equipe de RH e administradores que acessam o painel)
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT DEFAULT 'rh',           -- admin | rh
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. CANDIDATOS (um registro por link/convite gerado)
CREATE TABLE IF NOT EXISTS candidates (
  id TEXT PRIMARY KEY,              -- também usado como token do link (?token=ID)
  name TEXT DEFAULT '',
  cpf TEXT DEFAULT '',
  email TEXT DEFAULT '',
  empresa TEXT DEFAULT '',          -- DUX Trucking | DUX Agenciamento | DUX Express | DUX France | DUX US
  vaga TEXT DEFAULT '',
  status TEXT DEFAULT 'Pendente',   -- Pendente | Respondido
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  answered_at TIMESTAMPTZ
);

-- 3. RESULTADOS DO TESTE DISC
CREATE TABLE IF NOT EXISTS disc_results (
  id TEXT PRIMARY KEY,
  candidate_id TEXT NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
  candidate_name TEXT NOT NULL,
  scores_mais JSONB,
  scores_menos JSONB,
  perfil_mais TEXT,
  perfil_menos TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. USUÁRIO ADMINISTRADOR PADRÃO
-- Login: admin | Senha: admin123
-- ⚠️ TROQUE ESSA SENHA assim que acessar o sistema pela primeira vez
-- (use o ícone de chave 🔑 no rodapé do menu, dentro do sistema)
INSERT INTO users (id, username, name, password_hash, role) VALUES
('admin', 'admin', 'Administrador', encode(digest('admin123', 'sha256'), 'hex'), 'admin')
ON CONFLICT (username) DO NOTHING;

-- MIGRAÇÃO: se você já rodou este script ANTES de a coluna "role" existir,
-- rode as duas linhas abaixo separadamente para atualizar o banco:
-- ALTER TABLE users ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'rh';
-- UPDATE users SET role = 'admin' WHERE username = 'admin';

-- MIGRAÇÃO: se você já rodou este script ANTES de a coluna "empresa" existir
-- na tabela candidates, rode a linha abaixo separadamente:
-- ALTER TABLE candidates ADD COLUMN IF NOT EXISTS empresa TEXT DEFAULT '';

-- ============================================================
-- SEGURANÇA (RLS) — Row Level Security
-- ============================================================
-- Este sistema usa a "anon key" do Supabase diretamente no navegador,
-- assim como o Feedback Hub. Isso é seguro desde que:
-- 1. O RLS esteja habilitado nas tabelas acima
-- 2. As policies liberem apenas o necessário (leitura/escrita controlada pela aplicação)
--
-- Se quiser reforçar a segurança, habilite RLS assim:
--
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE disc_results ENABLE ROW LEVEL SECURITY;
--
-- CREATE POLICY "allow all" ON users FOR ALL USING (true) WITH CHECK (true);
-- CREATE POLICY "allow all" ON candidates FOR ALL USING (true) WITH CHECK (true);
-- CREATE POLICY "allow all" ON disc_results FOR ALL USING (true) WITH CHECK (true);
--
-- (Isso replica o comportamento padrão sem RLS, mas de forma explícita.
--  Para um controle mais rigoroso, seria necessário Supabase Auth, o que
--  exigiria mudanças maiores na aplicação.)
