CREATE TABLE population (
    region varchar(100),
    country_code int,
    years int,
    populations NUMERIC(20,10)
);

SELECT
    years,
    ROUND(populations * 1000, 2) AS population_actual
FROM population
WHERE region = 'India'
ORDER BY years;

SELECT 
    region,
    ROUND(populations * 1000, 2) AS population_actual
FROM population
WHERE years = 2014
  AND region IN (
    'Brunei Darussalam', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia',
    'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam'
  );

SELECT 
    years,
    region,
    ROUND(populations * 1000, 2) AS population_actual
FROM population
WHERE region IN (
    'Afghanistan', 'Bangladesh', 'Bhutan', 'India', 
    'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'
)
ORDER BY years;


SELECT 
    years,
    region,
    ROUND(populations * 1000, 2) AS population_actual
FROM population
WHERE region IN (
    'Brunei Darussalam', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia',
    'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam'
)
  AND years BETWEEN 2004 AND 2014
ORDER BY years, region;
