# Estrutura do Banco de Dados - Perguntados

As seguintes classes serão modeladas no Parse Dashboard (Back4App):

## 1. User (Classe Padrão Parse)
- `username` (String): Nome de usuário escolhido.
- `password` (String): Senha (criptografada automaticamente pelo Parse).
- `totalScore` (Number): Pontuação total acumulada pelo jogador.

## 2. Category
- `name` (String): Nome da categoria (ex: Matemática, Linguagens, História, Geografia).
- `color` (String): Cor de tema associada (Hexadecimal) para usar no Flutter.

## 3. Question
- `text` (String): O texto da pergunta.
- `category` (Pointer): Relacionado com um objeto da tabela Category.
- `options` (Array): Lista de 4 opções em formato de texto para a resposta.
- `correctAnswerIndex` (Number): O índice de 0 a 3 indicando qual opção no Array é a resposta correta.
