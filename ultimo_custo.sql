
-- ULTIMO CUSTO SD2
SELECT D2_COD, B1_DESC, SUBSTRING(B1_POSIPI, 1,4) + '.' + SUBSTRING(B1_POSIPI,5,2) + '.' + SUBSTRING(B1_POSIPI,7,2) AS NCM, CTD_DESC01,
FORMAT(SUM(D2_CUSTO1) / NULLIF(SUM(D2_QUANT),0),'#,###.##','pt-br') CUSTO_UNIT,
FORMAT(MIN(CUSTO), '#,###.##','pt-br') MINIMO,
FORMAT(MAX(CUSTO), '#,###.##','pt-br') MAXIMO,
B1_PICM,B1_PPIS, B1_PCOFINS, B1_IPI
FROM (
SELECT SD2.D2_FILIAL, SD2.D2_LOCAL, SD2.D2_COD, SD2.D2_EMISSAO, SUM(SD2.D2_CUSTO1) D2_CUSTO1, SUM(SD2.D2_QUANT) D2_QUANT, SUM(SD2.D2_CUSTO1)/NULLIF(SUM(SD2.D2_QUANT),0) CUSTO FROM SD2010 SD2 
JOIN (SELECT MAX(D2_EMISSAO) MAX_DATE, D2_COD, SD2010.D2_FILIAL, SD2010.D2_LOCAL FROM SD2010 WHERE SD2010.D_E_L_E_T_ <> '*' GROUP BY SD2010.D2_COD, SD2010.D2_FILIAL, SD2010.D2_LOCAL) SD2G ON SD2.D2_COD = SD2G.D2_COD
WHERE SD2.D_E_L_E_T_ <> '*' AND SD2.D2_EMISSAO = SD2G.MAX_DATE AND SD2.D2_EMISSAO > '20190101'
--AND SD2.D2_COD LIKE '%XCEL%'
GROUP BY SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_FILIAL, SD2.D2_LOCAL) SD
JOIN SB1010 SB1 ON
SB1.D_E_L_E_T_ <> '*' AND SD.D2_COD = SB1.B1_COD
JOIN CTD010 CTD ON
CTD.D_E_L_E_T_ <> '*' AND CTD.CTD_ITEM = SB1.B1_ITEMCC
WHERE B1_TIPO = 'PA'
GROUP BY CTD_DESC01, SD.D2_COD, B1_DESC, B1_POSIPI, B1_PICM, B1_PPIS, B1_PCOFINS, B1_IPI
ORDER BY CTD_DESC01, SD.D2_COD, B1_DESC, B1_POSIPI, B1_PICM, B1_PPIS, B1_PCOFINS, B1_IPI

-- CUSTO ENTRADAS SD1
SELECT D1_FILIAL, D1_LOCAL,D1_DOC, D1_NFORI,D2_EMISSAO,B1_COD COD, B1_DESC DESCR, D1_TES TES, D1_CF CF,
SUBSTRING(D1_EMISSAO,7,2)+'/'+SUBSTRING(D1_EMISSAO,5,2)+'/'+SUBSTRING(D1_EMISSAO,1,4) AS EMISSAO,
D1_DTDIGIT,
D1_QUANT QUANT, D1_CUSTO CUSTO, FORMAT(D1_CUSTO / NULLIF(D1_QUANT,0),'#,###.00', 'pt-br') CUSTO_UNIT, F4_TEXTO FROM SD1010 SD1
JOIN SF4010 SF4 ON SF4.D_E_L_E_T_ <> '*' AND SF4.F4_CODIGO = D1_TES
JOIN SB1010 SB1 ON
SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SD1.D1_COD
LEFT JOIN (SELECT DISTINCT D2_FILIAL,D2_DOC, D2_SERIE, D2_EMISSAO FROM SD2010 WHERE D_E_L_E_T_ <> '*') SD2 ON
D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_FILIAL = D1_FILIAL
WHERE SD1.D_E_L_E_T_ <> '*'
AND D1_COD LIKE '%CODIGO%'
--AND F4_TEXTO LIKE '%COMPRA%'
AND D1_EMISSAO BETWEEN '20210201' AND '20210228'
ORDER BY D1_EMISSAO 

--CUSTO SAÍDAS SD2
SELECT D2_FILIAL,D2_LOCAL,D2_DOC,D2_NFORI,D2_LOTECTL,'SD2' AS TABELA, D2_COD, D2_TES, D2_CF, D2_EMISSAO, D2_QUANT, D2_CUSTO1, D2_CUSTO1 / NULLIF(D2_QUANT,0) CUSTO_UNIT, F4_TEXTO FROM SD2010 SD2
JOIN SF4010 SF4 ON SF4.D_E_L_E_T_ <> '*' AND SF4.F4_CODIGO = D2_TES
WHERE SD2.D_E_L_E_T_ <> '*'
AND D2_COD LIKE '%CODIGO%'
--AND F4_TEXTO LIKE '%VENDA%'
AND D2_DOC = 'NF '
ORDER BY D2_EMISSAO DESC
