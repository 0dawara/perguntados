# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o projeto **Perguntados**! Este documento descreve as práticas recomendadas e o processo de contribuição, desde a criação da branch até a abertura de um Pull Request (PR).

---

## 🛠️ Ambiente de Desenvolvimento

Certifique-se de que o seu ambiente está configurado antes de contribuir.
- **Flutter SDK:** versão ^3.12.0 ou superior.
- **IDE Recomendada:** VS Code ou Android Studio com plugins do Flutter e Dart ativados.
- Rode o comando `flutter doctor` e garanta que não haja problemas no seu ecossistema.

---

## 🌿 Padrões de Git & Commits

### Branches
Sempre crie uma nova branch a partir da `main` (ou a branch principal definida) antes de começar.
O nome da branch deve ser descritivo e, se possível, conter o tipo da alteração.

Exemplos:
- `feature/tela-de-ranking`
- `bugfix/correcao-login`
- `docs/atualizacao-readme`

### Commits Semânticos
Nós utilizamos [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) para facilitar o entendimento do histórico e versionamento. Todo commit deve ter o seguinte formato:

```
<tipo>(<escopo opcional>): <descrição no imperativo e em letra minúscula>
```

**Tipos permitidos:**
- `feat`: Uma nova funcionalidade.
- `fix`: Correção de um bug.
- `docs`: Atualizações de documentação (ex: README).
- `style`: Ajustes de formatação, pontuação (não afeta código).
- `refactor`: Refatoração do código de produção sem adicionar funcionalidades novas.
- `test`: Adição ou refatoração de testes.
- `chore`: Atualização de ferramentas, dependências ou builds.

**Exemplo:**
`feat(auth): adiciona verificacao de sessao no startup`

---

## 🏗️ Padrões de Código Flutter

Para manter o código uniforme, todos os contribuidores devem seguir estas regras:

1. **Responsabilidade Única:** Evite arquivos e classes gigantescos. Separe UI de regra de negócios.
2. **Nomenclatura:** 
   - Classes, Enums, Typedefs: `PascalCase`.
   - Variáveis, funções e métodos: `camelCase`.
   - Nomes de arquivo: `snake_case`.
3. **Imutabilidade:** Utilize `final` e `const` para variáveis que não mudam. Sempre que possível, utilize `const` na árvore de Widgets para otimizar o rebuild.
4. **Tratamento de Nulos:** Respeite rigorosamente o Sound Null Safety.
5. **Linting:** Antes de qualquer commit, sempre garanta que:
   - `flutter format .` está rodando (limite preferencial de 80 caracteres).
   - `flutter analyze` não reporta **nenhum** erro ou warning de estilo. 
   - Utilize a ferramenta `dart fix --apply` para auto corrigir erros frequentes.

---

## 🔄 Processo de Pull Request

1. Garanta que todas as alterações estão devidamente testadas e sem quebras visuais ou lógicas.
2. Atualize o seu branch a partir do `main` local (`git pull origin main --rebase`).
3. Empurre a sua branch (`git push origin nome-da-sua-branch`).
4. Crie o PR através da interface do GitHub:
   - Forneça um título semântico.
   - Detalhe na descrição **o que** foi feito, **por que** foi feito e (opcionalmente) imagens ou vídeos caso a alteração afete UI/UX.
5. Aguarde o Code Review da equipe.

---

<div align="center">

**[← Voltar ao README](./README.md)**

</div>
