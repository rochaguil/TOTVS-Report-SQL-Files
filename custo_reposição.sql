USE PUOBH2;

DECLARE @USD NVARCHAR(50)
DECLARE @EUR NVARCHAR(50)

SET @USD = 4.945
SET @EUR = 6.1608

--FATOR CUSTO (SEM ICMS/IPI)
---- início CMV -----
IF OBJECT_ID('tempdb..#CMV') IS NOT NULL DROP TABLE #CMV

SELECT B1_COD, AVG(CMV) CMV INTO #CMV FROM (
SELECT B1_COD, AVG(B9_CM1) CMV
			FROM SB9010 SB9, SB1010 SB1
			WHERE
				B9_DATA = '20210331'
				--AND ((B9_LOCAL = '01' AND B9_FILIAL = '01') OR (B9_LOCAL = '05'AND B9_FILIAL = '02')) 
				--AND B9_VINI1 <> 0
				AND SB9.D_E_L_E_T_ <> '*'
				AND SB1.D_E_L_E_T_ <> '*'
				AND B1_COD = B9_COD
			GROUP BY B1_COD
UNION ALL
SELECT B1_COD, AVG(B9_CM1)
			FROM SB9020 SB9, SB1020 SB1
			WHERE
				B9_DATA = '20210331'
				--AND ((B9_LOCAL = '01' AND B9_FILIAL = '01') OR (B9_LOCAL = '05'AND B9_FILIAL = '02')) 
				--AND B9_VINI1 <> 0
				AND SB9.D_E_L_E_T_ <> '*'
				AND SB1.D_E_L_E_T_ <> '*'
				AND B1_COD = B9_COD
			GROUP BY B1_COD
			--order by B1_COD
			) t
GROUP BY B1_COD
----- fim CMV -------

-------------- início ultimo preço -----------------------
IF OBJECT_ID('tempdb..#ULT_PRECO') IS NOT NULL DROP TABLE #ULT_PRECO

SELECT * INTO #ULT_PRECO FROM (
select * from (

SELECT t.B1_COD, t.D1_DTDIGIT, B1_DESC, C7_MOEDA, SUM(C7_TOTAL) / SUM(D1_QUANT) C7_PRECO, ULT_DATA FROM (
	SELECT D1_QUANT, C7_TOTAL, C7_QUANT,B1_COD,SD1.D1_DTDIGIT,B1_DESC, IIF(C7_PO_EIC = '',C7_NUM, C7_PO_EIC) PO, C7_MOEDA, C7_PRECO
	FROM SC7010 SC7, SA2010 SA2, SB1010 SB1, CTD010 CTD, SD1010 SD1
	WHERE SC7.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND SD1.D1_COD = C7_PRODUTO AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = C7_PRODUTO AND CTD.D_E_L_E_T_ <> '*' AND CTD_ITEM = B1_ITEMCC
	AND A2_EST = 'EX'
	) t
join (SELECT MAX(SD1.D1_DTDIGIT) ULT_DATA, B1_COD FROM SC7010 SC7, SA2010 SA2, SB1010 SB1, CTD010 CTD, SD1010 SD1
	WHERE SC7.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND SD1.D1_COD = C7_PRODUTO AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = C7_PRODUTO AND CTD.D_E_L_E_T_ <> '*' AND CTD_ITEM = B1_ITEMCC
	AND A2_EST = 'EX'
	GROUP BY B1_COD
	) ult_data ON
	t.B1_COD = ult_data.B1_COD AND D1_DTDIGIT = ULT_DATA
	GROUP BY t.B1_COD, t.D1_DTDIGIT, B1_DESC, C7_MOEDA, ULT_DATA
	) u
--AND B1_COD LIKE '%5MAX%'

UNION ALL

