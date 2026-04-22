% Base educacional para quiz da colonizacao portuguesa no Brasil.
% Nao substitui estudo historico completo com fontes primarias.

fase(contato_inicial, [
    descoberta_1500,
    extracao_pau_brasil,
    primeiros_contatos_indigenas,
    escambo,
    litoral
]).

fase(organizacao_colonial, [
    capitanias_hereditarias,
    governo_geral,
    fundacao_salvador,
    acucar_engenhos,
    acao_jesuitas
]).

fase(consolidacao_expansao, [
    invasao_holandesa,
    resistencia_indigena,
    quilombos,
    interiorizacao,
    economia_acucareira
]).

fase(transformacoes_finais, [
    ouro_minas,
    elevacao_reino,
    corte_no_rio,
    tensoes_coloniais,
    independencia_1822
]).

string_to_pistas(Csv, Pistas) :-
    split_string(Csv, ",", " \n\t\r", Partes),
    maplist(atom_string, Pistas, Partes).

intersecao([], _, []).
intersecao([H|T], B, [H|R]) :- member(H, B), !, intersecao(T, B, R).
intersecao([_|T], B, R) :- intersecao(T, B, R).

calcular_confianca(PistasEntrada, PistasFase, QuantidadeMatch, Confianca) :-
    length(PistasEntrada, QtdEntrada),
    length(PistasFase, QtdFase),
    Den is QtdEntrada + QtdFase,
    ( Den =:= 0 -> Confianca = 0
    ; Valor is (200 * QuantidadeMatch) / Den,
      Confianca is round(Valor)
    ).

resultado_para_fase(PistasEntrada, NomeFase, resultado(NomeFase, QuantidadeMatch, TotalFase, Confianca, MatchCsv)) :-
    fase(NomeFase, PistasFase),
    intersecao(PistasEntrada, PistasFase, Matches),
    length(Matches, QuantidadeMatch),
    QuantidadeMatch > 0,
    length(PistasFase, TotalFase),
    calcular_confianca(PistasEntrada, PistasFase, QuantidadeMatch, Confianca),
    atomic_list_concat(Matches, ',', MatchCsv).

comparar_resultado(Delta, resultado(_, _, _, C1, _), resultado(_, _, _, C2, _)) :-
    compare(Delta, C2, C1).

diagnosticar_fase(PistasEntrada, ResultadosOrdenados) :-
    findall(
        Resultado,
        resultado_para_fase(PistasEntrada, _, Resultado),
        Resultados
    ),
    predsort(comparar_resultado, Resultados, ResultadosOrdenados).

print_resultados([]).
print_resultados([resultado(Fase, Match, Total, Confianca, MatchCsv)|Resto]) :-
    format('~w|~d|~d|~d|~w~n', [Fase, Match, Total, Confianca, MatchCsv]),
    print_resultados(Resto).

executar_quiz_csv(Csv) :-
    string_to_pistas(Csv, Pistas),
    diagnosticar_fase(Pistas, Resultados),
    print_resultados(Resultados).
