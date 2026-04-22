% Base simples para fins educacionais.
% Nao substitui avaliacao medica profissional.

doenca(gripe, [febre, tosse, dor_garganta, cansaco, coriza]).
doenca(resfriado, [espirro, coriza, dor_garganta, congestao_nasal]).
doenca(covid19, [febre, tosse, cansaco, perda_olfato, dor_garganta]).
doenca(dengue, [febre_alta, dor_corpo, dor_cabeca, manchas_pele, nausea]).
doenca(enxaqueca, [dor_cabeca, nausea, sensibilidade_luz]).
doenca(gastrite, [dor_estomago, nausea, azia, inchaco]).
doenca(alergia_respiratoria, [espirro, coriza, coceira_nariz, congestao_nasal]).

string_to_sintomas(Csv, Sintomas) :-
    split_string(Csv, ",", " \n\t\r", Partes),
    maplist(atom_string, Sintomas, Partes).

intersecao([], _, []).
intersecao([H|T], B, [H|R]) :- member(H, B), !, intersecao(T, B, R).
intersecao([_|T], B, R) :- intersecao(T, B, R).

calcular_confianca(SintomasEntrada, SintomasDoenca, QuantidadeMatch, Confianca) :-
    length(SintomasEntrada, QtdEntrada),
    length(SintomasDoenca, QtdDoenca),
    Den is QtdEntrada + QtdDoenca,
    ( Den =:= 0 -> Confianca = 0
    ; Valor is (200 * QuantidadeMatch) / Den,
      Confianca is round(Valor)
    ).

resultado_para_doenca(SintomasEntrada, NomeDoenca, resultado(NomeDoenca, QuantidadeMatch, TotalDoenca, Confianca, MatchCsv)) :-
    doenca(NomeDoenca, SintomasDoenca),
    intersecao(SintomasEntrada, SintomasDoenca, Matches),
    length(Matches, QuantidadeMatch),
    QuantidadeMatch > 0,
    length(SintomasDoenca, TotalDoenca),
    calcular_confianca(SintomasEntrada, SintomasDoenca, QuantidadeMatch, Confianca),
    atomic_list_concat(Matches, ',', MatchCsv).

comparar_resultado(Delta, resultado(_, _, _, C1, _), resultado(_, _, _, C2, _)) :-
    compare(Delta, C2, C1).

diagnosticar(SintomasEntrada, ResultadosOrdenados) :-
    findall(
        Resultado,
        resultado_para_doenca(SintomasEntrada, _, Resultado),
        Resultados
    ),
    predsort(comparar_resultado, Resultados, ResultadosOrdenados).

print_resultados([]).
print_resultados([resultado(Nome, Match, Total, Confianca, MatchCsv)|Resto]) :-
    format('~w|~d|~d|~d|~w~n', [Nome, Match, Total, Confianca, MatchCsv]),
    print_resultados(Resto).

executar_csv(Csv) :-
    string_to_sintomas(Csv, Sintomas),
    diagnosticar(Sintomas, Resultados),
    print_resultados(Resultados).