select * from (
SELECT t.B1_COD, t.D1_DTDIGIT, B1_DESC, C7_MOEDA, SUM(C7_TOTAL) / SUM(D1_QUANT) C7_PRECO, ULT_DATA FROM (
	SELECT D1_QUANT, C7_TOTAL, C7_QUANT,B1_COD,SD1.D1_DTDIGIT,B1_DESC, IIF(C7_PO_EIC = '',C7_NUM, C7_PO_EIC) PO, C7_MOEDA, C7_PRECO
	FROM SC7020 SC7, SA2020 SA2, SB1020 SB1, CTD020 CTD, SD1020 SD1
	WHERE SC7.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND SD1.D1_COD = C7_PRODUTO AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = C7_PRODUTO AND CTD.D_E_L_E_T_ <> '*' AND CTD_ITEM = B1_ITEMCC
	AND A2_EST = 'EX'
	) t
join (SELECT MAX(SD1.D1_DTDIGIT) ULT_DATA, B1_COD FROM SC7020 SC7, SA2020 SA2, SB1020 SB1, CTD020 CTD, SD1020 SD1
	WHERE SC7.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND SD1.D1_COD = C7_PRODUTO AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = C7_PRODUTO AND CTD.D_E_L_E_T_ <> '*' AND CTD_ITEM = B1_ITEMCC
	AND A2_EST = 'EX'
	GROUP BY B1_COD
	--ORDER BY B1_COD
	) ult_data ON
	t.B1_COD = ult_data.B1_COD AND D1_DTDIGIT = ULT_DATA
	GROUP BY t.B1_COD, t.D1_DTDIGIT, B1_DESC, C7_MOEDA, ULT_DATA
	) u
--where D1_DTDIGIT = ULT_DATA

) t
-------------- fim ultimo preço -----------------------

DECLARE @DATA NVARCHAR(50)
DECLARE @DATAINIC NVARCHAR(50)
SET @DATA = GETDATE() - 365*2
SET @DATAINIC = CONVERT(VARCHAR(4), DATEPART(YEAR,@DATA)) + RIGHT('0' + CONVERT(NVARCHAR(2), DATEPART(MONTH,@DATA)),2) + '01'

