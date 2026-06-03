# 🏛️ Arquitetura do Perguntados

Este documento descreve a arquitetura técnica do aplicativo Perguntados em Flutter, incluindo fluxos, modelo de dados e decisões técnicas, de acordo com as regras estabelecidas no nosso guia.

---

## 📐 Visão Geral

O projeto Perguntados segue o padrão arquitetural **MVC/MVVM** e uma organização por **Camadas Lógicas** claras (Presentation, Domain, Data, Core), garantindo desacoplamento, facilidade de testes e manutenção.

```mermaid
graph LR
    Flutter["📱 App Flutter<br/>(Cliente)"]
    GoRouter["🧭 GoRouter<br/>(Navegação)"]
    State["🔄 State Management<br/>(ValueNotifier/ChangeNotifier)"]
    ParseSDK["📦 Parse SDK<br/>(Data Layer)"]
    Back4App["🗄️ Back4App<br/>(Parse Server)"]

    Flutter -- "Exibe telas" --> GoRouter
    GoRouter -- "Acessa ViewModel" --> State
    State -- "Gerencia Estado" --> Flutter
    State -- "Chama Repositório" --> ParseSDK
    ParseSDK -- "HTTPS (REST)" --> Back4App

    style Flutter fill:#61dafb
    style GoRouter fill:#02569b,color:#fff
    style State fill:#0175c2,color:#fff
    style ParseSDK fill:#1289a7,color:#fff
    style Back4App fill:#000,color:#fff
```

### Camadas Lógicas do Projeto (`lib/`)

1. **`Presentation`**: Contém a interface do usuário (Widgets e Telas). Onde reside a camada de visualização. Mantém o UI focado apenas em exibir o dado e repassar interações para o estado ou ViewModel correspondente.
2. **`Domain`**: Onde residem as regras de negócio puras (ex: cálculo de pontos baseado na dificuldade).
3. **`Data`**: Modelos de entidades, clientes de API (integração com Back4App) e Repositórios.
4. **`Core`**: Recursos compartilhados (temas visuais com Material 3, utilitários, tratamento de exceções, extensões, etc).

---

## 🎮 Fluxo de Jogo e Pontuação

```mermaid
sequenceDiagram
    actor Player as 🎮 Jogador
    participant UI as 📱 Tela Principal (Presentation)
    participant VM as ⚙️ ViewModel (Domain)
    participant Repo as 📦 Repositório (Data)
    participant DB as 🗄️ Back4App

    Player->>UI: Clica em "Jogar"
    UI->>VM: Solicita perguntas
    VM->>Repo: fetchQuestions()
    Repo->>DB: Query Question
    DB-->>Repo: Lista de Perguntas
    Repo-->>VM: Mapeamento DTO -> Model
    VM-->>UI: Exibe pergunta atual
    
    Player->>UI: Escolhe a alternativa
    UI->>VM: submeterResposta(alternativa)
    VM->>VM: calculaPontuacao()
    VM-->>UI: Dispara animação (+ Pontos / Erro)
    
    VM->>Repo: salvaPontuacao(pontos)
    Repo->>DB: POST /classes/Score
```

---

## 🗄️ Modelo de Dados (Back4App)

O backend é abstraído usando o SDK do Parse. Os objetos no aplicativo mapeiam diretamente para Classes no painel do Back4App.

```mermaid
erDiagram
    User ||--o{ Score : registra
    User ||--o{ Challenge : participa
    Category ||--o{ Question : possui
    Question }o--o{ Score : responde

    User {
        string objectId PK
        string username UK
        string password
        string email
        Date createdAt
    }

    Category {
        string objectId PK
        string name
        string color
        string icon
    }

    Question {
        string objectId PK
        string text "O enunciado"
        List options
        int correctAnswerIndex
        Pointer category FK "ref Category"
    }

    Score {
        string objectId PK
        Pointer userId FK "ref _User"
        number points
        Date playedAt
    }

    Challenge {
        string objectId PK
        Pointer player1 FK "ref _User"
        Pointer player2 FK "ref _User"
        number player1Score
        number player2Score
        Pointer currentTurn FK "ref _User"
        string status "active, completed, expired"
        Date deadline
        Pointer winner FK "ref _User"
    }
```

---

## 🎨 Decisões Técnicas e Boas Práticas

### Gerenciamento de Estado e Reatividade
- **Soluções Nativas:** Sempre preferimos utilizar `ValueNotifier`, `ChangeNotifier`, `Streams` e `Futures` do próprio ecossistema Dart para manter a árvore de dependências leve e diminuir a complexidade.
- **Componentes Imutáveis:** Priorizamos a composição de `StatelessWidget`.

### Rotas e Navegação
- **GoRouter:** Escolhido por permitir roteamento declarativo e fácil integração de fluxos de redirecionamento (ex: redirecionar para tela de Login caso não esteja autenticado).

### Qualidade de Código (Lint e Formatação)
- Limite de 80 caracteres por linha.
- Uso mandatório de classes em `PascalCase`, membros em `camelCase` e arquivos em `snake_case`.
- Análise sintática e semântica através do comando `flutter analyze` e ferramenta `dart_fix` para auto-correções comuns.

### Testes
- A camada de `Domain` e `Data` deve ser inteiramente testável utilizando Mocks, Fakes ou Stubs (preferencialmente Fakes). Para testes mais complexos de simulação, utiliza-se o package `mockito` ou `mocktail`.
- Utilizamos o padrão de teste **Arrange-Act-Assert** ou **Given-When-Then**.

---

<div align="center">

**[← Voltar ao README](./README.md)**

</div>
