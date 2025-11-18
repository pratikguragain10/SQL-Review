CREATE TABLE companies (
    CIN VARCHAR(21),
    CompanyName VARCHAR(255),
    CompanyROCcode VARCHAR(50),
    CompanyCategory VARCHAR(100),
    CompanySubCategory VARCHAR(100),
    CompanyClass VARCHAR(50),
    AuthorizedCapital NUMERIC(15,2),
    PaidupCapital NUMERIC(15,2),
    CompanyRegistrationdate_date DATE,
    Registered_Office_Address TEXT,
    Listingstatus VARCHAR(50),
    CompanyStatus VARCHAR(50),
    CompanyStateCode VARCHAR(50),
    CompanyIndian/Foreign Company VARCHAR(50),
    nic_code VARCHAR(10),
    CompanyIndustrialClassification VARCHAR(255)
);

SELECT cap_range, COUNT(*) AS total_companies
FROM (
    SELECT
        CASE
            WHEN AuthorizedCapital <= 100000 THEN '<= 1L'
            WHEN AuthorizedCapital <= 1000000 THEN '1L to 10L'
            WHEN AuthorizedCapital <= 10000000 THEN '10L to 1Cr'
            WHEN AuthorizedCapital <= 100000000 THEN '1Cr to 10Cr'
            ELSE '> 10Cr'
        END AS cap_range
    FROM companies
) AS t
GROUP BY cap_range
ORDER BY
    CASE
        WHEN cap_range = '<= 1L' THEN 1
        WHEN cap_range = '1L to 10L' THEN 2
        WHEN cap_range = '10L to 1Cr' THEN 3
        WHEN cap_range = '1Cr to 10Cr' THEN 4
        ELSE 5
    END;


SELECT
    EXTRACT(YEAR FROM CompanyRegistrationdate_date) AS reg_year,
    COUNT(*) AS total_registrations
FROM companies
GROUP BY reg_year
ORDER BY reg_year;

CREATE TABLE ZIPCODE (
    zipcode int,
    district varchar(100)
);

ALTER TABLE companies ADD COLUMN extracted_zip INT;

UPDATE companies
SET extracted_zip = (
    regexp_match(Registered_Office_Address, '([0-9]{6})$')
)[1]::INT;

DROP TABLE IF EXISTS companies_2015;

CREATE TEMP TABLE companies_2015 AS
SELECT *
FROM companies
WHERE EXTRACT(YEAR FROM CompanyRegistrationdate_date) = 2015;

SELECT
    district,
    COUNT(*) AS registration_count
FROM company_districts
GROUP BY district
ORDER BY registration_count DESC;

WITH last10 AS (
    SELECT
        EXTRACT(YEAR FROM CompanyRegistrationdate_date)::int AS reg_year,
        CompanyIndustrialClassification AS pba
    FROM companies
    WHERE CompanyRegistrationdate_date >= (CURRENT_DATE - INTERVAL '10 years')
),
top5 AS (
    SELECT pba
    FROM last10
    GROUP BY pba
    ORDER BY COUNT(*) DESC
    LIMIT 5
)
SELECT
    reg_year AS year,
    pba,
    COUNT(*) AS registrations
FROM last10
WHERE pba IN (SELECT pba FROM top5)
GROUP BY reg_year, pba
ORDER BY reg_year, pba;