SELECT    Linha
        , Produto
        , FORMAT(sum([Vlr. Total Entrada Moeda]) / sum([Vlr. Total Compra]) - 1, '#.##%','pt-br') [Fator Custo]
		, [Último Preço]
		, FORMAT((SELECT CMV FROM #CMV WHERE B1_COD = Produto),'#,###','pt-br') CMV
		, Moeda
		, CASE
		    WHEN [Moeda] = 'USD' THEN FORMAT([Último Preço] * sum([Vlr. Total Entrada Moeda]) / sum([Vlr. Total Compra]) * @USD, '#,###','pt-br') 
			WHEN [Moeda] = 'EUR' THEN FORMAT([Último Preço] * sum([Vlr. Total Entrada Moeda]) / sum([Vlr. Total Compra]) * @EUR,'#,###','pt-br')
			END [Custo Reposição]
		FROM (

SELECT
        Linha
      , [Numero PC]
	  , Produto
	  , SUBSTRING(D1_DTDIGIT, 7,2) + '/' + SUBSTRING(D1_DTDIGIT, 5,2) + '/' + SUBSTRING(D1_DTDIGIT, 1,4) [Data Entrada]
	  , Moeda
	  , SUM(C7_TOTAL) [Vlr. Total Compra]
	  , SUM(D1_TOTAL) [Vlr. Total Entrada]
	  , CASE
	  WHEN Moeda = 'USD' THEN SUM(D1_TOTAL) / (SELECT YE_VLCON_C FROM SYE010 SYE WHERE SYE.D_E_L_E_T_ <> '*' AND YE_MOEDA = 'US$' AND YE_DATA = D1_DTDIGIT)
	  WHEN Moeda = 'EUR' THEN SUM(D1_TOTAL) / (SELECT YE_VLCON_C FROM SYE010 SYE WHERE SYE.D_E_L_E_T_ <> '*' AND YE_MOEDA = 'EUR' AND YE_DATA = D1_DTDIGIT)
	  END [Vlr. Total Entrada Moeda]
	  , CASE
	  WHEN Moeda = 'USD' THEN (SUM(D1_TOTAL) / (SELECT YE_VLCON_C FROM SYE010 SYE WHERE SYE.D_E_L_E_T_ <> '*' AND YE_MOEDA = 'US$' AND YE_DATA = D1_DTDIGIT)) / SUM(C7_TOTAL) - 1
	  WHEN Moeda = 'EUR' THEN (SUM(D1_TOTAL) / (SELECT YE_VLCON_C FROM SYE010 SYE WHERE SYE.D_E_L_E_T_ <> '*' AND YE_MOEDA = 'EUR' AND YE_DATA = D1_DTDIGIT)) / SUM(C7_TOTAL) - 1
	  END [Perc. Fator Custo]
	  , (SELECT C7_PRECO FROM #ULT_PRECO WHERE B1_COD = Produto) [Último Preço]
FROM
(
SELECT [DT Emissao],Produto,Empresa, Moeda,Linha,[Numero PC], SUM([Vlr.Total]) C7_TOTAL FROM (

SELECT 'Nome1' AS Empresa, CTT_DESC01 "Centro Custo", CTD_DESC01 Linha,C7_FILIAL Filial, A2_NOME "Razao Social", A2_NREDUZ "N Fantasia", B1_COD Produto, B1_DESC Descricao, C7_QUANT Quantidade, C7_QUJE "Quantidade Entregue", C7_PRECO "Prc Unitario",
IIF(C7_PO_EIC = '', C7_NUM, C7_PO_EIC) "Numero PC", IIF(C7_RESIDUO = 'S', C7_QUJE,C7_QUANT) * C7_PRECO "Vlr.Total", SUBSTRING(C7_EMISSAO, 7,2) + '/' + SUBSTRING(C7_EMISSAO , 5,2) + '/' + SUBSTRING(C7_EMISSAO ,1,4) AS "DT Emissao", C7_ENCER "Ped. Encerr.", C7_RESIDUO Resíduo,
CASE
 WHEN C7_MOEDA = 2 THEN 'USD'
 WHEN C7_MOEDA = 4 THEN 'EUR' END Moeda,
B1_TIPO Tipo, A2_EST Estado
FROM SC7020
LEFT JOIN (SELECT * FROM SB1020 WHERE SB1020.D_E_L_E_T_ <> '*') SB1020 ON
SC7020.C7_PRODUTO = SB1020.B1_COD
LEFT JOIN (SELECT * FROM CTD020 WHERE CTD020.D_E_L_E_T_ <> '*') CTD020 ON
CTD020.CTD_ITEM = SB1020.B1_ITEMCC
LEFT JOIN (SELECT * FROM CTT020 WHERE CTT020.D_E_L_E_T_ <> '*') CTT020 ON
CTT020.CTT_CUSTO = SB1020.B1_CC
LEFT JOIN (SELECT * FROM SA2020 WHERE SA2020.D_E_L_E_T_ <> '*') SA2 ON
SA2.A2_COD = C7_FORNECE AND SA2.A2_LOJA = C7_LOJA
WHERE SC7020.D_E_L_E_T_ <> '*'
AND A2_EST = 'EX'
AND C7_EMISSAO >= @DATAINIC

UNION ALL

SELECT
        'Nome2' as Empresa
       , CTT_DESC01 "Centro Custo"
	   , CTD_DESC01 Linha
	   , C7_FILIAL Filial
	   , A2_NOME "Razao Social"
	   , A2_NREDUZ "N Fantasia"
	   , B1_COD Produto
	   , B1_DESC Descricao
	   , C7_QUANT Quantidade
	   , C7_QUJE "Quantidade Entregue"
	   ,C7_PRECO "Prc Unitario"
	   , IIF(C7_PO_EIC = '', C7_NUM, C7_PO_EIC) "Numero PC"
	   , IIF(C7_RESIDUO = 'S', C7_QUJE,C7_QUANT) * C7_PRECO "Vlr.Total"
	   , SUBSTRING(C7_EMISSAO, 7,2) + '/' + SUBSTRING(C7_EMISSAO , 5,2) + '/' + SUBSTRING(C7_EMISSAO ,1,4) AS "DT Emissao"
	   , C7_ENCER "Ped. Encerr."
	   , C7_RESIDUO Resíduo
	   , CASE
                WHEN C7_MOEDA = 2 THEN 'USD'
                WHEN C7_MOEDA = 4 THEN 'EUR' END Moeda
				, B1_TIPO Tipo
				, A2_EST Estado
FROM SC7010
LEFT JOIN (SELECT * FROM SB1010 WHERE SB1010.D_E_L_E_T_ <> '*') SB1010 ON
SC7010.C7_PRODUTO = SB1010.B1_COD
LEFT JOIN (SELECT * FROM CTD010 WHERE CTD010.D_E_L_E_T_ <> '*') CTD010 ON
CTD010.CTD_ITEM = SB1010.B1_ITEMCC
LEFT JOIN (SELECT * FROM SA2010 WHERE SA2010.D_E_L_E_T_ <> '*') SA2 ON
SA2.A2_COD = C7_FORNECE AND SA2.A2_LOJA = C7_LOJA
LEFT JOIN (SELECT * FROM CTT010 WHERE CTT010.D_E_L_E_T_ <> '*') CTT010 ON
CTT010.CTT_CUSTO = SB1010.B1_CC
WHERE SC7010.D_E_L_E_T_ <> '*'
AND A2_EST = 'EX'
AND C7_EMISSAO >= @DATAINIC
) t
GROUP BY [Numero PC], Produto,Empresa, Linha, Moeda, [DT Emissao]
) t2

LEFT JOIN
(SELECT 'Nome1' AS Empresa, D1_COD,IIF(C7_PO_EIC = '', D1_PEDIDO, C7_PO_EIC) PC, C7_PO_EIC, D1_PEDIDO, iif(C7_PO_EIC = '', SUM(D1_TOTAL), SUM(D1_TOTAL + D1_DESPESA + D1_VALIMP5 + D1_VALIMP6)) D1_TOTAL, D1_DTDIGIT FROM SD1010 LEFT JOIN (SELECT DISTINCT C7_FILIAL, C7_NUM, C7_PO_EIC FROM SC7010 WHERE D_E_L_E_T_ <> '*') PO ON C7_NUM = D1_PEDIDO AND D1_FILIAL = C7_FILIAL
WHERE D_E_L_E_T_ <> '*' GROUP BY D1_PEDIDO, C7_PO_EIC, D1_DTDIGIT, D1_COD
UNION ALL
SELECT 'Nome2' AS Empresa,D1_COD, IIF(C7_PO_EIC = '', D1_PEDIDO, C7_PO_EIC) PC, C7_PO_EIC, D1_PEDIDO, iif(C7_PO_EIC = '', SUM(D1_TOTAL ), SUM(D1_TOTAL + D1_DESPESA + D1_VALIMP5 + D1_VALIMP6)) D1_TOTAL, D1_DTDIGIT FROM SD1020 LEFT JOIN (SELECT DISTINCT C7_FILIAL, C7_NUM, C7_PO_EIC FROM SC7020 WHERE D_E_L_E_T_ <> '*') PO ON C7_NUM = D1_PEDIDO AND D1_FILIAL = C7_FILIAL
WHERE D_E_L_E_T_ <> '*' GROUP BY D1_PEDIDO, C7_PO_EIC, D1_DTDIGIT,D1_COD) SD1 ON
PC = [Numero PC] AND t2.Empresa = SD1.Empresa and D1_COD = Produto
--WHERE C7_PO_EIC = 'M21008'
WHERE D1_DTDIGIT >= @DATAINIC
--Produto AND LIKE '%COD%'
GROUP BY Linha, Moeda, [Numero PC], D1_DTDIGIT, Produto
HAVING NOT sum(D1_TOTAL) is null
) t
WHERE NOT [Vlr. Total Entrada Moeda] IS NULL
--ORDER BY Linha
GROUP BY Linha, Produto, [Último Preço], Moeda


