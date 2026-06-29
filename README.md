# Evaluating Cost-Push Supply Shocks & The Inflation-Employment Trade-off in India
An end-to-end macroeconomic data pipeline utilizing SQL window functions, Python econometrics, and interactive Power BI architectures to analyze 13 years of RBI data.

## 📊 Executive Summary & Economic Framework
This project investigates the transmission mechanism of cost-push supply shocks ($v_t$) through India's supply chain and assesses its implications on the short-run expectations-augmented Phillips Curve:
$$\pi_t = \pi_t^e - \beta(u_t - u_n) + v_t$$

By evaluating the relationship between the Wholesale Price Index (WPI) and the Consumer Price Index (CPI) from 2013 to 2025, this analysis proves that wholesale cost shocks pass through to retail consumer pockets almost instantaneously, presenting a distinct stagflationary constraint for central bank monetary policy.

## 🛠️ Technical Stack & Architecture
* **Data Source:** Reserve Bank of India (RBI) Database on Indian Economy (DBIE).
* **Database Layer:** MySQL (Schema optimization, multi-table joins, and time-series lagging via `LAG()` window functions).
* **Analytics Layer:** Python (`pandas`, `statsmodels`, `matplotlib`, `seaborn`) utilizing Ordinary Least Squares (OLS) Linear Regression.
* **Business Intelligence Layer:** Power BI Desktop (Dynamic DAX expressions, cross-table modeling, and interactive visual slicing).

## 🚀 Key Project Milestones

### 1. Database Engineering (SQL)
Designed a relational schema to handle separate time-series frequencies. Developed a master view leveraging window functions to isolate the headline aggregate index and simulate transmission lags across months:
```sql
-- Creating 1 and 2-month wholesale inflation lags
LAG(w.WPI_Inflation, 1) OVER (ORDER BY c.Ref_Date) AS WPI_Inflation_Lag1
