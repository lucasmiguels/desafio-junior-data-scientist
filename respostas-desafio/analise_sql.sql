-- Q1) Quantos chamados foram abertos no dia 01/04/2023?

SELECT COUNT(id_chamado) FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
-- 1903 chamados

-- Q2) Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023?
SELECT tipo, COUNT(id_chamado) as qtd FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
GROUP BY tipo
ORDER BY qtd desc
LIMIT 1
-- Estacionamento irregular -> 373 chamados

-- Q3) Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
SELECT 
  b.nome AS bairro, COUNT(*) AS chamados
FROM `datario.adm_central_atendimento_1746.chamado` AS c
JOIN `datario.dados_mestres.bairro` AS b
ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
AND b.nome IS NOT NULL
GROUP BY bairro
ORDER BY chamados DESC
LIMIT 3;

-- Campo Grande, Tijuca e Barra da Tijuca
-- RESPOSTA EM JSON:
-- [{
--   "bairro": "Campo Grande",
--   "chamados": "124"
-- }, {
--   "bairro": "Tijuca",
--   "chamados": "96"
-- }, {
--   "bairro": "Barra da Tijuca",
--   "chamados": "60"
-- }]

-- Q4) Qual o nome da subprefeitura com mais chamados abertos nesse dia?
SELECT 
  b.subprefeitura, COUNT(*) AS chamados
FROM `datario.adm_central_atendimento_1746.chamado` AS c
JOIN `datario.dados_mestres.bairro` AS b
ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
GROUP BY subprefeitura
ORDER BY chamados DESC
LIMIT 1;
-- Zona Norte -> 534 chamados

-- Q5) Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
SELECT COUNT(id_chamado) AS chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
AND id_bairro IS NULL
-- Sim, existem 131 chamados. Caso o id_bairro (identificador) não seja preenchido na ocorrência do chamado, não é possível identificar o bairro ou subprefeitura associado.

-- Q6) Quantos chamados de Perturbação do sossego foram abertos nesse período?
SELECT COUNT(*) as chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE id_subtipo = '5071'
AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'
-- 56785 chamados

-- Q7) Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).

-- Percebi que a tabela de eventos estava incompleta, faltando os campos data_inicial e data_final para o Rock in Rio 24 e o Reveillion 24.
-- Portanto, utilizei uma CTE para incluir esses dados na análise.
WITH eventos_completos AS (
  SELECT 
    data_inicial,
    data_final,
    evento
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL AND data_final IS NOT NULL

  UNION ALL

  -- Rock in Rio 2024
  SELECT 
    DATE('2024-09-13'),
    DATE('2024-09-15'),
    'Rock in Rio'

  UNION ALL

  -- Rock in Rio 2024 - 2º fim de semana
  SELECT 
    DATE('2024-09-19'),
    DATE('2024-09-22'),
    'Rock in Rio'

  UNION ALL

  -- Réveillon 2024-2025
  SELECT 
    DATE('2024-12-29') AS data_inicial,
    DATE('2025-01-01') AS data_final,
    'Réveillon' AS evento
)

SELECT 
    c.id_chamado,
    c.data_inicio AS data_chamado,
    e.evento
FROM `datario.adm_central_atendimento_1746.chamado` AS c
JOIN eventos_completos AS e
    ON DATE(c.data_inicio) BETWEEN e.data_inicial AND e.data_final
WHERE c.id_subtipo = "5071"
  AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'


-- Q8) Quantos chamados desse subtipo foram abertos em cada evento?
WITH eventos_completos AS (
  SELECT 
    data_inicial,
    data_final,
    evento
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL AND data_final IS NOT NULL

  UNION ALL

  -- Rock in Rio 2024
  SELECT 
    DATE('2024-09-13'),
    DATE('2024-09-15'),
    'Rock in Rio'

  UNION ALL

  -- Rock in Rio 2024 - 2º fim de semana
  SELECT 
    DATE('2024-09-19'),
    DATE('2024-09-22'),
    'Rock in Rio'

  UNION ALL

  -- Réveillon 2024-2025
  SELECT 
    DATE('2024-12-29') AS data_inicial,
    DATE('2025-01-01') AS data_final,
    'Réveillon' AS evento
)

SELECT 
  e.evento,
  COUNT(c.id_chamado) AS chamados
