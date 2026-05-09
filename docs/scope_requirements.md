# Escopo e Requisitos - Perguntados

## Escopo do Jogo
O "Perguntados" permite o cadastro e login de jogadores. O jogo consiste em escolher ou sortear uma categoria de conhecimentos baseados no ensino básico (ex: Matemática, Linguagens, História, Geografia, etc.), ler uma pergunta e escolher uma de quatro alternativas antes que o tempo acabe. Respostas certas geram pontos que são sincronizados na nuvem em um ranking global.

## Requisitos

**Requisitos Funcionais:**
1. O sistema deve permitir que novos jogadores criem contas e façam login no jogo através do Back4App.
2. O sistema deve buscar e exibir aleatoriamente perguntas de uma base de dados segmentada por categorias do ensino básico.
3. O sistema deve atualizar em tempo real ou exibir o placar global contendo os líderes (Leaderboard).

**Requisitos Não Funcionais:**
1. O banco de dados e APIs do jogo devem responder a requisições primárias (login e leitura de perguntas) num tempo médio inferior a 2 segundos.
2. A interface do Flutter deve ser fluida e apresentar boa experiência e responsividade no navegador da web.
