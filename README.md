# Rodando tudo em containers

Suba a API (Python + SWI-Prolog) em container:

```bash
docker compose up --build
```

Abra no navegador:

```text
http://127.0.0.1:8000
```

Se quiser subir tambem o SWISH para estudar Prolog no navegador:

```bash
docker compose --profile tools up --build
```

SWISH fica em:

```text
http://127.0.0.1:3050
```


# Guia Didático de Prolog 🐍🧠
## Comandos, Operadores e Conceitos Fundamentais

Este guia foi pensado para a disciplina de **Programação Lógica** do curso de **Ciência da Computação (5ª fase)**.

Aqui o objetivo é **entender como o Prolog pensa**, não apenas decorar comandos.
Se você já programa em C, Java ou Python, prepare-se: **o paradigma muda** 😉

---

## 1. O que é Prolog?

Prolog é uma linguagem baseada em **lógica de predicados**.
Você não descreve um algoritmo passo a passo. Em vez disso, você declara:

- **Fatos** (o que é verdade)
- **Regras** (como verdades se relacionam)
- **Consultas** (o que você quer saber)

O Prolog usa **unificação** e **backtracking** para encontrar respostas.

---

## 2. Estrutura Básica do Prolog

### Fatos
Declaram algo que é verdadeiro.

```prolog
pai(joao, maria).
```

### Regras
Definem relações entre fatos.

```prolog
avo(X, Y) :- pai(X, Z), pai(Z, Y).
```

Leia como:
> X é avô de Y **se** X é pai de Z **e** Z é pai de Y

### Consultas
Perguntas feitas ao sistema.

```prolog
?- avo(joao, X).
```

📌 **Toda cláusula termina com ponto final (`.`)**

---

## 3. Operadores Lógicos

| Operador | Significado | Intuição |
|--------|------------|----------|
| `,` | AND lógico | "e" |
| `;` | OR lógico | "ou" |
| `\+` | Negação como falha | "não consigo provar" |
| `->` | If-then | se-então |
| `*->` | If-then-else | se-então-senão |

Exemplo:

```prolog
responsavel(X,Y) :- pai(X,Y); mae(X,Y).
```

⚠️ `\+ P` **não significa** que P é falso,
apenas que **P não pode ser provado**.

---

## 4. Unificação e Comparação

### Unificação (`=`)

```prolog
X = 10.
```

Significa: *X pode assumir o valor 10*.

### Igualdade estrita (`==`)

```prolog
X == 10.
```

Significa: *X já é exatamente 10*.

| Operador | Uso |
|--------|-----|
| `=` | Unificação |
| `\=` | Diferente |
| `==` | Igualdade estrita |
| `\==` | Diferença estrita |
| `> < >= =<` | Comparações aritméticas |

📌 **Unificação não é comparação**.

---

## 5. Aritmética em Prolog

Prolog **não avalia expressões automaticamente**.

❌ Errado:
```prolog
X = 2 + 3.
```

✅ Certo:
```prolog
X is 2 + 3.
```

### Operadores aritméticos

- `+  -  *  /`
- `mod` (resto)
- `//` (divisão inteira)

---

## 6. Controle de Execução

| Comando | Função |
|------|-------|
| `!` | Cut (corte) |
| `fail` | Força falha |
| `true` | Sempre verdadeiro |
| `repeat` | Laço com backtracking |

### Exemplo com cut

```prolog
max(X,Y,X) :- X >= Y, !.
max(_,Y,Y).
```

✂️ O `cut` **impede o backtracking**.
Use somente quando souber exatamente o que está fazendo.

---

## 7. Listas

### Estrutura

```prolog
[]        % lista vazia
[H|T]     % cabeça e cauda
```

### Predicados mais usados

- `member/2`
- `append/3`
- `length/2`

Exemplo:

```prolog
member(X, [a,b,c]).
```

---

## 8. Entrada, Saída e Ambiente

### Entrada e saída

- `write/1`
- `writeln/1`
- `nl/0`
- `read/1`

### Ambiente e depuração

- `listing.`
- `trace.`
- `notrace.`
- `consult(arquivo).`
- `[arquivo].`
- `halt.`

---

## 9. Boas Práticas em Prolog

- Pense em **relações**, não em algoritmos
- Evite `cut` como gambiarra
- Teste várias consultas
- Use `trace` para entender o backtracking
- Se parece Java, **releia o problema** 😄

---

## 🎓 Dica Final do Professor

> Em Prolog, quanto menos você tenta mandar,
> mais o sistema consegue trabalhar.

Confie na lógica.
Confie no backtracking.

---

## Mini App Web: Quiz de Diagnostico (Educacional)

Este repositorio agora inclui um exemplo de integracao entre:

- Frontend web (HTML simples)
- Backend em Python (FastAPI)
- Regras de inferencia em SWI-Prolog

### Estrutura adicionada

- `app/main.py` -> API FastAPI e chamada do `swipl`
- `app/static/index.html` -> tela do quiz
- `prolog/diagnostico.pl` -> base de doencas/sintomas e regras de pontuacao
- `requirements.txt` -> dependencias Python

### Como executar

Opcao recomendada (100% containerizado):

1. Rode:

```bash
docker compose up --build
```

2. Acesse:

```text
http://127.0.0.1:8000
```

Opcao local (sem containers):

1. Instale o SWI-Prolog e confirme o comando `swipl` no terminal.
2. Crie e ative ambiente virtual Python (opcional, recomendado).
3. Instale dependencias:

```bash
pip install -r requirements.txt
```

4. Rode a API:

```bash
uvicorn app.main:app --reload
```

5. Abra no navegador:

```text
http://127.0.0.1:8000
```

### Endpoint

- `POST /api/diagnosticar`

Payload exemplo:

```json
{
	"sintomas": ["febre", "tosse", "cansaco"]
}
```

### Aviso importante

Projeto de brincadeira/estudo. Nao substitui avaliacao medica real.
