CREATE DATABASE IF NOT EXISTS  rbi_inflation_db;
USE rbi_inflation_db;

-- 1. To Create the WPI Table
CREATE TABLE IF NOT EXISTS wpi_data (
    Ref_Date DATE PRIMARY KEY,
    Month_Str VARCHAR(10),
    WPI_Inflation DECIMAL(5,2)
);

-- 2. To Create the CPI Table
CREATE TABLE IF NOT EXISTS cpi_data (
    Ref_Date DATE,
    Month_Str VARCHAR(10),
    Commodity_Description VARCHAR(100),
    Provisional_Final VARCHAR(15),
    Rural_Index DECIMAL(5,1),
    Rural_Inflation DECIMAL(5,2),
    Urban_Index DECIMAL(5,1),
    Urban_Inflation DECIMAL(5,2),
    Combined_Index DECIMAL(5,1),
    Combined_Inflation DECIMAL(5,2),
    PRIMARY KEY (Ref_Date, Commodity_Description)
);

-- Creating the Master View
SELECT 
    c.Ref_Date,
    c.Month_Str AS Month,
    w.WPI_Inflation AS Headline_WPI_Inflation,
    c.Combined_Inflation AS Headline_CPI_Inflation,
    c.Combined_Index AS CPI_Index
FROM cpi_data c
INNER JOIN wpi_data w ON c.Ref_Date = w.Ref_Date
WHERE c.Commodity_Description = 'A) General Index'
ORDER BY c.Ref_Date ASC;

-- Time-Series Lagging
CREATE VIEW view_inflation_master AS
SELECT 
    c.Ref_Date,
    c.Month_Str AS Month,
    w.WPI_Inflation AS WPI_Inflation_Current,
    -- Creates a 1-month lag for WPI
    LAG(w.WPI_Inflation, 1) OVER (ORDER BY c.Ref_Date) AS WPI_Inflation_Lag1,
    -- Creates a 2-month lag for WPI
    LAG(w.WPI_Inflation, 2) OVER (ORDER BY c.Ref_Date) AS WPI_Inflation_Lag2,
    c.Combined_Inflation AS CPI_Inflation_Current
FROM cpi_data c
INNER JOIN wpi_data w ON c.Ref_Date = w.Ref_Date
WHERE c.Commodity_Description = 'A) General Index'
ORDER BY c.Ref_Date ASC;

SELECT *
FROM view_inflation_master;