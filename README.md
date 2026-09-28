# 🏥 Análise de Preços de Compras de Saúde - SUS (2025)

## 📌 Sobre o Projeto

Análise exploratória de dados abertos de compras públicas de saúde efetuadas pelo **Sistema Único de Saúde (SUS)** em 2025, com foco na identificação de variações nos preços de medicamentos entre estados e esferas administrativas.

O projeto busca explorar os dados de compras públicas, identificar padrões, diferenças de preços e possíveis valores atípicos que possam servir como ponto de partida para investigações mais aprofundadas.

## 🛠️ Ferramentas Utilizadas

- **Base de Dados:** Microdados do Banco de Preços em Saúde (BPS / DATASUS) — *acesso em 28/09/2026*
- **SGBD:** SQLite
- **Interface:** DB Browser for SQLite
- **Linguagem de Consulta:** SQL

## 🌐 English Summary

### 🏥 SUS Healthcare Procurement Price Analysis — Brazil (2025)

## 📌 About the Project

Exploratory analysis of open data on healthcare procurement conducted by Brazil's **Unified Health System (SUS)** in 2025, focusing on identifying variations in medication prices across Brazilian states and administrative levels.

The project explores public procurement data to identify patterns, price differences, and potential outliers that may serve as starting points for further investigation.

## 🛠️ Tools & Technologies

- **Data Source:** Microdata from the Health Price Database (Banco de Preços em Saúde — BPS / DATASUS) — *accessed on September 28, 2026*
- **Database:** SQLite
- **Interface:** DB Browser for SQLite
- **Query Language:** SQL

---

# 🇧🇷 Análise

## 1. 🔎 Exploração Inicial dos Dados

A primeira etapa consistiu em analisar a estrutura da base de dados e verificar os registros disponíveis.

```sql
SELECT *
FROM preco_sus
LIMIT 10

```

Também foi realizada uma consulta para identificar os diferentes medicamentos registrados na base:

```sql
SELECT DISTINCT no_pdm
FROM preco_sus
```

Essa etapa permitiu conhecer a estrutura dos dados e identificar os medicamentos disponíveis para análises posteriores.

## 2. 🗂️ Criação da Tabela para Análise

Para facilitar as análises, foi criada uma nova tabela contendo as principais variáveis consideradas relevantes para o projeto:

```sql
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
FROM preco_sus
```

A criação da tabela foi posteriormente confirmada através da consulta:

```sql
SELECT *
FROM preco_sus_filtrado
LIMIT 10
```

## Principais variáveis utilizadas

| Variável            | Descrição                    |
| ------------------- | ---------------------------- |
| `ano_compra`        | Ano da compra                |
| `sg_uf`             | Estado onde ocorreu a compra |
| `ds_esfera`         | Esfera administrativa        |
| `dt_compra`         | Data da compra               |
| `validade_compra`   | Validade do registro         |
| `ds_item`           | Descrição do item adquirido  |
| `no_grupo`          | Grupo do produto             |
| `no_classe`         | Classe do produto            |
| `qt_medicamento`    | Quantidade adquirida         |
| `no_municipio`      | Município da compra          |
| `no_pdm`            | Denominação do produto       |
| `vl_preco_unitario` | Preço unitário               |
| `vl_preco_total`    | Valor total da compra        |

## 3. 💊 Análise de Preços da Dipirona Sódica

Como primeira análise de preços, foi selecionada a Dipirona Sódica.

O objetivo foi verificar se existiam diferenças nos preços médios registrados entre os estados brasileiros.

```sql
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
ORDER BY preco_medio_unitario DESC
```

## 📊 Resultado

A consulta apresentou diferenças relevantes entre os preços registrados nos estados.

| Estado | Preço médio | Preço mínimo | Preço máximo | Qtd. compras |
| ------ | ----------: | -----------: | -----------: | -----------: |
| CE     |    R$ 14,00 |      R$ 0,47 |     R$ 95,40 |           11 |
| PI     |     R$ 2,84 |      R$ 0,30 |      R$ 7,15 |            9 |
| PB     |     R$ 1,37 |      R$ 0,11 |     R$ 16,60 |           42 |
| PA     |     R$ 1,23 |      R$ 0,03 |      R$ 2,48 |            6 |
| AL     |     R$ 1,14 |      R$ 0,02 |      R$ 3,23 |           20 |
| PR     |     R$ 1,13 |      R$ 0,10 |     R$ 21,38 |           35 |
| MG     |     R$ 0,89 |      R$ 0,10 |      R$ 2,18 |           15 |
| SE     |     R$ 0,85 |      R$ 0,09 |      R$ 6,07 |           17 |
| RS     |     R$ 0,82 |      R$ 0,10 |      R$ 6,92 |           38 |
| RJ     |     R$ 0,75 |      R$ 0,12 |      R$ 1,24 |            6 |
| RO     |     R$ 0,70 |      R$ 0,10 |      R$ 3,05 |           36 |
| SP     |     R$ 0,61 |      R$ 0,09 |      R$ 1,67 |           28 |
| GO     |     R$ 0,57 |      R$ 0,10 |      R$ 1,12 |            3 |
| PE     |     R$ 0,56 |      R$ 0,13 |      R$ 1,49 |            8 |
| ES     |     R$ 0,51 |      R$ 0,10 |      R$ 1,09 |            7 |
| MS     |     R$ 0,47 |      R$ 0,11 |      R$ 1,30 |            6 |
| BA     |     R$ 0,30 |      R$ 0,10 |      R$ 0,50 |            2 |


