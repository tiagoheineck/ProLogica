São 5 divisões com comandos internos do prolog.
Cada grupo ficará responsável por criar um exemplo com comentário.
O arquivo deve ser criado com o seguindo formato de NOME

exemplo_X.pl, onde X é o número do grupo correspondente.

Cada grupo deve fazer pull request na branch do professor para apresentar rapidamente aos colegas.

1. Manipulação de Termos e Listas
length/2: Como descobrir o tamanho de uma lista sem usar recursão manual?

append/3: Este comando faz mais do que apenas juntar listas. Como usá-lo para dividir uma lista em duas?

reverse/2: Inversão de elementos.

member/2: Como verificar se um elemento está em uma lista (e como usá-lo para gerar elementos da lista via backtracking).

2. Controle de Fluxo e Lógica
! (Cut): O comando mais polêmico. O que acontece com o backtracking quando você o usa? Qual a diferença entre "Green Cut" e "Red Cut"?

fail/0: Como forçar o Prolog a falhar e tentar a próxima alternativa propositalmente?

once/1: Como garantir que uma busca retorne apenas o primeiro resultado, mesmo que existam outros?

repeat/0: Como criar um loop infinito de leitura de dados?

3. Agregação (Poder de Banco de Dados)
findall/3: Como coletar todos os resultados de uma consulta e colocá-los dentro de uma lista única?

bagof/3 e setof/3: Qual a diferença crucial entre esses dois e o findall? (Dica: ordem e duplicatas).

4. Classificação e Aritmética
is/2: Por que não posso usar = para fazer contas (ex: X = 2 + 2) e devo usar o is?

sort/2: Além de ordenar, o que ele faz com elementos duplicados em uma lista?

5. Modificação da Base de Conhecimento (Dinâmica)
assertz/1: Como adicionar um novo fato à memória do programa enquanto ele está rodando?

retract/1: Como apagar um fato da memória durante a execução?