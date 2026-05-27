# Plano de Trabalho - Perguntados

Este documento centraliza as definições do projeto para a **Entrega 1** conforme especificado nas instruções da disciplina.

## 1. Pessoas

- **Gerente de Projeto:** THIAGO LEAL MENEZES - Responsável pela organização do grupo, cronograma e gestão de tarefas.
- **Desenvolvedor Backend:** THIAGO LEAL MENEZES - Foco na configuração do Back4App, criação das classes e lógica da API para o jogo.
- **Desenvolvedor Frontend:** THIAGO LEAL MENEZES - Responsável pela implementação da lógica do jogo e da interface no Flutter.
- **Especialista em Banco de Dados:** IGOR OLIVEIRA DA SILVA - Modelagem das estruturas de dados no Back4App (User, Category, Question, etc.).
- **DevOps & Versionamento:** IGOR OLIVEIRA DA SILVA - Gerencia o repositório no GitHub, estrutura de branches, Pull Requests e pipelines de deploy (Vercel).

## 2. Projeto

O projeto escolhido baseia-se no tema **CloudQuiz**, e será chamado de **"Perguntados"**.
Trata-se de um jogo dinâmico de perguntas e respostas segmentadas por categorias do ensino básico. O desenvolvimento é totalmente orientado à integração com a nuvem, utilizando o **Back4App** para gerenciar a base de perguntas, autenticação dos jogadores e a manutenção do placar global competitivo em tempo real.

## 3. Tecnologias

Para maximizar a produtividade e focar na arquitetura e lógica, usaremos:

- **Frontend (PaaS / Ambiente):** Flutter Web/Mobile para a criação ágil da interface de usuário e consumo fácil de APIs.
- **Backend (BaaS):** Back4App (Parse Server), que nos oferece soluções prontas ("templates") essenciais:
  - **Autenticação de Usuários:** Cadastro, login com senha e login anônimo.
  - **CRUD e Relacionamentos:** Modelagem de categorias, perguntas e pontuação de forma rápida.

## 4. Arquitetura

O diagrama abaixo ilustra a arquitetura da aplicação "Perguntados", integrando o frontend desenvolvido em Flutter com o backend fornecido pelo Back4App, e o deploy via Vercel.

```text
 🧑 JOGADOR
   │
   │ (Interage)
   ▼
 📱 FRONTEND (Flutter Web/App)
   │
   ├── (Deploy Contínuo) ─────────▶ 🚀 VERCEL (Hospedagem Web)
   │
   │ (Comunica via Parse SDK / HTTPS)
   ▼
 ☁️ BACKEND (Back4App / Parse Server)
   │
   ├── (Gerencia Autenticação) ───▶ 🔐 AUTH USERS (Contas/Login)
   │
   └── (Saves e Consultas) ───────▶ 🗄️ DATABASE (Coleções: Categorias, Perguntas, Placar)
```

### 4.1. Versionamento

- `main`: Branch principal, espelha o código em produção (na Vercel).
- `dev`: Branch de integração, contendo as últimas alterações testadas em desenvolvimento.
- `feature/*`: Branches específicas para o desenvolvimento de novas funcionalidades (ex: `feature/login`, `feature/tela-perguntas`).
- `bugfix/*`: Branches para correções de problemas encontrados durante os testes.

O fluxo de trabalho utilizará **Pull Requests** da branch `feature` para a `dev`, garantindo revisão de código antes da integração.

## 5. Organização do Projeto

### 5.1. Escopo do Jogo

O "Perguntados" permite o cadastro e login de jogadores. O jogo consiste em escolher ou sortear uma categoria de conhecimentos (ex: Matemática, Linguagens, História, Geografia), ler uma pergunta e escolher uma de quatro alternativas antes que o tempo acabe. Respostas certas geram pontos que são sincronizados na nuvem e refletem em um ranking global competitivo.

### 5.2. Requisitos

#### 5.2.1. Requisitos Funcionais

1. O sistema deve permitir que novos jogadores criem contas e façam login no jogo através do Back4App.
2. O sistema deve buscar e exibir aleatoriamente perguntas de uma base de dados segmentada por categorias do ensino básico.
3. O sistema deve atualizar e exibir o placar global contendo os líderes (Leaderboard).

#### 5.2.2. Requisitos Não Funcionais

1. O banco de dados e APIs do jogo devem responder a requisições primárias (login e leitura de perguntas) num tempo médio inferior a 2 segundos.
2. A interface da aplicação deve ser fluida e apresentar boa responsividade em navegadores web.

### 5.3. Protótipos

Descrição das telas principais da aplicação:

1. **Splash / Tela Inicial**: Logo do jogo, opções de Login e Cadastro.
2. **Dashboard / Menu**: Mensagem de "Bem-vindo", botão para visualizar o Placar Global, e botão "Iniciar Partida".
3. **Seleção de Categoria**: Tela de roleta/sorteio ou seleção direta de uma categoria de conhecimento.
4. **Gameplay**: Pergunta em destaque, cronômetro regressivo e 4 botões de alternativas (apenas uma correta).
5. **Resultado**: Resumo de acertos, pontos ganhos na partida e nova posição no ranking global.

### 5.4. Estrutura do Banco de Dados

As seguintes classes (tabelas) serão modeladas no Parse Dashboard do Back4App:

**1. User (Classe Padrão Parse)**

- `username` (String): Nome de usuário ou telefone.
- `password` (String): Senha do jogador.
- `totalScore` (Number): Pontuação acumulada no ranking global.

**2. Category**

- `name` (String): Nome da categoria (ex: Matemática, História).
- `color` (String): Cor associada (Hexadecimal) para tema dinâmico no Flutter.

**3. Question**

- `text` (String): O texto descritivo da pergunta.
- `category` (Pointer): Referência à tabela Category.
- `options` (Array): Lista de 4 opções textuais de resposta.
- `correctAnswerIndex` (Number): Índice da resposta certa dentro do Array (0 a 3).

### 5.5. Cronograma

Estimativa para a execução e entrega do projeto:

- **Fase 1 (Semana 1)**: Criação de protótipos, configuração inicial do Back4App, modelagem do BD e organização do repositório no Github com base no Flutter.
- **Fase 2 (Semana 2)**: Implementação no Flutter das telas de Autenticação e integração do login. Inserção manual da massa de dados no Back4App.
- **Fase 3 (Semana 3)**: Implementação do "Core Loop" do jogo (perguntas, tempo, pontuação) e desenvolvimento da tela do Placar Global.
- **Fase 4 (Semana 4)**: Ajustes finais de UI/UX, revisão, testes automatizados/manuais e deploy de produção na nuvem.
