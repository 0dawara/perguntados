# Trabalho Final - Cloud-Powered Mini-Games

## 1. Estrutura do Trabalho 

- Entrega 1: Plano de Trabalho. 
- Entrega 2: Desenvolvimento da Aplicação e Apresentação. 

Cada grupo desenvolverá um mini-game funcional baseado em PaaS (Platform as a Service) e BaaS (Backend as a Service), utilizando as seguintes tecnologias como base: 

- Backend (BaaS): Back4App para autenticação de jogadores e persistência de dados (placares, progresso, etc.). 
- Ambiente de Desenvolvimento e Deploy (PaaS): GitHub Codespace/Replit para codificação, colaboração. 
- Ambiente de Deploy do frontend do jogo: Serviços Azure, Vercel.
- Versionamento: GitHub ou GitHub Action para controle de versão do código-fonte, com workflow. 

## 2. Entrega 1: Plano de Trabalho do Jogo 

Nesta fase, o grupo deve planejar todos os aspectos do desenvolvimento do jogo. 

### 2.1. Introdução 

Apresentar uma visão geral do mini-game escolhido e justificar como a arquitetura PaaS e BaaS (Codespace + Back4App) é adequada para o projeto, destacando vantagens como desenvolvimento rápido, escalabilidade e foco na lógica do jogo. 

### 2.2. Formação de Grupos e Papéis 

Os grupos terão os seguintes papéis: 

- **Gerente de Projeto**: Responsável pela organização do grupo, cronograma e gestão de tarefas (no Trello/Jira). 
- **Desenvolvedor Backend**: Foco na configuração do Back4App, criação das classes (tabelas) e lógica da API para o jogo. 
- **Desenvolvedor Frontend**: Responsável pela implementação da lógica do jogo e da interface no codespace/Replit, customizando o template escolhido. 
- **Especialista em Banco de Dados**: Modelagem das estruturas de dados no Back4App (ex: Player, Score, Match). 
- **DevOps & Versionamento**: Gerencia o repositório no GitHub/GitLab, a estrutura de branches e os Pull Requests. 

### 2.3. Escolha do Projeto 

Cada grupo deverá escolher um dos temas de mini-game abaixo ou propor um similar (sujeito à aprovação do professor). O foco deve ser a integração com a nuvem, não a complexidade gráfica. 

- CloudQuiz: Jogo de perguntas e respostas. O Back4App armazena as perguntas e o placar global dos jogadores. 
- Clicker Hero Simplificado: Jogo de cliques para acumular pontos e comprar upgrades. O Back4App salva o progresso do jogador em tempo real. 
- Jogo da Velha Multiplayer: Versão online do clássico Jogo da Velha. O Back4App controla o estado do tabuleiro para sincronizar os dois jogadores. 

### 2.4. Uso de Templates 

Para acelerar o desenvolvimento, os alunos utilizarão templates prontos, focando na integração e lógica do jogo. 

#### Frontend (Templates no Codespace/Replit): 

- React: [https://replit.com/@templates/react](https://replit.com/@templates/react) 
- Vue.js: [https://replit.com/@templates/vue](https://replit.com/@templates/vue) 
- HTML/CSS/JS: Puro ou com bibliotecas como Phaser.js.
- Flutter: Puro ou com bibliotecas como [shadcn/ui](https://ui.shadcn.com/).

#### Backend (Exemplos no Back4App): 
- CRUD e Relacionamentos: Essencial para salvar pontuações e perfis. 
- Autenticação de Usuários: Para o login dos jogadores. 

### 2.5. Arquitetura e Versionamento 

- Desenhar um diagrama simples da arquitetura da aplicação, mostrando a interação entre o Frontend (Flutter), o Backend (Back4App) e o jogador. 
- Apresentar a estrutura de branches a ser utilizada no GitHub/GitLab (ex: `main`, `dev`, `feature/nome-da-funcionalidade`). 

### 2.6. Organização do Projeto 

- Escopo do Jogo: Detalhar a funcionalidade principal (ex: "registrar pontuação", "salvar progresso"), público-alvo e tecnologias. 
- Requisitos: Listar 3 requisitos funcionais (ex: "O sistema deve permitir o cadastro de um novo jogador") e 2 não funcionais (ex: "O placar deve ser atualizado em menos de 2 segundos"). 
- Protótipos: Criar wireframes ou mockups simples das telas principais do jogo (Tela Inicial, Tela de Jogo, Tela de Placar). 
- Estrutura do Banco de Dados: Definir os modelos de dados (classes) e seus atributos no Back4App. 
- Cronograma: Criar um cronograma de execução das atividades até a entrega final. 

### 2.7. Apresentação e Entrega da Tarefa no AVA 

- Documentação do Plano de Trabalho itens: 2.2, 2.3, 2.4, 2.5 e 2.6. 
- Apresentação de Documentação em Grupo. 

## 3. Entrega 2: Desenvolvimento do Jogo e Apresentação 

### 3.1. Implementação do Backend (Back4App - BaaS) 
- Configurar as classes (ex: Player, Score) no dashboard do Back4App. 
- Implementar e proteger a API (chaves de acesso). 
- Configurar a funcionalidade de autenticação de usuários. 

### 3.2. Implementação do Frontend (Replit - PaaS) 
- Implementar a interface e a lógica principal do jogo. 
- Realizar a conexão com a API do Back4App para enviar e receber dados (pontuações, login, etc.). 
- Realizar o deploy final da aplicação utilizando os recursos do Azure. 

### 3.3. Versionamento e Colaboração 
- Realizar commits frequentes e descritivos no repositório do GitHub/GitLab. 
- Utilizar Pull Requests (PRs) para integrar o código desenvolvido nas feature branches à branch dev. 
- Manter o quadro de tarefas (Trello/Jira) atualizado. 

### 3.4. Testes e Apresentação 
- Realizar testes automatizados(via .yml) nas funcionalidades principais do jogo (login, salvar pontuação, exibir placar). 
- Preparar uma demonstração funcional do jogo, que será apresentada para a turma. 

## 4. Ferramentas Recomendadas 

| Categoria | Ferramentas 
|-----------|-----------
| PaaS | Codespace, Replit, Azure, Heroku, Render 
| BaaS | Back4App, Firebase 
| Versionamento | GitHub, GitLab    
| Templates Frontend | Codespace, Replit (React, Vue.js), AdminLTE (Bootstrap) 
| Templates Backend | Back4App Parse Server 

## 5. Entrega Final 

Cada grupo deverá entregar os seguintes artefatos: 

- Link para o código-fonte completo no GitHub/GitLab. 
- Link do jogo funcional publicado no codespace/Replit. 
- Link do jogo Produção (SaaS): Azure e ferramentas. 
- Relatório técnico final documentando o projeto, a arquitetura e as decisões tomadas. 
- Apresentação e Demonstração funcional do mini-game desenvolvido.