FROM `datario.adm_central_atendimento_1746.chamado` AS c
JOIN eventos_completos AS e
  ON DATE(c.data_inicio) BETWEEN e.data_inicial AND e.data_final
WHERE c.id_subtipo = "5071"
  AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'
GROUP BY e.evento
ORDER BY chamados DESC;

--RESPOSTA JSON:
-- [{
--   "evento": "Rock in Rio",
--   "chamados": "946"
-- }, {
--   "evento": "Réveillon",
--   "chamados": "280"
-- }, {
--   "evento": "Carnaval",
--   "chamados": "252"
-- }]

-- Q9) Qual evento teve a maior média diária de chamados abertos desse subtipo?
WITH eventos_completos AS (
  SELECT 
    data_inicial,
    data_final,
    evento
  FROM `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  WHERE data_inicial IS NOT NULL AND data_final IS NOT NULL

  UNION ALL

  -- Rock in Rio 2024
  SELECT 
    DATE('2024-09-13'),
    DATE('2024-09-15'),
    'Rock in Rio'

  UNION ALL

  -- Rock in Rio 2024 - 2º fim de semana
  SELECT 
    DATE('2024-09-19'),
    DATE('2024-09-22'),
    'Rock in Rio'

  UNION ALL

  -- Réveillon 2024-2025
  SELECT 
    DATE('2024-12-29') AS data_inicial,
    DATE('2025-01-01') AS data_final,
    'Réveillon' AS evento
)

, chamados_por_periodo AS (
  SELECT 
    e.evento,
    COUNT(c.id_chamado) AS total_chamados,
    DATE_DIFF(e.data_final, e.data_inicial, DAY) + 1 AS duracao_dias
  FROM `datario.adm_central_atendimento_1746.chamado` AS c
  JOIN eventos_completos AS e
    ON DATE(c.data_inicio) BETWEEN e.data_inicial AND e.data_final
  WHERE c.id_subtipo = "5071"
    AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2024-12-31'
  GROUP BY e.evento, e.data_inicial, e.data_final
)

SELECT 
  evento,
  SUM(total_chamados) AS total_chamados,
  SUM(duracao_dias) AS duracao_dias,
  ROUND(SUM(total_chamados) / SUM(duracao_dias), 2) AS media_diaria
FROM chamados_por_periodo
GROUP BY evento
ORDER BY media_diaria DESC
LIMIT 1;

-- RESPOSTA JSON
-- [{
--   "evento": "Rock in Rio",
--   "total_chamados": "946",
--   "duracao_dias": "7",
--   "media_diaria": "135.14"
-- }]

-- Q10) Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2024.

-- A query usada para Q9) calcula a media diaria para todos os eventos se removermos a linha LIMIT 1. Segue o resultado em json:

-- [{
--   "evento": "Rock in Rio",
--   "total_chamados": "946",
--   "duracao_dias": "7",
--   "media_diaria": "135.14"
-- }, {
--   "evento": "Carnaval",
--   "total_chamados": "252",
--   "duracao_dias": "4",
--   "media_diaria": "63.0"
-- }, {
--   "evento": "Réveillon",
--   "total_chamados": "280",
--   "duracao_dias": "7",
--   "media_diaria": "40.0"
-- }]

-- A query abaixo pode ser usada para obter a media diária durante todo o período. 

SELECT
  COUNT(*) AS chamados,
  DATE_DIFF(DATE('2024-12-31'), DATE('2022-01-01'), DAY) + 1 AS total_dias,
  ROUND(COUNT(*) / (DATE_DIFF(DATE('2024-12-31'), DATE('2022-01-01'), DAY) + 1), 2) AS media_diaria
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE id_subtipo = "5071"
  AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2024-12-31';

-- RESPOSTA
-- [{
--   "chamados": "56785",
--   "total_dias": "1096",
--   "media_diaria": "51.81"
-- }]

-- Os dados reforçam que eventos estão associados a aumentos nos chamados por perturbação, especialmente o Rock in Rio, mais do que eventos populares tradicionais.
-- Curiosamente, o Réveillon tem menos chamados por dia que a média geral. O que pode estar ligado a uma tolerância social maior ao barulho nesta data específica.
-- É um evento que pode ser explorado para pensar em ações de mitigação nos outros eventos.
