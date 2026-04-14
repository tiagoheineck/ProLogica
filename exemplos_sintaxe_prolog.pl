% ============================================================================
% EXEMPLOS DE SINTAXE E OPERAÇÕES EM PROLOG
% ============================================================================
% Guia prático com exemplos para uso em aulas
% Tópicos: Fatos, Regras, Unificação, Listas, Aritmética, Backtracking, etc.
% ============================================================================


% ============================================================================
% 1. FATOS E CONSULTAS BÁSICAS
% ============================================================================

% Fatos simples (cláusulas sem cauda)
pai(joao, maria).
pai(joao, pedro).
pai(maria, ana).
pai(pedro, luis).

mae(joana, maria).
mae(joana, pedro).
mae(maria, ana).
mae(carla, luis).

% Fatos com múltiplos argumentos
idade(joao, 50).
idade(maria, 25).
idade(pedro, 23).
idade(ana, 5).

% Fatos simples (predicados unários)
vivo(joao).
vivo(maria).
morto(jorge).

% Consultas possíveis:
% ?- pai(joao, X).              % Quem são os filhos de João?
% ?- pai(X, maria).             % Quem é o pai de Maria?
% ?- pai(joao, maria).          % João é pai de Maria? (SIM/NÃO)
% ?- pai(X, Y).                 % Listar todos os pares pai-filho
% ?- idade(maria, Anos).        % Qual é a idade de Maria?


% ============================================================================
% 2. REGRAS (CLÁUSULAS COM CORPO)
% ============================================================================

% Regra: X é avô de Y se X é pai de Z e Z é pai de Y
avo(X, Y) :- 
    pai(X, Z), 
    pai(Z, Y).

% Regra: X é mãe se existe um filho/a
mao_de_familia(X) :-
    mae(X, _).

% Regra: X é progenitor de Y se é pai ou mãe
progenitor(X, Y) :- pai(X, Y).
progenitor(X, Y) :- mae(X, Y).

% Regra: X é avô ou avó
avo_ou_avo(X, Y) :-
    progenitor(X, Z),
    progenitor(Z, Y).

% Regra: X é irmão/ã de Y
irmao(X, Y) :-
    pai(P, X),
    pai(P, Y),
    mae(M, X),
    mae(M, Y),
    X \= Y.  % X é diferente de Y

% Regra: X é parente de Y
parente(X, Y) :- progenitor(X, Y).
parente(X, Y) :- progenitor(Y, X).
parente(X, Y) :- irmao(X, Y).
parente(X, Y) :- parente(X, Z), parente(Z, Y).

% Consultas:
% ?- avo(X, ana).               % Quem é avó de Ana?
% ?- av(joao, Y).               % De quem João é avó?
% ?- irmao(maria, X).           % Quem é irmão de Maria?
% ?- parente(joao, X).          % Quem são parentes de João?


% ============================================================================
% 3. OPERAÇÕES ARITMÉTICAS
% ============================================================================

% Comparação aritmética simples
maior_que_idade(Pessoa) :-
    idade(Pessoa, Anos),
    Anos > 20.

menor_que_idade(Pessoa) :-
    idade(Pessoa, Anos),
    Anos < 10.

% Uso de is/2 para avaliação
dobro_idade(Pessoa, Dobro) :-
    idade(Pessoa, Anos),
    Dobro is Anos * 2.

% Soma de idades
soma_idades(Pessoa1, Pessoa2, Soma) :-
    idade(Pessoa1, Anos1),
    idade(Pessoa2, Anos2),
    Soma is Anos1 + Anos2.

% Operadores aritméticos disponíveis:
% +  , -  , *  , /  , //   , mod , ^ , **
% É necessário usar 'is' para calcular expressões

% Exemplos de uso:
teste_aritmetica :-
    X is 5 + 3,
    write('5 + 3 = '), write(X), nl,
    Y is 10 - 2,
    write('10 - 2 = '), write(Y), nl,
    Z is 3 * 4,
    write('3 * 4 = '), write(Z), nl,
    W is 20 / 4,
    write('20 / 4 = '), write(W), nl,
    D is 20 // 3,
    write('20 // 3 (divisão inteira) = '), write(D), nl,
    M is 20 mod 3,
    write('20 mod 3 (resto) = '), write(M), nl,
    P is 2 ** 3,
    write('2 ** 3 (potência) = '), write(P), nl.

