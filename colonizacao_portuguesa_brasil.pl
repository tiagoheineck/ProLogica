% ============================================================================
% SISTEMA DE INFERÊNCIAS: COLONIZAÇÃO PORTUGUESA NO BRASIL
% ============================================================================
% Base de conhecimento estruturada sobre a colonização portuguesa (1500-1822)
% com fatos, regras de inferência e consultas possíveis
% ============================================================================

% ============================================================================
% 1. FATOS: DESCOBRIDORES E PRIMEIROS ACESSOS
% ============================================================================

descobridor(pedro_alvares_cabral, brasil, 1500).
descobridor(bartolomeu_dias, cabo_da_boa_esperanca, 1488).

primeiro_contato(brasil, europeus, 1500, pacato).
primeira_aldeia_documentada(porto_seguro, bahia, 1500).


% ============================================================================
% 2. FATOS: GOVERNADORES GERAIS E PERÍODOS
% ============================================================================

governador_geral(tom_de_sousa, 1549, 1553, fundador_salvador).
governador_geral(duarte_da_costa, 1553, 1558, defesa_francesa).
governador_geral(mem_de_sa, 1558, 1572, organizacao_administrativa).
governador_geral(luis_bettencourt, 1572, 1578, expansao_territorial).
governador_geral(fernando_torres, 1578, 1581, conflitos_externos).

% Capitanias hereditárias (donatários e datas)
capitania_hereditaria(pernambuco, duarte_coelho, 1534, produtiva).
capitania_hereditaria(sao_vicente, martim_afonso_sousa, 1532, prospera).
capitania_hereditaria(bahia, francisco_pereira_coutinho, 1534, conflituosa).
capitania_hereditaria(rio_de_janeiro, estacio_de_sa, 1565, defensiva).


% ============================================================================
% 3. FATOS: ATIVIDADES ECONÔMICAS
% ============================================================================

atividade_economica(extracao_pau_brasil, 1500, 1600, coleta).
atividade_economica(producao_acucar, 1530, presente, latifundio).
atividade_economica(comercio_escravos, 1550, 1888, trafico).
atividade_economica(gado, 1600, presente, pecuaria).
atividade_economica(cafe, 1700, 1900, monocultura).

% Produtos principais por período
produto_exportacao(pau_brasil, 1500, 1600, alto).
produto_exportacao(acucar, 1570, 1800, muito_alto).
produto_exportacao(tabaco, 1600, 1800, medio).


% ============================================================================
% 4. FATOS: POPULAÇÃO E SOCIEDADE
% ============================================================================

grupo_populacional(indigenas, autoctone, presente_em_todo_brasil).
grupo_populacional(portugues, europeu, presente_em_todo_brasil).
grupo_populacional(africanos_escravos, escravizado, presente_a_partir_1550).
grupo_populacional(mesticos, hibrido, emergente_a_partir_1550).

estrutura_social(senhor_de_engenho, superior, economico).
estrutura_social(igreja_catolica, superior, espiritual).
estrutura_social(militares, superior, politico).
estrutura_social(trabalhador_livre, medio, economico).
estrutura_social(escravo, inferior, economico).


% ============================================================================
% 5. FATOS: CONFLITOS E RESISTÊNCIA
% ============================================================================

conflito(indigenas, portugueses_franceses, 1500, 1600, guerra_por_territorio).
conflito(quilombos_palmares, exercito_colonial, 1680, 1690, resistencia_escravos).
conflito(colonos_indigenas, jesuitas, 1750, 1760, disputa_catequese).
conflito(invasao_holandesa, portugueses, 1630, 1654, ocupacao_pernambuco).
conflito(piratas_corsarios, colonias, 1500, 1700, depredacao_costeira).


% ============================================================================
% 6. FATOS: INSTITUIÇÕES E ADMINISTRAÇÃO
% ============================================================================

instituicao(governo_geral, administrativa, 1549, salvador).
instituicao(câmara_municipal, legislativa_local, 1550, todas_vilas).
instituicao(santa_inquisicao, religiosa_repressiva, 1580, brasil).
instituicao(companhia_jesus, religiosa_educacional, 1549, brasil).
instituicao(capitania_do_porto, administrativa_comercial, 1600, portos_principais).


% ============================================================================
% 7. REGRAS DE INFERÊNCIA
% ============================================================================

% Regra: Produto foi importante se foi exportado com volume alto ou muito alto
produto_importante(Produto) :-
    produto_exportacao(Produto, _, _, volume),
    (volume = alto ; volume = muito_alto).

% Regra: Período foi de grande atividade econômica
periodo_ouro(Inicio, Fim) :-
    produto_exportacao(_, Inicio, Fim, muito_alto).

% Regra: Territorio disputado (conflito pelo controle territorial)
territorio_disputado(Territorio) :-
    conflito(Grupo1, Grupo2, _, _, Tipo),
    (Tipo = guerra_por_territorio ; Tipo = ocupacao_pernambuco),
    Territorio = Grupo1.

% Regra: Colonização bem-sucedida em uma região
colonizacao_bem_sucedida(Regiao) :-
    governador_geral(_, _, _, _),
    capitania_hereditaria(Regiao, _, _, Status),
    (Status = produtiva ; Status = prospera).

% Regra: Período de estabilidade administrativa
periodo_estavel(Inicio, Fim) :-
    governador_geral(_, Inicio, Fim, tipo_governo),
    tipo_governo \= conflitos_externos.

