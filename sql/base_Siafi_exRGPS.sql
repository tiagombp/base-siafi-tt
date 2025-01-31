select	coalesce(pa11.ID_ESFERA_ORCAMENTARIA, pa12.ID_ESFERA_ORCAMENTARIA)  ID_ESFERA_ORCAMENTARIA,
	max(a15.NO_ESFERA_ORCAMENTARIA)  NO_ESFERA_ORCAMENTARIA,
	coalesce(pa11.ID_FUNCAO_PT, pa12.ID_FUNCAO_PT)  ID_FUNCAO_PT,
	max(a16.NO_FUNCAO_PT)  ID_FUNCAO_PT0,
	coalesce(pa11.ID_SUBFUNCAO_PT, pa12.ID_SUBFUNCAO_PT)  ID_SUBFUNCAO_PT,
	max(a112.NO_SUBFUNCAO_PT)  NO_SUBFUNCAO_PT,
	coalesce(pa11.ID_PROGRAMA_PT, pa12.ID_PROGRAMA_PT)  ID_PROGRAMA_PT,
	max(a111.NO_PROGRAMA_PT)  NO_PROGRAMA_PT,
	coalesce(pa11.ID_ACAO_PT, pa12.ID_ACAO_PT)  ID_ACAO_PT,
	max(a13.NO_ACAO_PT)  NO_ACAO_PT,
	coalesce(pa11.ID_GRUPO_DESPESA_NADE, pa12.ID_GRUPO_DESPESA_NADE)  ID_GRUPO_DESPESA_NADE,
	max(a17.NO_GRUPO_DESPESA_NADE)  NO_GRUPO_DESPESA_NADE,
	coalesce(pa11.ID_MOAP_NADE, pa12.ID_MOAP_NADE)  ID_MOAP_NADE,
	max(a19.CO_MOAP_NADE)  CO_MOAP_NADE,
	max(a19.NO_MOAP_NADE)  NO_MOAP_NADE,
	coalesce(pa11.ID_ELEMENTO_DESPESA_NADE, pa12.ID_ELEMENTO_DESPESA_NADE)  ID_ELEMENTO_DESPESA_NADE,
	max(a14.CO_ELEMENTO_DESPESA_NADE)  CO_NATUREZA_DESPESA,
	max(a14.NO_ELEMENTO_DESPESA_NADE)  NO_NATUREZA_DESPESA,
	coalesce(pa11.ID_ANO_LANC, pa12.ID_ANO_LANC)  ID_ANO_LANC,
	coalesce(pa11.ID_MES_LANC, pa12.ID_MES_LANC)  ID_MES_LANC,
	max(a110.SG_MES_COMPLETO)  SG_MES_COMPLETO,
	coalesce(pa11.ID_ITEM_INFORMACAO, pa12.ID_ITEM_INFORMACAO)  ID_ITEM_INFORMACAO,
	max(a18.NO_ITEM_INFORMACAO)  NO_ITEM_INFORMACAO,
	max(a18.CO_ITEM_INFORMACAO)  CO_ITEM_INFORMACAO,
	max(pa11.SALDOANTRITEMINFORMAO)  SALDOANTRITEMINFORMAO,
	max(pa12.SALDORITEMINFORMAO)  SALDORITEMINFORMAO
