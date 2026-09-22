# Teste DISC — Candidatos

Sistema independente para aplicar o teste de perfil comportamental DISC em **candidatos a vagas**, sem exigir login do candidato. A equipe de RH gera um link individual, envia por e-mail, e acompanha os resultados em um painel próprio.

Feito com React + Vite + Supabase, no mesmo modelo do Feedback Hub.

## Como funciona

1. A pessoa do RH faz **login** no painel administrativo
2. Clica em **"Gerar Link"** (pode informar a vaga, opcional)
3. Copia o link ou envia direto por e-mail para o candidato
4. O candidato abre o link (sem precisar de login), preenche **nome, CPF e e-mail**, e responde ao teste DISC (25 perguntas)
5. Ao final, o candidato vê o **próprio perfil DISC** (com gráfico) e uma mensagem de agradecimento
6. A equipe de RH também vê o resultado completo de cada candidato no painel, na aba **Candidatos**

## Passo a passo para colocar no ar

### 1. Criar um projeto no Supabase
1. Acesse [supabase.com](https://supabase.com) e crie um novo projeto (pode ser gratuito)
2. Espere o projeto terminar de provisionar (~2 minutos)
3. Vá em **SQL Editor** → cole o conteúdo do arquivo `sql/01-setup.sql` → clique em **Run**
4. Vá em **Settings → API** e copie:
   - **Project URL**
   - **anon public key**

### 2. Configurar as credenciais no código
1. Abra o arquivo `src/App.jsx`
2. Nas primeiras linhas, substitua:
   ```js
   const SUPABASE_URL = "COLE_AQUI_A_SUPABASE_URL";
   const SUPABASE_KEY = "COLE_AQUI_A_SUPABASE_ANON_KEY";
   ```
   pelos valores copiados no passo anterior.

### 3. Subir para o GitHub
1. Crie um novo repositório no GitHub (ex: `disc-candidatos`)
2. Envie todos os arquivos deste projeto para lá (pelo site do GitHub: **Add file → Upload files**, ou via Git)

### 4. Publicar na Vercel
1. Acesse [vercel.com](https://vercel.com) → **New Project**
2. Selecione o repositório que você acabou de criar
3. A Vercel detecta automaticamente que é um projeto Vite — não precisa mudar nada
4. Clique em **Deploy**

### 5. Primeiro acesso
- Acesse o link gerado pela Vercel
- Login: `admin` — Senha: `admin123`
- **Troque essa senha imediatamente** (ícone 🔑 no rodapé do menu, depois de logar)

## Estrutura de dados (Supabase)

| Tabela | O que guarda |
|---|---|
| `users` | Login da equipe de RH |
| `candidates` | Um registro por link gerado (nome/CPF/e-mail preenchidos pelo próprio candidato) |
| `disc_results` | Resultado do teste de cada candidato que respondeu |

## Observações importantes

- **CPF**: o sistema faz uma validação matemática básica do CPF (dígitos verificadores), mas não confirma se a pessoa é realmente dona daquele CPF.
- **LGPD**: como o sistema coleta CPF e e-mail de candidatos, trate esses dados com o mesmo cuidado de qualquer outra informação pessoal sensível da empresa (acesso restrito à equipe de RH, política de retenção de dados, etc.).
- **Envio de e-mail**: assim como no Feedback Hub, o botão "Enviar por E-mail" abre o programa de e-mail padrão do computador (via `mailto:`). Se o computador não tiver nenhum programa de e-mail associado, use o botão "Copiar Link" e cole manualmente no e-mail.
- Este projeto é **totalmente independente** do Feedback Hub — usa seu próprio banco de dados Supabase, seu próprio repositório GitHub e seu próprio projeto Vercel.
