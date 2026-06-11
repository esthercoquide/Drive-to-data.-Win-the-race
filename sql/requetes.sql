-- ====================================================================
-- PROJET : Analyse de données avec BigQuery et Looker
-- DESCRIPTION : Requêtes de nettoyage et de préparation des données
-- ====================================================================

WITH
  podium_info AS (
    SELECT
      year,
      circuit_name,
      driver_name,
      IF(positionOrder = 1, 1, 0) AS victory,
      CASE WHEN positionOrder <= 3 THEN 1 ELSE 0 END AS podium
    FROM `f1-project-498108.2_Intermediate.drivers_info`
  ),
  podium_sum AS (
    SELECT
    year,
    driver_name,
    SUM(victory) AS total_victory,
    SUM(podium) AS total_podium
    FROM podium_info
    GROUP BY year, driver_name
  ),
concat_podium AS (
  SELECT
  CONCAT(year,"&",driver_name) AS concat,
  *,
  FROM podium_sum
),
concat_ranking AS (SELECT
  CONCAT(year,"&",driver_name) AS concat,
  *,
  FROM `f1-project-498108.Intermediaire_perso.driver_ranking_per_year`)

SELECT
concat_ranking.year,
concat_ranking.driver_name,
total_point,
rank,
Title,
total_victory,
total_podium
FROM concat_ranking
LEFT JOIN concat_podium
USING (concat)
ORDER BY year ASC, total_point DESC


-- DESCRIPTION : Création table intermédiaire "drivers_info" avec les informations des pilotes, des courses et des résultats
-- ====================================================================

CREATE OR REPLACE TABLE `f1-project-498108.2_Intermediate.drivers_info` AS SELECT results.resultId,
results.raceId,
races.year,
races.circuitId,
circuit.location AS circuit_name,
results.driverId,
CONCAT(drivers.forename, ' ', drivers.surname) AS driver_name,
drivers.nationality AS nationality,
results.constructorId,
constructors.name AS constructor_name,
results.grid,
results.positionOrder,
results.points,
results.fastestLapTime,
results.statusId,
status.status
FROM `f1-project-498108.1_Source.results` AS results
LEFT JOIN `f1-project-498108.1_Source.races` AS races
USING (raceId)
LEFT JOIN `f1-project-498108.1_Source.circuits` AS circuit
USING (circuitId)
LEFT JOIN `f1-project-498108.1_Source.drivers` AS drivers
USING (driverId)
LEFT JOIN `f1-project-498108.1_Source.constructors` AS constructors
USING (constructorId)
LEFT JOIN `f1-project-498108.1_Source.status` AS status
USING (statusId)
WHERE races.year >= 2006
  AND races.year <= 2024
ORDER BY year ASC

-- DESCRIPTION : table driver_performance prêtes pour looker
-- ====================================================================
WITH finish_rate AS (
  SELECT
  CONCAT(year,"&",driver_name) AS concat,
  year,
  driver_name,
  races,
  finished_races,
  finish_rate
  FROM `Intermediaire_perso.finish_rate`
)
SELECT
drivers.*,
finish.finished_races,
finish.finish_rate
FROM `f1-project-498108.Intermediaire_perso.drivers_total` AS drivers
LEFT JOIN finish_rate AS finish
USING(concat)