% Comparações:
% =:= (igualdade aritmética)
% =\= (desigualdade aritmética)
% <, >, =<, >=

exemplo_comparacoes :-
    (5 =:= 5 -> write('5 é igual a 5') ; write('Não')), nl,
    (5 =\= 3 -> write('5 é diferente de 3') ; write('Não')), nl,
    (3 < 5 -> write('3 é menor que 5') ; write('Não')), nl,
    (10 >= 5 -> write('10 é maior ou igual a 5') ; write('Não')), nl.

% Consultas:
% ?- maior_que_idade(X).        % Quem tem mais de 20 anos?
% ?- dobro_idade(maria, D).     % Qual é o dobro da idade de Maria?
% ?- soma_idades(joao, maria, S). % Qual é a soma das idades?


% ============================================================================
% 4. LISTAS
% ============================================================================

% Listas são estruturas fundamentais em Prolog
% Sintaxe: [Cabeça | Cauda] ou [Elemento1, Elemento2, ...]

% Fatos sobre listas
lista_numeros([1, 2, 3, 4, 5]).
lista_nomes([joao, maria, pedro, ana]).
lista_vazia([]).

% Regra: Pertence - X pertence à lista L
pertence(X, [X | _]).                    % X é a cabeça
pertence(X, [_ | Cauda]) :- pertence(X, Cauda).  % X está na cauda

% Regra: Comprimento - Número de elementos
comprimento([], 0).
comprimento([_ | Cauda], N) :- 
    comprimento(Cauda, N1),
    N is N1 + 1.

% Regra: Último elemento
ultimo([X], X).
ultimo([_ | Cauda], X) :- ultimo(Cauda, X).

% Regra: Append - concatenar listas
concatenar([], L, L).
concatenar([H | T1], L2, [H | T3]) :- 
    concatenar(T1, L2, T3).

% Regra: Reverter lista
reverter([], []).
reverter([H | T], R) :- 
    reverter(T, TR),
    concatenar(TR, [H], R).

% Regra: Listar pares
pares([], []).
pares([H | T], [H | R]) :-
    0 is H mod 2,
    pares(T, R).
pares([_ | T], R) :-
    pares(T, R).

% Regra: Soma de lista
soma_lista([], 0).
soma_lista([H | T], Soma) :-
    soma_lista(T, SomaResto),
    Soma is H + SomaResto.

% Predicados built-in para listas:
% append(L1, L2, L3)     - concatena L1 e L2 em L3
% member(X, Lista)       - X é membro de Lista
% length(Lista, N)       - Lista tem N elementos
% reverse(Lista, Rev)    - Rev é Lista ao contrário
% sort(Lista, Ordenada)  - Ordenar lista
% nth0(I, Lista, X)      - X é o I-ésimo elemento (começando em 0)
% nth1(I, Lista, X)      - X é o I-ésimo elemento (começando em 1)

exemplo_listas :-
    L = [1, 2, 3, 4, 5],
    write('Lista: '), write(L), nl,
    length(L, Comp),
    write('Comprimento: '), write(Comp), nl,
    reverse(L, LRev),
    write('Invertida: '), write(LRev), nl,
    append([1, 2], [3, 4], L2),
    write('Concatenação [1,2] + [3,4]: '), write(L2), nl,
    (member(3, L) -> write('3 está na lista') ; write('3 não está')), nl.

% Consultas:
% ?- pertence(3, [1, 2, 3, 4, 5]).  % 3 está na lista?
% ?- comprimento([a, b, c], N).     % Quantos elementos?
% ?- reverter([1, 2, 3], R).        % Inverter lista
% ?- soma_lista([1, 2, 3, 4, 5], S). % Somar elementos
% ?- pares([1, 2, 3, 4, 5], P).     % Filtrar números pares
% ?- append([1, 2], X, [1, 2, 3, 4]). % Encontrar X


% ============================================================================
% 5. UNIFICAÇÃO
% ============================================================================

% Unificação é o processo de igualar estruturas
% Representação de estruturas complexas

