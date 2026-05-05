# Olist E-Commerce Analysis
### End-to-End Data Analytics Project | SQL · Python · R · Power BI

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Python](https://img.shields.io/badge/Python-3.10-green)
![Tool](https://img.shields.io/badge/BI-Power%20BI-orange)

---

## Project Overview

This project analyzes E-Commerce data from **Olist**, the largest online marketplace in Brazil.
It covers over **100,000 orders** placed between **2016 and 2018**.

**Objectives:**
- Answer business questions with real-world meaning
- Identify insights that lead to strategic recommendations
- Demonstrate an end-to-end Data Analyst workflow

---

## Dataset

| Detail | Info |
|--------|------|
| **Source** | [Kaggle — Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) |
| **Period** | 2016 – 2018 |
| **Orders** | ~100,000 orders |
| **Tables** | 8 tables |
| **Format** | SQLite (.db) |

### Schema Overview
```
customers --> orders --> order_items --> products
               |                         (+ translation)
               |--> order_payments
               └--> order_reviews
                        sellers --> geolocation
```

---

## Tools & Technologies

| Category | Tools |
|----------|-------|
| **Database** | SQLite, DBeaver |
| **Languages** | SQL, Python, R |
| **Python Libraries** | pandas, numpy, matplotlib, seaborn, scikit-learn |
| **R Libraries** | tidyverse, ggplot2, caret |
| **BI Dashboard** | Power BI |
| **Version Control** | Git, GitHub |

---

## Project Structure

```
olist-ecommerce-analysis/
|
|-- data/
|   |-- olist.db                        <- SQLite database (local only)
|   └-- master_delivered.csv            <- Cleaned master table (Python output)
|
|-- sql/
|   |-- BQ1.sql                         <- Sales Overview
|   |-- BQ2.sql                         <- Customer Analysis
|   |-- BQ3.sql                         <- Product Analysis
|   |-- BQ4.sql                         <- Delivery Analysis
|   |-- BQ5.sql                         <- Seller Performance
|   └-- BQ6.sql                         <- Review & Satisfaction
|
|-- notebooks/
|   |-- 01_EDA.ipynb                    <- Exploratory Data Analysis
|   |-- 02_feature_engineering.ipynb    <- Feature Engineering
|   └-- 03_ml_model.ipynb              <- Machine Learning Model
|
|-- R/
|   └-- 04_statistical_analysis.R       <- Statistical Analysis (Coming Soon)
|
|-- dashboard/
|   └-- olist_dashboard.pbix            <- Power BI Dashboard (Coming Soon)
|
|-- outputs/figures/                    <- Charts & Visualizations
|
└-- README.md
```

---

## Business Questions & Key Findings

### BQ1 — Sales Overview

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ1.1 | What is the total revenue? | Total Revenue: **15,419,773.75 BRL** |
| BQ1.2 | How does monthly revenue trend? | Peaked at **2017-11** (+55%) then declined |
| BQ1.3 | What is the order status breakdown? | Delivered **97%** — high fulfillment rate |
| BQ1.4 | Which payment type is most popular? | Credit card **73.9%**, avg 3.5 installments |

**Insight:** Revenue shows consistent growth. To maintain momentum, promotional campaigns should be distributed more evenly throughout the year rather than relying on seasonal peaks. Encouraging cash-based payment could improve cash flow.

---

### BQ2 — Customer Analysis

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ2.1 | What percentage of customers return? | Repeat customers: only **3.12%** |
| BQ2.2 | Which state has the highest revenue? | **Sao Paulo (SP)** ranks first |
| BQ2.3 | How many days between repeat purchases? | Average **79 days** |
| BQ2.4 | Which state has the highest avg order value? | **Sao Paulo (SP)** |

**Insight:** A repeat rate of 3.12% indicates a retention problem. Promotions or loyalty programs should be introduced to bring customers back. The majority of customers are concentrated in Sao Paulo.

---

### BQ3 — Product Analysis

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ3.1 | Top 10 categories by revenue? | **health_beauty** ranks first |
| BQ3.2 | Which category has the lowest review score? | **office_furniture** avg score 3.49 |
| BQ3.3 | Which category has the highest freight ratio? | **home_comfort_2** freight = 54% of price |
| BQ3.4 | High volume but low review categories? | office_furniture, bed_bath_table, furniture_decor |

**Insight:** Categories with high freight ratios tend to receive lower reviews. home_comfort_2 has a freight ratio of 54%, which reduces perceived value. Adding more distribution points could lower shipping costs and improve purchasing power.

---

### BQ4 — Delivery Analysis

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ4.1 | Avg delivery days and late rate? | Late delivery rate: **7.87%** |
| BQ4.2 | Which state receives orders fastest/slowest? | Fastest: **RJ** / Slowest: **ES** |
| BQ4.3 | Which month had the highest late rate? | **September 2016** at 25% (platform launch period) |
| BQ4.4 | How does late delivery impact review score? | Late: **2.57** vs On-Time: **4.21** |

**Insight:** Late delivery reduces review scores significantly. March 2018 had a late rate of 20%, which warrants further investigation.

---

### BQ5 — Seller Performance

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ5.1 | Top 20 sellers by revenue + satisfaction rank? | Revenue rank does not always equal satisfaction rank |
| BQ5.2 | Do faster sellers receive better reviews? | Faster delivery positively impacts review scores |
| BQ5.3 | Which state has the most sellers and best performance? | **SP** has the most sellers, avg score 4.0 |

**Insight:** Sao Paulo performs best across all dimensions. It should be used as a benchmark model for developing sellers and improving delivery in other regions.

---

### BQ6 — Review & Satisfaction

| ID | Question | Key Finding |
|----|----------|-------------|
| BQ6.1 | What is the review score distribution? | **58%** of customers gave a score of 5 |
| BQ6.2 | What patterns exist in 1-2 star orders? | Late delivery strongly impacts satisfaction scores |

**Insight:** Delivery speed and shipping cost are the main factors affecting customer satisfaction.

---

## Machine Learning Model

**Target Variable:** `is_low_score` — predict whether review score will be <= 2

| Model | Accuracy | Recall | F1 | AUC-ROC |
|-------|----------|--------|----|---------|
| Logistic Regression | 0.811 | 0.500 | 0.416 | 0.730 |
| Random Forest | 0.873 | 0.199 | 0.296 | 0.727 |
| **RF Tuned Params** | **0.812** | **0.512** | **0.424** | **0.733** |

Best Model: Random Forest (Tuned Parameters)
Key Finding: is_late is the most important feature (51.6%), confirming that late delivery is the primary cause of customer dissatisfaction.

---

## Dashboard

> Power BI Dashboard — Coming Soon

<!-- **3 Pages:**
- Page 1: Executive Overview (Revenue, Orders, KPIs)
- Page 2: Product & Seller Analysis
- Page 3: Delivery & Customer Satisfaction -->

---

## Business Recommendations

**1. Prioritize Logistics Investment**
Late delivery reduces customer satisfaction scores by 39%. Pre-stocking inventory in high-demand states based on historical order patterns can reduce lead times and shipping costs. Improving delivery performance will directly increase repeat purchase rates.

**2. Develop a Customer Retention Program**
With only 3.12% repeat customers, the business is missing significant revenue potential. A loyalty program with incentives targeting the 60–79 day window after the first purchase — aligned with the average repeat purchase gap — could effectively drive customers back to the platform.

**3. Diversify Revenue Across Regions**
Revenue is overly concentrated in Sao Paulo. Launching region-specific campaigns and product recommendations tailored to each state's purchasing behavior can reduce geographic risk and unlock growth in underserved markets.

---

## About

**Phongsathorn Witthayapradit**
Data Analyst | 3 Years Insurance Industry Experience

- Datarockie Bootcamp — Batch 12
- Background: Insurance Business Analytics
- Skills: SQL · Python · R · Power BI · Excel

Email: phongsathornwitthayapradit@gmail.com


---

*Dataset: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) · License: CC BY-NC-SA 4.0*
