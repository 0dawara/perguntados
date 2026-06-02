# ❓ Perguntados

[![Flutter](https://img.shields.io/badge/Flutter-3-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Back4App](https://img.shields.io/badge/Backend-Back4App-1289A7)](https://www.back4app.com/)
[![License](https://img.shields.io/badge/license-Academic-blue)](#)

> Aplicativo de quiz interativo desenvolvido em Flutter com integração ao Back4App.

---

## 📋 Sobre o Projeto

O **Perguntados** é uma aplicação multiplataforma focada em oferecer uma experiência de quiz dinâmica e divertida. O projeto utiliza o framework Flutter para garantir uma performance nativa e um backend gerenciado no Back4App para gerenciar perguntas, jogadores e sistema de pontuação (ranking).

---

## ✨ Funcionalidades

### 🎮 Jogo Principal

- Jogo baseado em múltiplas categorias de perguntas
- Roleta animada via `flutter_fortune_wheel`
- Animações para engajamento (`confetti`)
- Sistema de pontuação com penalidades para respostas incorretas
- Temporizador ativo para respostas rápidas

### ⚔️ Modo Desafio (Battle Mode)

- Desafios em tempo real contra outros jogadores
- Sincronização de status e recusa/aceitação de partidas
- Comparação de resultados ao final de cada embate

### 🏆 Sistema de Ranking

- Ranking dos melhores jogadores
- Pontuação salva remotamente

### 🔐 Autenticação e Perfil

- Sistema de login e autenticação integrado
- Gerenciamento de estado de usuário seguro

---

## 🛠️ Stack Técnica

### Multiplataforma

- **[Flutter](https://flutter.dev/)** — Framework de UI Multiplataforma
- **[Dart 3](https://dart.dev/)** — Linguagem de programação
- **[GoRouter](https://pub.dev/packages/go_router)** — Gerenciamento de rotas e navegação

### Backend & Autenticação

- **[Back4App](https://www.back4app.com/)** — Backend-as-a-Service baseado em Parse Server
- **[Parse SDK Flutter](https://pub.dev/packages/parse_server_sdk_flutter)** — Cliente de comunicação

### Visuals & Utilitários

- **[Google Fonts](https://pub.dev/packages/google_fonts)** — Tipografia personalizada
- **[Flutter Fortune Wheel](https://pub.dev/packages/flutter_fortune_wheel)** — Componente de roleta
- **[Confetti](https://pub.dev/packages/confetti)** — Efeitos de comemoração

### DevOps & Deploy

- **GitHub Actions** — Pipeline automatizado de CI/CD para Mobile e Desktop (Android, iOS, Windows, macOS e Linux)
- **Vercel** — Hospedagem para a versão Web do aplicativo

---

## 🚀 Como rodar localmente

### Pré-requisitos

- Flutter SDK (versão ^3.12.0) instalado e configurado
- Conta gratuita no [Back4App](https://www.back4app.com/)

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/perguntados.git
cd perguntados
```

### 2. Instalar dependências

```bash
flutter pub get
```

### 3. Configurar variáveis de ambiente

Copie o arquivo de exemplo (se existir configuração em arquivo ou defina os valores no inicializador):

```bash
cp .env.example .env
```

*Obs: A inicialização do Parse no Flutter (`Parse().initialize(...)`) necessita de Application ID e Client Key geradas no painel do Back4App.*

### 4. Rodar o projeto

Você pode executar o projeto em um simulador, emulador Android, ou na Web:

```bash
flutter run
```

---

## 🧪 Testes Automatizados

O projeto conta com infraestrutura de testes automatizados:

- **Testes de Unidade**: Cobertura das regras de negócio (ViewModels e Models).
- **Testes de Widget**: Validação de componentes da interface do usuário e fluxos.

Para rodar os testes:

```bash
flutter test
```

---

## 📁 Estrutura do projeto

A estrutura da pasta principal de código (`lib/`), separando as responsabilidades de forma clara:

```
perguntados/
├── assets/                 # Recursos visuais e sonoros (imagens, fontes, áudios)
├── lib/
│   ├── core/               # Extensões, utilitários, temas e configurações base
│   ├── data/               # Modelos, DTOs e integração com APIs (Parse)
│   ├── presentation/       # Componentes de UI, telas e widgets
│   ├── utils/              # Funções de ajuda e constantes globais
│   └── main.dart           # Ponto de entrada do aplicativo
├── .env.example            # Template de chaves do ambiente
├── ARCHITECTURE.md         # Documentação da arquitetura do projeto
├── CONTRIBUTING.md         # Guia de contribuição
├── GEMINI.md               # Diretrizes e regras específicas da IA
└── README.md               # Este arquivo
```

---

## 📈 Fluxo de uso

1. Usuário abre o app e faz o login/cadastro.
2. Acessa a tela principal e inicia o quiz (gira a roleta).
3. Responde a uma pergunta por categoria. O App emite feedback sonoro e visual.
4. Pontuação calculada e enviada para o Back4App.
5. Usuário visualiza o seu resultado e ranking.

Para mais detalhes técnicos e arquiteturais, veja [ARCHITECTURE.md](./ARCHITECTURE.md).

---

## 👥 Equipe

Projeto de cunho educacional/universitário desenvolvido para a disciplina de **Desenvolvimento de Software em Nuvem**.

| Membros                    |
|----------------------------|
| **Igor Oliveira da Silva** |
| **Thiago Leal Menezes**    |

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.