pessoa(nome(joao), idadde(50), profissao(engenheiro)).
pessoa(nome(maria), idade(25), profissao(doctor)).

animal(cachorro, cor(marrom), tamanho(grande)).
animal(gato, cor(preto), tamanho(pequeno)).

% Extrair informações usando unificação
extrai_nome(pessoa(nome(N), _, _), N).
extrai_idade(pessoa(_, idade(I), _), I).
extrai_profissao(pessoa(_, _, profissao(P)), P).

% Padrão matching com listas
primeiro([H | _], H).
segundo([_, H | _], H).
terceiro([_, _, H | _], H).

% Exercício: Capturar valores específicos
casa(joao, maria).  % João mora com Maria

habita(Pessoa, Local) :-
    casa(Pessoa, Local).

% Consultas:
% ?- pessoa(nome(N), idade(I), profissao(P)).
% ?- extrai_nome(pessoa(nome(joao), _, _), N).
% ?- primeiro([a, b, c], X).
% ?- segundo([1, 2, 3, 4], X).


% ============================================================================
% 6. BACKTRACKING
% ============================================================================

% Backtracking: Prolog tenta todas as soluções possíveis

cor(carro1, vermelho).
cor(carro1, azul).      % carro1 tem múltiplas possíveis cores
cor(carro2, preto).
cor(carro2, branco).

sabor(sorvete1, chocolate).
sabor(sorvete1, baunilha).
sabor(sorvete1, morango).
sabor(sorvete2, menta).

% Regra: Combinações de carros e sabores
combinacao_carro_sabor(Carro, Sabor) :-
    cor(Carro, _),
    sabor(Sabor, _).

% Consultas com backtracking:
% ?- cor(carro1, X).              % Todas as cores do carro1
% ?- sabor(S, X).                 % Todos os sorvetes e sabores
% ?- cor(C, X), X = vermelho.     % Qual carro é vermelho?
% ?- cor(C, R), sabor(S, F), R = vermelho.

% Usar ; (ou) para múltiplas opções
teste_backtracking :-
    write('Cores de carro1: '),
    (cor(carro1, C1), write(C1), fail ; true), nl,
    write('Sabores de sorvete1: '),
    (sabor(sorvete1, S1), write(S1), write(' '), fail ; true), nl.

% fail força backtracking


% ============================================================================
% 7. CORTE (CUT) - !
% ============================================================================

% O corte (!) previne backtracking e melhora eficiência

% Sem corte: tenta todas as soluções
maximo_lista1([X], X).
maximo_lista1([H | T], Max) :-
    maximo_lista1(T, MaxT),
    H >= MaxT,
    Max = H.
maximo_lista1([H | T], Max) :-
    maximo_lista1(T, MaxT),
    H < MaxT,
    Max = MaxT.

% Com corte: mais eficiente
maximo_lista2([X], X) :- !.
maximo_lista2([H | T], Max) :-
    maximo_lista2(T, MaxT),
    H >= MaxT, !,
    Max = H.
maximo_lista2([_ | T], Max) :-
    maximo_lista2(T, Max).

% Exemplo: Primeira solução apenas
primeiro_elemento(X, [X | _]) :- !.

% Consultas:
% ?- maximo_lista2([3, 1, 4, 1, 5], Max). % Máximo é 5


% ============================================================================
% 8. NEGAÇÃO E CONDICIONAIS
% ============================================================================

% Negação: \+ (não)
nao_tem_filhos(X) :-
    \+ pai(X, _),
    \+ mae(X, _).

% Positivo: alguém tem filhos
tem_filhos(X) :-
    (pai(X, _) ; mae(X, _)).

% Condicional: (Condição -> Então ; Senão)
classificacao_idade(Pessoa, Categoria) :-
    idade(Pessoa, Anos),
    (Anos < 13 -> Categoria = crianca ;
     Anos < 18 -> Categoria = adolescente ;
     Anos < 60 -> Categoria = adulto ;
     Categoria = idoso).

% Exemplo de negação
numeros_diferentes(X, Y) :-
    \+ (X = Y).