## 📌 Primeiro Achado

Foi identificada uma diferença considerável entre os preços médios registrados para Dipirona Sódica entre os estados.

O Ceará apresentou o maior preço médio na consulta, com R$ 14,00, enquanto a Bahia apresentou média de R$ 0,30.

Entretanto, essa diferença não significa necessariamente que o mesmo produto esteja sendo adquirido por preços tão diferentes.

Uma possível explicação é que os registros classificados como Dipirona Sódica podem representar diferentes apresentações, formas farmacêuticas, concentrações ou unidades de fornecimento.

Por isso, essa primeira comparação deve ser considerada uma análise exploratória, e não uma conclusão sobre diferenças reais de preço entre os estados.

## 4. ⚠️ Investigação de Valores Atípicos

A diferença observada no Ceará levou a uma investigação mais detalhada dos registros de Dipirona Sódica.

Foram selecionados registros dos estados do Ceará (CE), Bahia (BA) e São Paulo (SP):

```sql
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
    CAST(REPLACE(vl_preco_unitario, ',', '.') AS FLOAT) DESC

```

## 🔍 Observações

A investigação encontrou registros com diferenças muito grandes nos preços unitários.

Um dos registros do Ceará apresenta:

Preço unitário: R$ 95,40
Quantidade adquirida: 1 unidade

Em comparação, foram encontrados registros em São Paulo com preços inferiores a R$ 1,00 e quantidades adquiridas muito maiores.

Um dos registros analisados em São Paulo apresenta quantidade de aproximadamente:

46.875.687 unidades

Essa diferença chamou atenção porque combina duas características bastante distintas:

preço unitário muito elevado;
quantidade adquirida extremamente pequena.

## 🧩 Hipótese sobre os Registros do Ceará

Os resultados levantaram a hipótese de que alguns registros do Ceará possam apresentar inconsistências de preenchimento ou características diferentes de apresentação do medicamento.

Entretanto, os dados analisados até o momento não permitem afirmar que o registro de R$ 95,40 seja um erro de preenchimento.

Antes de chegar a essa conclusão, é necessário verificar informações adicionais, principalmente a descrição completa do item (ds_item) e as características da apresentação do medicamento.

Também é possível que diferentes unidades de fornecimento estejam sendo comparadas.

Portanto, neste momento, o resultado é tratado como um ponto de investigação, e não como uma evidência definitiva de erro ou sobrepreço.

## 6. 📉 Limitações da Análise

A análise inicial apresenta algumas limitações que precisam ser consideradas na interpretação dos resultados.

Diferentes apresentações

O filtro por no_pdm pode reunir diferentes apresentações ou formas de comercialização do mesmo princípio ativo.

Valores extremos

Valores muito altos ou muito baixos podem influenciar significativamente o preço médio.

Quantidade de observações

Alguns estados possuem poucas compras registradas.

Por exemplo:

Bahia: 2 compras;
Goiás: 3 compras;
Pará: 6 compras;
Espírito Santo: 7 compras.

Portanto, médias calculadas a partir de poucas observações devem ser interpretadas com cautela.

Comparabilidade dos preços

Para uma comparação mais precisa, é necessário garantir que os registros analisados possuam características equivalentes, como:

apresentação;
concentração;
forma farmacêutica;
unidade de fornecimento;
quantidade adquirida.

## 7. 🚀 Próximas Etapas

A partir dos resultados encontrados, as próximas etapas da análise serão:

 Investigar detalhadamente os registros de Dipirona Sódica;
 Analisar ds_item para identificar diferentes apresentações;
 Verificar concentrações e unidades de fornecimento;
 Identificar e analisar valores atípicos;
 Comparar produtos com características equivalentes;
 Calcular mediana e quartis dos preços;
 Analisar a distribuição dos preços;
 Investigar a relação entre quantidade adquirida e preço unitário;
 Comparar preços por município;
 Comparar preços por esfera administrativa;
 Expandir a análise para outros medicamentos;
 Criar visualizações dos resultados.


## 8. 📌 Conclusão Inicial

A análise exploratória identificou variações significativas nos preços registrados para Dipirona Sódica entre diferentes estados brasileiros.

O caso do Ceará chamou atenção devido à presença de valores elevados, incluindo um registro de R$ 95,40 para uma quantidade de 1 unidade.

Entretanto, os resultados também mostram que uma comparação simples dos preços médios pode não ser suficiente, pois os registros podem representar diferentes apresentações, unidades ou características dos medicamentos.

Dessa forma, o principal resultado desta primeira etapa não é afirmar que determinado estado possui preços maiores ou menores, mas identificar padrões e registros que merecem investigação adicional.

A próxima etapa será aprofundar a análise das características dos produtos e controlar as diferenças de apresentação antes de realizar comparações mais precisas entre os estados.

## 📚 Fonte dos Dados

Banco de Preços em Saúde (BPS) — Ministério da Saúde / DATASUS
Acesso em: 28/09/2026

## 👤 Autor

Projeto desenvolvido como estudo de SQL e análise exploratória de dados públicos, utilizando dados de compras de saúde do SUS.




