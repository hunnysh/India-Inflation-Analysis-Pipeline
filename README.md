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
```

### 2. Econometric Modeling & Statistical Diagnostics (Python)
To evaluate the pass-through speed of supply shocks, two competing Ordinary Least Squares (OLS) models were constructed using the `statsmodels` architecture:

* **Model 1 (Contemporary Baseline):** $$CPI_t = \alpha + \beta_1(WPI_t) + u_t$$
* **Model 2 (Lagged Transmission):** $$CPI_t = \alpha + \beta_1 (WPI_{t-1}) + \beta_2 (WPI_{t-2}) + u_t$$

#### Model Performance Comparison:
* **Model 1:** Regular $R^2 = 0.72$ | **Adjusted $R^2 = 0.66$** (Winning Model)
* **Model 2:** Regular $R^2 = 0.72$ | **Adjusted $R^2 = 0.58$**

#### Econometric Takeaway:
While the raw $R^2$ remained unchanged, the **Adjusted $R^2$ collapsed significantly** when lags were introduced. Because Adjusted $R^2$ mathematically penalizes the inclusion of non-predictive variables, this drop proves that wholesale price shocks transmit to retail consumer pockets almost instantaneously in India, rather than facing a prolonged multi-month delay.

#### Testing Gauss-Markov Assumptions:
To validate the structural integrity of the linear regression model, prediction errors were isolated ($\hat{u}_t = Y_t - \hat{Y}_t$) and mapped against fitted values to run a residual variance check.

![Residual Diagnostic Plot](python/inflation_residuals_1(winner).png)

*Diagnostic Analysis:* The error coordinates generate a uniform, random scatter clustering tightly above and below the zero-error axis line. The absence of a systematic funneling shape mathematically confirms **Homoscedasticity** (constant error variance), validating that the model parameters are Best Linear Unbiased Estimators (BLUE).

### 3. Business Intelligence Architecture (Power BI Dashboard)
To transform these econometric insights into a functional corporate decision tool, an interactive pricing canvas was built:

* **Relational Modeling:** Established a `1:*` (One-to-Many) backend entity relationship connecting the single monthly tracking coordinates of `wpi_data` to the detailed basket coordinates of `cleaned_cpi_data`, forcing bidirectional cross-filtering.
* **Visual Layer Isolation:** The primary time-series line chart is locked via visual-level filtration to the headline `A) General Index` to chart clean macro trends. 
* **Dynamic Slicing Capabilities:** By utilizing the **Edit Interactions** control panel, the drop-down commodity slicer was unlinked from the main line chart (keeping the macro anchor stable) and mapped directly to a **Clustered Bar Chart**. This allows supply-chain managers to slice deep into individual consumption layers (e.g., separating Cereals vs. Vegetables when "Food and beverages" is selected).



## 📊 Key Findings & Strategic Takeaways
1. **The Pass-Through Matrix:** The contemporary model's strong performance indicates that retail inflation in India is heavily driven by immediate cost-push supply shocks ($v_t$) passed along the corporate supply-chain pipeline, rather than demand-pull overheating.
2. **Monetary Policy Constraints:** Because input cost shocks transfer to the consumer instantly, traditional demand-side monetary tightening (like raising repo rates) can be highly counterproductive. If the Reserve Bank of India (RBI) aggressively suppresses demand to fight what is fundamentally a WPI supply disruption, it risks breaking corporate margins, causing businesses to contract hiring. This directly threatens a structural transition into **Stagflation** rather than maintaining a balanced short-run Phillips Curve trade-off.

---
## 📂 How to Run Locally
1. **Database:** Execute scripts inside `sql/` to populate your MySQL instance.
2. **Analytics:** Ensure dependencies are met (`pip install pandas statsmodels matplotlib seaborn`) and run `python/regression_analysis.py`.
3. **Visualization:** Open `dashboard/Inflation-Employment Trade-off.pbix` using Power BI Desktop.