% Consultas:
% ?- nao_tem_filhos(X).           % Quem não tem filhos?
% ?- tem_filhos(X).               % Quem tem filhos?
% ?- classificacao_idade(maria, C). % Categoria de Maria
% ?- numeros_diferentes(1, 2).    % 1 é diferente de 2?


% ============================================================================
% 9. OPERADORES DE UNIFICAÇÃO E COMPARAÇÃO
% ============================================================================

% UNIFICAÇÃO:
% =   : Unifica (torna igual)
% \=  : Não unifica
% =.. : Desconstrói (univ)
% functor/3 : Obtém nome da estrutura
% arg/3     : Acessa argumentos

teste_unificacao :-
    write('=== TESTES DE UNIFICAÇÃO ==='), nl,
    % Unificação simples
    X = 5,
    write('X = 5: '), write(X), nl,
    % Unificação de estruturas
    Pessoa = pessoa(joao, 30),
    write('Pessoa = pessoa(joao, 30): '), write(Pessoa), nl,
    % Unificação de listas
    [A, B, C] = [1, 2, 3],
    write('A='), write(A), write(', B='), write(B), write(', C='), write(C), nl.

% COMPARAÇÃO (sem unificação):
% @< : menor que (ordem padrão)
% @> : maior que
% @=< : menor ou igual
% @>= : maior ou igual

teste_comparacoes :-
    write('=== COMPARAÇÃO ESTRUTURAL ==='), nl,
    (atom @< 123 -> write('atom é menor que 123') ; write('Não')), nl,
    ([1,2] @< [1,3] -> write('[1,2] é menor que [1,3]') ; write('Não')), nl.


% ============================================================================
% 10. PREDICADOS BUILT-IN COMUNS
% ============================================================================

% Tipos e verificação:
% var(X)        - X é uma variável não ligada
% nonvar(X)     - X não é variável
% atom(X)       - X é um átomo
% number(X)     - X é um número
% integer(X)    - X é inteiro
% float(X)      - X é ponto flutuante
% compound(X)   - X é uma estrutura composta
% is_list(X)    - X é uma lista

teste_tipos :-
    write('=== TESTES DE TIPO ==='), nl,
    (atom(joao) -> write('joao é um átomo') ; write('Não')), nl,
    (number(5) -> write('5 é um número') ; write('Não')), nl,
    (integer(5) -> write('5 é inteiro') ; write('Não')), nl,
    (is_list([1,2,3]) -> write('[1,2,3] é uma lista') ; write('Não')), nl.

% Manipulação de átomos:
% atom_codes(Atom, Codes)   - Atom em código ASCII
% atom_chars(Atom, Chars)   - Atom em caracteres
% atom_concat(A1, A2, A3)   - Concatenar átomos
% atom_length(Atom, Length) - Comprimento do átomo
% upcase_atom(Atom, Upper)  - Transformar em maiúsculas
% downcase_atom(Atom, Lower) - Transformar em minúsculas

teste_atomos :-
    write('=== MANIPULAÇÃO DE ÁTOMOS ==='), nl,
    atom_codes(joao, Codes),
    write('joao em códigos: '), write(Codes), nl,
    atom_chars(prolog, Chars),
    write('prolog em caracteres: '), write(Chars), nl,
    atom_concat(hello, world, Resultado),
    write('hello + world = '), write(Resultado), nl,
    atom_length(prolog, Len),
    write('Comprimento de prolog: '), write(Len), nl.

% I/O (Input/Output):
% write(X)      - Escrever X
% nl            - Nova linha
% read(X)       - Ler entrada do usuário
% get_char(C)   - Ler um caractere
% put_char(C)   - Escrever um caractere

% Exemplos de busca e encontro:
% findall(X, Objetivo, Lista) - Encontrar todas as soluções
% bagof(X, Objetivo, Lista)   - Idem, com backtracking
% setof(X, Objetivo, Lista)   - Idem, ordenado e sem duplicatas

teste_findall :-
    write('=== FINDALL E SETOF ==='), nl,
    findall(X, pai(joao, X), Filhos),
    write('Filhos de João: '), write(Filhos), nl,
    findall(P, idade(P, I), Pessoas),
    write('Todas as pessoas: '), write(Pessoas), nl.


% ============================================================================
% 11. ESTRUTURAS RECURSIVAS
% ============================================================================

