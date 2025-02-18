IF OBJECT_ID('tempdb..#SD2') IS NOT NULL DROP TABLE #SD2

SELECT * INTO #SD2 FROM (
select DISTINCT D2_DOC D2_DOC_NUM, SUM(D2_TOTAL) D2_TOTAL, D2_SERIE, D2_FILIAL, D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2, max(PORC) PORC ,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
FROM(
SELECT D2_DOC, sum(D2_TOTAL) D2_TOTAL, D2_SERIE, D2_FILIAL, D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2, PORC,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
FROM(
SELECT
'SD2' as TAB
,D2_DOC, D2_SERIE, D2_FILIAL
,sum(D2_TOTAL) + SUM(D2_VALIPI) + SUM(D2_VALFRE) - SUM(VALOR) D2_TOTAL
,D2_VEND1, D2_VEND2  , C5_DTUSO,D2_COMIS1, D2_COMIS2
, PORC
,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
FROM (
SELECT
SUM(D2_TOTAL) D2_TOTAL, SUM(D2_VALIPI) D2_VALIPI, SUM(D2_VALFRE) D2_VALFRE
,ISNULL((SELECT SUM(FI7_VALOR) FROM FI7010 WHERE D_E_L_E_T_ <> '*' AND FI7_NUMORI = D2_DOC AND FI7_PRFORI = D2_SERIE AND FI7_FILIAL = D2_FILIAL),0) * 
SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE)  / (SELECT SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) FROM SD2010 t WHERE t.D_E_L_E_T_ <> '*' AND t.D2_DOC = SD2.D2_DOC AND t.D2_SERIE = SD2.D2_SERIE AND t.D2_FILIAL = SD2.D2_FILIAL)
VALOR
,D2_DOC, D2_SERIE, D2_FILIAL
,D2_VEND1, D2_VEND2  
, C5_DTUSO, D2_COMIS1, D2_COMIS2
, SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE)  / (SELECT SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) FROM SD2010 t WHERE t.D_E_L_E_T_ <> '*' AND t.D2_DOC = SD2.D2_DOC AND t.D2_SERIE = SD2.D2_SERIE AND t.D2_FILIAL = SD2.D2_FILIAL) PORC
,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
FROM SD2010 SD2
		LEFT JOIN SC5010 SC5 ON
		SC5.D_E_L_E_T_ <> '*' AND C5_NUM = D2_PEDIDO  AND C5_FILIAL = D2_FILIAL
		LEFT JOIN SB1010 SB1 ON
		SB1.D_E_L_E_T_ <> '*' AND B1_COD = D2_COD
		LEFT JOIN CTT010 CTT ON
		CTT.D_E_L_E_T_ <> '*' AND B1_CC = CTT_CUSTO
		LEFT JOIN CTD010 CTD ON
		CTD.D_E_L_E_T_ <> '*' AND B1_ITEMCC = CTD_ITEM
WHERE SD2.D_E_L_E_T_ <> '*'
--AND D2_DOC LIKE '%000081252%'
GROUP BY D2_DOC, D2_SERIE, D2_FILIAL,D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01) a
GROUP BY D2_DOC, D2_SERIE, D2_FILIAL,D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01, PORC
UNION ALL
SELECT
'FI7' as TAB
,NUMDES, D2_SERIE, D2_FILIAL
,SUM(VALOR) VALOR
,D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2
, PORC
,CTT_CUSTO
,CTT_DESC01
,CTD_ITEM
,CTD_DESC01
FROM (
SELECT
SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) D2_TOTAL
,ISNULL((SELECT SUM(FI7_VALOR) FROM FI7010 WHERE D_E_L_E_T_ <> '*'  AND FI7_NUMORI = D2_DOC AND FI7_PRFORI = D2_SERIE AND FI7_FILIAL = D2_FILIAL),0) * 
SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE)  / (SELECT SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) FROM SD2010 t WHERE t.D_E_L_E_T_ <> '*' AND t.D2_DOC = SD2.D2_DOC AND t.D2_SERIE = SD2.D2_SERIE AND t.D2_FILIAL = SD2.D2_FILIAL)
VALOR
,(SELECT DISTINCT FI7_NUMDES FROM FI7010 WHERE D_E_L_E_T_ <> '*' AND FI7_NUMORI = D2_DOC AND FI7_PRFORI = D2_SERIE AND FI7_FILIAL = D2_FILIAL) NUMDES, D2_SERIE, D2_FILIAL
,D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2  
, SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE)  / (SELECT SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) FROM SD2010 t WHERE t.D_E_L_E_T_ <> '*' AND t.D2_DOC = SD2.D2_DOC AND t.D2_SERIE = SD2.D2_SERIE AND t.D2_FILIAL = SD2.D2_FILIAL) PORC
, CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
FROM SD2010 SD2
	LEFT JOIN SC5010 SC5 ON
	SC5.D_E_L_E_T_ <> '*' AND C5_NUM = D2_PEDIDO  AND C5_FILIAL = D2_FILIAL
	LEFT JOIN SB1010 SB1 ON
		SB1.D_E_L_E_T_ <> '*' AND B1_COD = D2_COD
		LEFT JOIN CTT010 CTT ON
		CTT.D_E_L_E_T_ <> '*' AND B1_CC = CTT_CUSTO
		LEFT JOIN CTD010 CTD ON
		CTD.D_E_L_E_T_ <> '*' AND B1_ITEMCC = CTD_ITEM