% Regra: Hierarquia social (superior governa inferior)
governa(Grupo1, Grupo2) :-
    estrutura_social(Grupo1, Nivel1, _),
    estrutura_social(Grupo2, Nivel2, _),
    superior_que(Nivel1, Nivel2).

% Regra: Determinando se um nível é superior
superior_que(superior, medio).
superior_que(superior, inferior).
superior_que(medio, inferior).

% Regra: Exploração econômica ocorre com
exploracao_economica(Grupo_Explorado, Atividade) :-
    atividade_economica(Atividade, _, _, _),
    grupo_populacional(Grupo_Explorado, _, _),
    (Atividade = trafico ; Atividade = latifundio),
    (Grupo_Explorado = africanos_escravos ; Grupo_Explorado = indigenas).

% Regra: Período de resistência ativa
resistencia_ativa(Periodo) :-
    conflito(_, _, Inicio, Fim, Tipo),
    (Tipo = resistencia_escravos ; Tipo = guerra_por_territorio),
    between(Inicio, Fim, Periodo).

% Regra: Instituição controladora de poder
instituicao_poder(Instituicao) :-
    instituicao(Instituicao, Tipo, _, _),
    (Tipo = administrativa ; Tipo = religiosa_repressiva).

% Regra: Transformação demográfica (miscigenação)
transformacao_demografica :-
    grupo_populacional(mesticos, _, _),
    grupo_populacional(portugues, _, _),
    grupo_populacional(indigenas, _, _).

% Regra: Período de contato inicial (antes de 1550)
periodo_contato_inicial :-
    primeiro_contato(brasil, europeus, Ano, _),
    Ano < 1550.

% Regra: Colonização consolidada (após 1600)
colonizacao_consolidada :-
    atividade_economica(acucar, _, _, _),
    atividade_economica(gado, _, _, _),
    instituicao(câmara_municipal, _, _, _).

% Regra: Resistência indígena documentada
resistencia_indigena :-
    conflito(indigenas, _, _, _, _).


% ============================================================================
% 8. CONSULTAS SUGERIDAS
% ============================================================================

% ?- descobridor(Quem, brasil, Ano).
% → Quem descobriu o Brasil e quando

% ?- governador_geral(G, Inicio, Fim, Tipo).
% → Lista dos governadores e seus períodos

% ?- produto_importante(P).
% → Produtos importantes na economia colonial

% ?- conflito(Grupo1, Grupo2, _, _, Tipo).
% → Quais foram os conflitos principais

% ?- exploracao_economica(Grupo, Atividade).
% → Quais grupos foram explorados e como

% ?- colonizacao_bem_sucedida(R).
% → Onde a colonização foi bem-sucedida

% ?- transformacao_demografica.
% → Houve miscigenação/transformação demográfica?

% ?- resistencia_ativa(Ano).
% → Em quais anos houve resistência ativa?

% ?- findall(Produto, produto_importante(Produto), Lista).
% → Lista todos os produtos importantes

% ?- colonizacao_consolidada.
% → A colonização foi consolidada?


% ============================================================================
% 9. FATOS ADICIONAIS: CRONOLOGIA IMPORTANTE
% ============================================================================

evento_importante(descoberta_brasil, 1500, pedro_alvares_cabral).
evento_importante(primeiro_engenho_acucar, 1532, sao_vicente).
evento_importante(fundacao_salvador, 1549, tom_de_sousa).
evento_importante(criacao_governo_geral, 1549, unificacao_administrativa).
evento_importante(fundacao_rio_janeiro, 1565, estacio_de_sa).
evento_importante(expulsao_franceses, 1567, mem_de_sa).
evento_importante(uniao_coronas_ibéricas, 1580, integracao_politica).
evento_importante(invasao_holandesa_pernambuco, 1630, ocupacao_nordeste).
evento_importante(batida_palmares, 1695, zumbi).
evento_importante(elevacao_brasil_reino, 1815, joao_vi).
evento_importante(independencia_brasil, 1822, dom_pedro_i).


% ============================================================================
% 10. PREDICADO DE ANÁLISE: SÍNTESE DA COLONIZAÇÃO
% ============================================================================

analise_colonizacao :-
    write('\n=== ANÁLISE DA COLONIZAÇÃO PORTUGUESA NO BRASIL ===\n'),
    write('1. PERÍODO INICIAL (1500-1550): Contato e Exploração\n'),
    write('   - Descoberta do Brasil por Cabral (1500)\n'),
    write('   - Extração de pau-brasil\n'),
    write('   - Primeiros contatos com indígenas\n\n'),
    write('2. PERÍODO DE ORGANIZAÇÃO (1550-1600): Estruturação\n'),
    write('   - Criação do Governo Geral (1549)\n'),
    write('   - Implantação de capitanias\n'),
    write('   - Início da produção açucareira\n\n'),
    write('3. PERÍODO DE CONSOLIDAÇÃO (1600-1700): Expansão\n'),
    write('   - Estabelecimento da economia açucareira\n'),
    write('   - Resistência indígena e quilombola\n'),
    write('   - Invasão holandesa em Pernambuco\n\n'),
    write('4. PERÍODO DE ESTABILIDADE (1700-1822): Apogeu e Transformação\n'),
    write('   - Transferência de capital para Rio de Janeiro\n'),
    write('   - Descoberta do ouro em Minas Gerais\n'),
    write('   - Elevação a Reino (1815)\n'),
    write('   - Independência (1822)\n\n').

% ============================================================================
% FIM DO ARQUIVO
% ============================================================================
