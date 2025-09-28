# Credit Risk Analysis (SQL) — Kaggle UCI Dataset

This project analyzes the **UCI Default of Credit Card Clients dataset** (30,000+ clients) using **MySQL (via DBeaver)** to evaluate repayment behavior, default exposure, and portfolio risk.

## Project Overview
- Queried and analyzed a dataset of 30K+ credit card clients to study repayment patterns and default risk.  
- Built portfolio risk metrics including default rate (22.1%), average credit limit (~167,000), and demographic distributions.  
- Designed financial ratios (debt-to-income, credit utilization, late payment history) with `NULLIF` handling.  
- Developed a rule-based risk segmentation framework classifying clients into Safe, Medium, or At Risk categories.  
- Created a SQL-driven credit scoring system with nested `CASE` statements and subqueries to rank borrowers into Low / Medium / High Risk tiers.  
- Ranked the top 10 high-exposure clients for portfolio insights.  

## Skills & Tools
- **SQL**: aggregations, `CASE` logic, conditional aggregation, subqueries, ranking queries, ratio analysis  
- **DBeaver**: database IDE for query execution and analysis  
- **Financial Analytics**: debt-to-income, utilization, repayment history, credit scoring logic  

## Files in this Repository
- `credit_risk_analysis.sql` → SQL scripts used for analysis  
- `report.md` (optional) → extended summary of key findings & screenshots  
- `README.md` → project documentation  

## Key Insights
- **Default Rate**: 22.1% of clients  
- **Average Credit Limit**: ~167,000  
- **Risk Segmentation**: clear behavioral differences by utilization and repayment history  
- **Credit Scoring**: SQL framework classified clients into Low, Medium, and High risk categories  

## Dataset
Source: [UCI Default of Credit Card Clients Dataset (Kaggle)](https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset?resource=download)  

## License
Copyright (c) 2025 Myra Rohit Sachdeva  
All rights reserved.  

This repository is made publicly viewable for portfolio purposes only.  
No part of this code may be copied, modified, or distributed without explicit permission  
from the author.