WHERE
SD2.D_E_L_E_T_ <> '*'
GROUP BY D2_DOC, D2_SERIE, D2_FILIAL,D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01) b
WHERE NOT NUMDES IS NULL 
GROUP BY NUMDES, D2_SERIE, D2_FILIAL, D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2, PORC,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
) c
GROUP BY D2_DOC, D2_SERIE, D2_FILIAL, D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2, PORC,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
) d
GROUP BY D2_DOC, D2_SERIE, D2_FILIAL, D2_VEND1, D2_VEND2, C5_DTUSO,D2_COMIS1, D2_COMIS2,PORC,CTT_CUSTO
,CTT_DESC01
, CTD_ITEM
, CTD_DESC01
	) u	
	
SELECT E1_FILIAL
, E1_CLIENTE
, E1_LOJA
, SA3V.A3_GEREN
, D2_VEND2
, D2_VEND1
, IIF(E1_SERIE = '   ', '001', E1_SERIE) E1_SERIE
, E1_NUM, 
IIF(E1_PARCELA = '', 'ÚNICA', E1_PARCELA + '/' + 
CAST((SELECT MAX(E1_PARCELA) FROM SE1010 t WHERE t.D_E_L_E_T_ <> '*' AND t.E1_NUM = SE1.E1_NUM AND t.E1_FILIAL = SE1.E1_FILIAL AND t.E1_SERIE = SE1.E1_SERIE ) AS varchar)) PARCELA
, E1_TIPO
, E1_EMISSAO
, E1_VENCREA
, E1_BAIXA
, C5_DTUSO
, (SELECT SUM(D2_TOTAL) FROM #SD2 WHERE D2_DOC_NUM = E1_NUM
	AND D2_SERIE = IIF(E1_SERIE = '   ', '001', E1_SERIE)
	AND D2_FILIAL = E1_FILIAL AND D2_VEND1 = SD2.D2_VEND1
	AND D2_VEND2 = SD2.D2_VEND2)  VLR_NF
, (PORC)
, MAX(E1_VALOR)  VLR_TIT
, MAX(E1_SALDO)  E1_SALDO
, E5_DATA
,
	ISNULL(sum(case
	when E5_TIPODOC = 'DC' then E5_VALOR END),0) * (PORC)

	desconto
	, (ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * (E5_VLDESCO)
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL(E5_VLDESCO,0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then (E5_VLDESCO)
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN (E5_VLDESCO) END),0)
	) * (PORC)
	desconto_linha
,( ISNULL(sum(case 
	when E5_TIPODOC = 'ES' and E5_MOTBX = 'CMP' then -1 * ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	when E5_TIPODOC='CP' and E5_MOTBX = 'CMP' 
	then 1 * ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	-  ISNULL((A_E5_VALOR) - (A_E5_VLMULTA) - (A_E5_VLJUROS),0)
	END),0)
	)
	* (PORC)
	compensacao
, (ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * (E5_VLDECRE)
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL(E5_VLDECRE,0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then (E5_VLDECRE)
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN (E5_VLDECRE) END),0)
	) * (PORC)
	decrescimo
, (ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * (E5_VLACRES)
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL(E5_VLACRES,0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then (E5_VLACRES)
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN (E5_VLACRES) END),0)
	) * (PORC)
	acrescimos
, (ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL((A_E5_VALOR) - (A_E5_VLMULTA) - (A_E5_VLJUROS),0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS)) END),0)
	) * (PORC)
	total
, D2_COMIS1 COMIS_VEND
, D2_COMIS2 COMIS_GER
, ROUND(D2_COMIS1/ 100 * ( 
ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL((A_E5_VALOR) - (A_E5_VLMULTA) - (A_E5_VLJUROS),0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS)) END),0)
	) *  (PORC)