from	(select	a11.ID_SUBFUNCAO_PT  ID_SUBFUNCAO_PT,
		a11.ID_PROGRAMA_PT  ID_PROGRAMA_PT,
		a16.ID_ANO  ID_ANO_LANC,
		a16.ID_MES  ID_MES_LANC,
		a11.ID_MOAP_NADE  ID_MOAP_NADE,
		a15.ID_ITEM_INFORMACAO  ID_ITEM_INFORMACAO,
		a11.ID_GRUPO_DESPESA_NADE  ID_GRUPO_DESPESA_NADE,
		a11.ID_FUNCAO_PT  ID_FUNCAO_PT,
		a11.ID_ESFERA_ORCAMENTARIA  ID_ESFERA_ORCAMENTARIA,
		a11.ID_ELEMENTO_DESPESA_NADE  ID_ELEMENTO_DESPESA_NADE,
		a11.ID_ACAO_PT  ID_ACAO_PT,
		sum(((a11.VA_MOVIMENTO_LIQUIDO * a15.IN_OPERACAO_EXPRESSAO) * a14.PE_TAXA_ANTERIOR))  SALDOANTRITEMINFORMAO
	from	WF_LANCAMENTO_EP20	a11
		join	WD_CONTA_CONTABIL_EXERCICIO	a12
		  on 	(a11.ID_ANO_LANC = a12.ID_ANO and 
		a11.ID_CONTA_CONTABIL_LANC = a12.ID_CONTA_CONTABIL)
		join	WD_MOEDA	a13
		  on 	(a11.ID_MOEDA_UG_EXEC_H = a13.ID_MOEDA)
		join	WD_TAXA_CAMBIO_MENSAL	a14
		  on 	(a13.ID_MOEDA = a14.ID_MOEDA_ORIGEM)
		join	WD_ITEM_DECODIFICADO_CCON	a15
		  on 	(a11.ID_ANO_LANC = a15.ID_ANO_ITEM_CONTA and 
		a11.ID_CONTA_CONTABIL_LANC = a15.ID_CONTA_CONTABIL and 
		a12.ID_ANO = a15.ID_ANO_ITEM_CONTA and 
		a12.ID_CONTA_CONTABIL = a15.ID_CONTA_CONTABIL)
		join	WA_MES_ACUM	a16
		  on 	(a11.ID_ANO_LANC = a16.ID_ANO_ACUM_ANO_SALDO and 
		a11.ID_MES_LANC = (a16.ID_MES_ACUM_ANO_SALDO - 1))
		join	WD_UO_EXERCICIO	a17
		  on 	(a11.ID_ANO_LANC = a17.ID_ANO and 
		a11.ID_UO = a17.ID_UO)
		join	WD_UG_EXERCICIO	a18
		  on 	(a11.ID_ANO_LANC = a18.ID_ANO and 
		a11.ID_UG_EXEC = a18.ID_UG)
		join	WD_ORGAO	a19
		  on 	(a18.ID_ORGAO_UG = a19.ID_ORGAO)
		join	WD_MES	a110
		  on 	(a16.ID_ANO = a110.ID_ANO and 
		a16.ID_MES = a110.ID_MES)
	where	(a15.ID_ITEM_INFORMACAO in (61)
	 and a19.ID_ORCA_FISCAL_ORGAO in (0)
	 and a17.ID_UO not in (40904, 55902, 33904)
	 and a110.ID_ANO between 2008 and 2019
	 and a14.ID_ANO = a110.ID_ANO
	 and a14.ID_MES = a110.ID_MES)
	group by	a11.ID_SUBFUNCAO_PT,
		a11.ID_PROGRAMA_PT,
		a16.ID_ANO,
		a16.ID_MES,
		a11.ID_MOAP_NADE,
		a15.ID_ITEM_INFORMACAO,
		a11.ID_GRUPO_DESPESA_NADE,
		a11.ID_FUNCAO_PT,
		a11.ID_ESFERA_ORCAMENTARIA,
		a11.ID_ELEMENTO_DESPESA_NADE,
		a11.ID_ACAO_PT
	)	pa11
	full outer join	(select	a11.ID_SUBFUNCAO_PT  ID_SUBFUNCAO_PT,
		a11.ID_PROGRAMA_PT  ID_PROGRAMA_PT,
		a16.ID_ANO  ID_ANO_LANC,
		a16.ID_MES  ID_MES_LANC,
		a11.ID_MOAP_NADE  ID_MOAP_NADE,
		a15.ID_ITEM_INFORMACAO  ID_ITEM_INFORMACAO,
		a11.ID_GRUPO_DESPESA_NADE  ID_GRUPO_DESPESA_NADE,
		a11.ID_FUNCAO_PT  ID_FUNCAO_PT,
		a11.ID_ESFERA_ORCAMENTARIA  ID_ESFERA_ORCAMENTARIA,
		a11.ID_ELEMENTO_DESPESA_NADE  ID_ELEMENTO_DESPESA_NADE,
		a11.ID_ACAO_PT  ID_ACAO_PT,
		sum(((a11.VA_MOVIMENTO_LIQUIDO * a15.IN_OPERACAO_EXPRESSAO) * a14.PE_TAXA))  SALDORITEMINFORMAO
	from	WF_LANCAMENTO_EP20	a11
		join	WD_CONTA_CONTABIL_EXERCICIO	a12
		  on 	(a11.ID_ANO_LANC = a12.ID_ANO and 
		a11.ID_CONTA_CONTABIL_LANC = a12.ID_CONTA_CONTABIL)
		join	WD_MOEDA	a13
		  on 	(a11.ID_MOEDA_UG_EXEC_H = a13.ID_MOEDA)
		join	WD_TAXA_CAMBIO_MENSAL	a14
		  on 	(a13.ID_MOEDA = a14.ID_MOEDA_ORIGEM)
		join	WD_ITEM_DECODIFICADO_CCON	a15
		  on 	(a11.ID_ANO_LANC = a15.ID_ANO_ITEM_CONTA and 
		a11.ID_CONTA_CONTABIL_LANC = a15.ID_CONTA_CONTABIL and 
		a12.ID_ANO = a15.ID_ANO_ITEM_CONTA and 
		a12.ID_CONTA_CONTABIL = a15.ID_CONTA_CONTABIL)
		join	WA_MES_ACUM	a16
		  on 	(a11.ID_ANO_LANC = a16.ID_ANO_ACUM_ANO_SALDO and 
		a11.ID_MES_LANC = a16.ID_MES_ACUM_ANO_SALDO)
		join	WD_UO_EXERCICIO	a17
		  on 	(a11.ID_ANO_LANC = a17.ID_ANO and 
		a11.ID_UO = a17.ID_UO)
		join	WD_UG_EXERCICIO	a18
		  on 	(a11.ID_ANO_LANC = a18.ID_ANO and 
		a11.ID_UG_EXEC = a18.ID_UG)
		join	WD_ORGAO	a19
		  on 	(a18.ID_ORGAO_UG = a19.ID_ORGAO)
		join	WD_MES	a110
		  on 	(a16.ID_ANO = a110.ID_ANO and 
		a16.ID_MES = a110.ID_MES)
	where	(a15.ID_ITEM_INFORMACAO in (61)
	 and a19.ID_ORCA_FISCAL_ORGAO in (0)
	 and a17.ID_UO not in (40904, 55902, 33904)
	 and a110.ID_ANO between 2008 and 2019
	 and a14.ID_ANO = a110.ID_ANO
	 and a14.ID_MES = a110.ID_MES)
	group by	a11.ID_SUBFUNCAO_PT,
		a11.ID_PROGRAMA_PT,
		a16.ID_ANO,
		a16.ID_MES,
		a11.ID_MOAP_NADE,
		a15.ID_ITEM_INFORMACAO,
		a11.ID_GRUPO_DESPESA_NADE,
		a11.ID_FUNCAO_PT,
		a11.ID_ESFERA_ORCAMENTARIA,
		a11.ID_ELEMENTO_DESPESA_NADE,
		a11.ID_ACAO_PT
	)	pa12
	  on 	(pa11.ID_ACAO_PT = pa12.ID_ACAO_PT and 
	pa11.ID_ANO_LANC = pa12.ID_ANO_LANC and 
	pa11.ID_ELEMENTO_DESPESA_NADE = pa12.ID_ELEMENTO_DESPESA_NADE and 
	pa11.ID_ESFERA_ORCAMENTARIA = pa12.ID_ESFERA_ORCAMENTARIA and 
	pa11.ID_FUNCAO_PT = pa12.ID_FUNCAO_PT and 
	pa11.ID_GRUPO_DESPESA_NADE = pa12.ID_GRUPO_DESPESA_NADE and 
	pa11.ID_ITEM_INFORMACAO = pa12.ID_ITEM_INFORMACAO and 
	pa11.ID_MES_LANC = pa12.ID_MES_LANC and 
	pa11.ID_MOAP_NADE = pa12.ID_MOAP_NADE and 
	pa11.ID_PROGRAMA_PT = pa12.ID_PROGRAMA_PT and 
	pa11.ID_SUBFUNCAO_PT = pa12.ID_SUBFUNCAO_PT)
	join	WD_ACAO_PT	a13
	  on 	(coalesce(pa11.ID_ACAO_PT, pa12.ID_ACAO_PT) = a13.ID_ACAO_PT)
	join	WD_ELEMENTO_DESPESA_NADE	a14
	  on 	(coalesce(pa11.ID_ELEMENTO_DESPESA_NADE, pa12.ID_ELEMENTO_DESPESA_NADE) = a14.ID_ELEMENTO_DESPESA_NADE)
	join	WD_ESFERA_ORCAMENTARIA	a15
	  on 	(coalesce(pa11.ID_ESFERA_ORCAMENTARIA, pa12.ID_ESFERA_ORCAMENTARIA) = a15.ID_ESFERA_ORCAMENTARIA)
	join	WD_FUNCAO_PT	a16
	  on 	(coalesce(pa11.ID_FUNCAO_PT, pa12.ID_FUNCAO_PT) = a16.ID_FUNCAO_PT)
	join	WD_GRUPO_DESPESA_NADE	a17
	  on 	(coalesce(pa11.ID_GRUPO_DESPESA_NADE, pa12.ID_GRUPO_DESPESA_NADE) = a17.ID_GRUPO_DESPESA_NADE)
	join	WD_ITEM_INFORMACAO	a18
	  on 	(coalesce(pa11.ID_ITEM_INFORMACAO, pa12.ID_ITEM_INFORMACAO) = a18.ID_ITEM_INFORMACAO)
	join	WD_MODALIDADE_APLICACAO_NADE	a19
	  on 	(coalesce(pa11.ID_MOAP_NADE, pa12.ID_MOAP_NADE) = a19.ID_MOAP_NADE)
	join	WD_MES	a110
	  on 	(coalesce(pa11.ID_ANO_LANC, pa12.ID_ANO_LANC) = a110.ID_ANO and 
	coalesce(pa11.ID_MES_LANC, pa12.ID_MES_LANC) = a110.ID_MES)
	join	WD_PROGRAMA_PT	a111
	  on 	(coalesce(pa11.ID_PROGRAMA_PT, pa12.ID_PROGRAMA_PT) = a111.ID_PROGRAMA_PT)
	join	WD_SUBFUNCAO_PT	a112
	  on 	(coalesce(pa11.ID_SUBFUNCAO_PT, pa12.ID_SUBFUNCAO_PT) = a112.ID_SUBFUNCAO_PT)
group by	coalesce(pa11.ID_ESFERA_ORCAMENTARIA, pa12.ID_ESFERA_ORCAMENTARIA),
	coalesce(pa11.ID_FUNCAO_PT, pa12.ID_FUNCAO_PT),
	coalesce(pa11.ID_SUBFUNCAO_PT, pa12.ID_SUBFUNCAO_PT),
	coalesce(pa11.ID_PROGRAMA_PT, pa12.ID_PROGRAMA_PT),
	coalesce(pa11.ID_ACAO_PT, pa12.ID_ACAO_PT),
	coalesce(pa11.ID_GRUPO_DESPESA_NADE, pa12.ID_GRUPO_DESPESA_NADE),
	coalesce(pa11.ID_MOAP_NADE, pa12.ID_MOAP_NADE),
	coalesce(pa11.ID_ELEMENTO_DESPESA_NADE, pa12.ID_ELEMENTO_DESPESA_NADE),
	coalesce(pa11.ID_ANO_LANC, pa12.ID_ANO_LANC),
	coalesce(pa11.ID_MES_LANC, pa12.ID_MES_LANC),
	coalesce(pa11.ID_ITEM_INFORMACAO, pa12.ID_ITEM_INFORMACAO)