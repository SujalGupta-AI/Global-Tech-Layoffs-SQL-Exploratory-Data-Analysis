# Global Tech Layoffs: SQL Exploratory Data Analysis

![Top 10 Companies with Most Layoffs](Exploratory%20Data%20Analysis.png)

## Executive Summary
This project provides a comprehensive exploratory data analysis (EDA) of the global technology sector layoffs occurring between 2020 and 2023. By applying advanced SQL querying techniques to a dataset of over 2,000 layoff events, the analysis uncovers critical trends regarding which companies, industries, and countries were most impacted. The investigation transitions from simple aggregations to complex window functions to identify peak layoff periods, chronological rolling totals, and the top-ranking companies by layoff volume within specific years. The findings offer a data-driven perspective on the recent economic contraction within the tech industry.

## Business Problem
The recent wave of layoffs in the technology sector has created significant uncertainty for employees, investors, and policymakers. Stakeholders lack a centralized, transparent analysis to understand the true scale, distribution, and velocity of these job losses. A purely descriptive overview is insufficient. The business problem is to transform raw observational data into actionable intelligence that answers critical questions: Which massive tech giants are responsible for the largest volume of layoffs? Are specific industries (e.g., Retail, Consumer) disproportionately affected compared to others? How has the rate of layoffs accelerated over time? This project aims to provide this clarity through rigorous data interrogation.

## Methodology
The analysis was conducted entirely within a MySQL environment using a single dataset named `layoffs_staging2`. The methodological approach followed these steps:

1.  **Baseline Exploration:** Established the boundaries of the data, including the date range (2020-03-11 to 2023-03-06), maximum layoffs in a single event (12,000), and identifying companies that were completely shuttered (100% layoffs).
2.  **Multidimensional Aggregation:** Performed group-by operations to aggregate total layoffs across four primary dimensions: Company, Industry, Country, and Year.
3.  **Temporal Trend Analysis (Rolling Totals):** Utilized Common Table Expressions (CTEs) and SQL Window Functions (`SUM() OVER()`) to calculate the chronological rolling total of layoffs separated by month. This visualized the velocity of job losses over the three-year period.
4.  **Rank-Based Segmentation:** Applied advanced window functions (`DENSE_RANK()`) within CTEs to segment and rank companies by their total layoffs *per year*. The final query filtered these results to identify the top 5 companies contributing to layoffs for each calendar year, providing a clear view of which organizations led the contraction annually.

## Skills
* **Database Management:** MySQL
* **Data Analysis:** Exploratory Data Analysis (EDA), Descriptive Statistics, Trend Analysis
* **Advanced SQL Techniques:**
    * Joins and Aggregations (`GROUP BY`, `SUM`, `MAX`, `COUNT`)
    * Date/Time Manipulation (`YEAR()`, `SUBSTRING()`)
    * Filtering and Ordering (`WHERE`, `HAVING`, `ORDER BY`)
    * Common Table Expressions (CTEs)
    * Window Functions (`DENSE_RANK()`, `SUM() OVER()`, `PARTITION BY`)

## Results & Business Recommendation

### Key Analytical Results
* **Peak Layoffs:** The dataset spans exactly three years. The single largest layoff event involved 12,000 employees. Many startups experienced 100% staff reduction, indicating total closure.
* **Chronological Acceleration:** The rolling total analysis reveals a dramatic acceleration in layoffs starting in late 2022 and peaking in early 2023, contrasting sharply with the relatively lower volumes seen in 2020 and 2021.
* **Company Impact (Overall):** As visualized in the chart, large-scale tech conglomerates led the job losses. **Amazon** recorded the highest total layoffs (approx. 27k-28k), followed by **Google**, **Meta**, **Salesforce**, and **Microsoft**. These top 5 companies alone account for a massive percentage of the total dataset volume.
* **Yearly Leaders:** The segmentation analysis shows a shift in the "leaders" of layoffs each year. While some companies consistently appeared, new organizations joined the top ranks in 2023, reflecting the widening impact of the economic downturn.

### Business Recommendations
1.  **Market Sentiment Monitoring:** Financial analysts and investors should utilize the yearly top-rank analysis as a lagging indicator of corporate performance and market sentiment. The acceleration caught by the rolling total query serves as a strong signal of broader economic shifts.
2.  **Workforce & Competitor Intelligence:** Companies still in a growth phase should analyze the specific industries (e.g., Retail, Consumer, Transportation) experiencing the highest layoff volumes. This analysis identifies sectors where skilled labor may be readily available due to these separations.
3.  **Policy & Support Targeting:** Government agencies and outplacement services can use the geographic and industry breakdowns to target support resources (retraining programs, unemployment assistance) to the regions and sectors most heavily impacted by the displacement.

## Next Step
* **Data Integration:** Integrate this dataset with global economic indicators (e.g., interest rates, inflation markers) or tech stock indices (e.g., NASDAQ) to perform regression analysis and identify potential leading correlation markers for future layoff waves.
* **Visualization Enhancement:** Transition the tabular SQL results (specifically the rolling totals and yearly rankings) into dynamic, interactive dashboards using Power BI or Tableau to allow stakeholders to filter by industry or location in real-time.
* **Predictive Modeling:** Leverage the temporal trends identified in the EDA to build predictive models that forecast potential layoff volumes in the upcoming quarters based on historical seasonality and current market accelerations.