% Fibonacci recursivo
fibonacci(0, 0) :- !.
fibonacci(1, 1) :- !.
fibonacci(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    F is F1 + F2.

% Fatorial
fatorial(0, 1) :- !.
fatorial(N, F) :-
    N > 0,
    N1 is N - 1,
    fatorial(N1, F1),
    F is N * F1.

% Conta regressiva
contagem_regressiva(0) :- !.
contagem_regressiva(N) :-
    write(N), write(' '),
    N1 is N - 1,
    contagem_regressiva(N1).

% Consultas:
% ?- fibonacci(10, F).     % 10º número de Fibonacci
% ?- fatorial(5, F).       % 5! = 120
% ?- contagem_regressiva(5). % Contar de 5 até 0


% ============================================================================
% 12. EXEMPLOS PRÁTICOS
% ============================================================================

% Exemplo 1: Sistema de notas
aluno(joao, 85).
aluno(maria, 92).
aluno(pedro, 78).
aluno(ana, 88).

aprovado(Aluno) :-
    aluno(Aluno, Nota),
    Nota >= 70.

media_alunos(Media) :-
    findall(Nota, aluno(_, Nota), Notas),
    soma_lista(Notas, Soma),
    length(Notas, Qtd),
    Media is Soma / Qtd.

% Exemplo 2: Horário de aulas
aula(programacao, segunda, '09:00').
aula(banco_dados, terca, '10:30').
aula(inteligencia_artificial, quarta, '14:00').

aula_no_dia(Dia, Aula) :-
    aula(Aula, Dia, _).

% Exemplo 3: Viagens entre cidades
conectado(sao_paulo, rio_janeiro).
conectado(rio_janeiro, brasilia).
conectado(sao_paulo, belo_horizonte).

pode_viajar(Origem, Destino) :-
    conectado(Origem, Destino).
pode_viajar(Origem, Destino) :-
    conectado(Origem, Intermediaria),
    pode_viajar(Intermediaria, Destino).

% Consultas:
% ?- aprovado(X).              % Quem foi aprovado?
% ?- media_alunos(M).          % Média das notas
% ?- aula_no_dia(segunda, A).  % Qual aula na segunda?
% ?- pode_viajar(sao_paulo, brasilia). % É possível viajar?


% ============================================================================
% 13. PREDICADOS PARA DEMONSTRAÇÃO
% ============================================================================

% Executar todos os testes
executar_todas_demostracao :-
    write('\n'), write('='*60), nl,
    write('DEMONSTRAÇÃO GERAL DE OPERAÇÕES EM PROLOG'), nl,
    write('='*60), nl, nl,
    
    write('1. ARITMETICA E COMPARACOES'), nl,
    teste_aritmetica, nl,
    
    write('2. LISTAS'), nl,
    exemplo_listas, nl,
    
    write('3. TIPOS'), nl,
    teste_tipos, nl,
    
    write('4. MANIPULACAO DE ATOMOS'), nl,
    teste_atomos, nl,
    
    write('5. FINDALL'), nl,
    teste_findall, nl,
    
    write('6. UNIFICACAO'), nl,
    teste_unificacao, nl,
    
    write('='*60), nl.

% ============================================================================
% 14. EXERCÍCIOS PROPOSTOS
% ============================================================================

%
% EXERCÍCIO 1: Implementar uma regra que verifica se uma pessoa é bisavó
% Dica: use três níveis de parentesco
%
% EXERCÍCIO 2: Criar uma regra que calcula a distância entre dois pontos
% Distância = sqrt((x2-x1)² + (y2-y1)²)
%
% EXERCÍCIO 3: Implementar quicksort ou mergesort em Prolog
%
% EXERCÍCIO 4: Criar um sistema de consultório com pacientes, médicos e horários
%
% EXERCÍCIO 5: Implementar um jogo simples (pedra, papel, tesoura)
%
% EXERCÍCIO 6: Criar um sistema de biblioteca com livros, autores e empréstimos
%
% EXERCÍCIO 7: Verificar se um número é primo
%
% EXERCÍCIO 8: Implementar um puzzle (ex: Torre de Hanói)
%

% ============================================================================
% FIM DO ARQUIVO
% ============================================================================
