-- =====================================================
-- 01. EXPLORAÇÃO INICIAL
-- =====================================================

SELECT *
FROM preco_sus
LIMIT 10;


-- =====================================================
-- 02. MEDICAMENTOS DISPONÍVEIS
-- =====================================================

SELECT DISTINCT no_pdm
FROM preco_sus;


-- =====================================================
-- 03. CRIAÇÃO DA TABELA PARA ANÁLISE
-- =====================================================

CREATE TABLE preco_sus_filtrado AS
SELECT
    ano_compra,
    sg_uf,
    ds_esfera,
    dt_compra,
    validade_compra,
    ds_item,
    no_grupo,
    no_classe,
    qt_medicamento,
    no_municipio,
    no_pdm,
    vl_preco_unitario,
    vl_preco_total
FROM preco_sus;


-- =====================================================
-- 04. ANÁLISE DA DIPIRONA SÓDICA
-- =====================================================

SELECT
    no_pdm,
    sg_uf,
    ROUND(
        AVG(CAST(REPLACE(vl_preco_unitario, ',', '.') AS FLOAT)),
        2
    ) AS preco_medio_unitario,
    ROUND(
        MIN(CAST(REPLACE(vl_preco_unitario, ',', '.') AS FLOAT)),
        2
    ) AS preco_minimo,
    ROUND(
        MAX(CAST(REPLACE(vl_preco_unitario, ',', '.') AS FLOAT)),
        2
    ) AS preco_maximo,
    COUNT(*) AS qtd_compras
FROM preco_sus_filtrado
WHERE LOWER(no_pdm) LIKE '%dipirona%'
GROUP BY no_pdm, sg_uf
ORDER BY preco_medio_unitario DESC;


-- =====================================================
-- 05. INVESTIGAÇÃO DOS VALORES ATÍPICOS
-- =====================================================

SELECT
    sg_uf,
    ds_item,
    vl_preco_unitario,
    qt_medicamento
FROM preco_sus_filtrado
WHERE no_pdm LIKE '%DIPIRONA SÓDICA%'
  AND sg_uf IN ('CE', 'BA', 'SP')
ORDER BY
    sg_uf,
    CAST(REPLACE(vl_preco_unitario, ',', '.') AS FLOAT) DESC;