,2) 
VALCOM_VEN
, ROUND(D2_COMIS2/ 100 * ( 
	ISNULL(sum(case
	when E5_TIPODOC = 'ES' and E5_MOTBX <> 'CMP' then -1 * ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	when E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' then ISNULL((A_E5_VALOR) - (A_E5_VLMULTA) - (A_E5_VLJUROS),0)
	when E5_TIPODOC = 'BA' and E5_MOTBX = 'CEC' then ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS))
	WHEN E5_TIPODOC = 'VL' and E5_MOTBX <> 'CMP' THEN ((E5_VALOR) - (E5_VLMULTA) - (E5_VLJUROS)) END),0)
 ) * (PORC)
 ,2)
VALCOM_GER
, E1_TIPOLIQ
,CTT_CUSTO
,CTT_DESC01
,CTD_ITEM
,CTD_DESC01

FROM SE1010 SE1
	
	LEFT JOIN (SELECT 
	E5_NUMERO, E5_CLIENTE, E5_PARCELA,E5_TIPODOC, E5_TIPO,E5_MOTBX, E5_DATA, SUM(E5_VALOR) E5_VALOR, SUM(E5_VLMULTA) E5_VLMULTA, SUM(E5_VLJUROS) E5_VLJUROS, SUM(E5_VLDECRE) E5_VLDECRE, SUM(E5_VLACRES) E5_VLACRES, SUM(E5_VLDESCO) E5_VLDESCO
	FROM SE5010 WHERE D_E_L_E_T_ <> '*'
	GROUP BY E5_NUMERO, E5_CLIENTE, E5_PARCELA,E5_TIPODOC, E5_MOTBX, E5_DATA,E5_TIPO
	) SE5 ON
	E5_NUMERO = E1_NUM
	--AND E5_FILIAL = E1_FILIAL
	--AND E1_SERIE = E5_PREFIXO
	AND E1_CLIENTE = E5_CLIENTE  AND E1_TIPOLIQ <> 'LIQ' AND SE1.D_E_L_E_T_ <> '*' AND E5_PARCELA = E1_PARCELA
	AND E1_TIPO = E5_TIPO
	LEFT JOIN (SELECT
	E5_NUMERO A_E5_NUMERO, E5_CLIENTE A_E5_CLIENTE, E5_PARCELA A_E5_PARCELA,E5_TIPODOC A_E5_TIPODOC, E5_MOTBX A_E5_MOTBX, E5_DATA A_E5_DATA, SUM(E5_VALOR) A_E5_VALOR, SUM(E5_VLMULTA) A_E5_VLMULTA, SUM(E5_VLJUROS) A_E5_VLJUROS
	FROM SE5010 WHERE D_E_L_E_T_ <> '*' AND E5_TIPODOC = 'CP' and E5_MOTBX = 'CMP' and E5_HISTOR like '%Adiantamentos%'
	GROUP BY E5_NUMERO, E5_CLIENTE, E5_PARCELA,E5_TIPODOC, E5_MOTBX, E5_DATA
	) SE5_A ON
	A_E5_NUMERO = E1_NUM
	--AND E5_FILIAL = E1_FILIAL
	--AND E1_SERIE = E5_PREFIXO
	AND E1_CLIENTE = A_E5_CLIENTE  AND E1_TIPOLIQ <> 'LIQ' AND SE1.D_E_L_E_T_ <> '*' AND A_E5_PARCELA = E1_PARCELA
	LEFT JOIN #SD2 SD2
	ON
	D2_DOC_NUM = E1_NUM AND D2_FILIAL = E1_FILIAL
	AND D2_SERIE = IIF(E1_SERIE = '   ', '001', E1_SERIE)
	LEFT JOIN SA3010 SA3V ON
	SA3V.D_E_L_E_T_ <> '*' AND A3_COD = E1_VEND1
	LEFT JOIN SA3010 SA3G ON
	SA3G.D_E_L_E_T_ <> '*' AND SA3V.A3_GEREN = SA3G.A3_COD
WHERE SE1.D_E_L_E_T_ <> '*' 
	--AND E1_SALDO = 0
				AND E1_EMISSAO >= '20190801'				
				GROUP BY E1_FILIAL, E1_NUM, E1_CLIENTE,E1_SERIE, E1_PARCELA,C5_DTUSO, E1_VEND1, SA3V.A3_GEREN, E1_TIPO, E1_BAIXA
					, E1_EMISSAO, E1_VENCREA, E1_COMIS1, E1_BASCOM1, E1_VALCOM1, E1_LOJA, E1_DESCONT
					, D2_COMIS1, D2_COMIS2
					, D2_VEND2
					, E1_TIPOLIQ
					, D2_VEND1
					, E5_DATA
					, PORC
					, CTT_CUSTO
					, CTT_DESC01
					, CTD_ITEM
					, CTD_DESC01
