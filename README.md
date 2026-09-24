# Marketing Campaign ROI Analysis

## 📋 Business Problem

A UPVC manufacturing business was running digital marketing campaigns across Facebook, Instagram, IndiaMART, and Google but had no clear visibility into which platforms delivered the best return on ad spend (ROAS). The business needed to optimize its marketing budget by identifying high-performing campaigns and cutting low-performing ones.

## 🎯 Objectives

- Calculate key marketing metrics: Cost Per Lead (CPL), Cost Per Acquisition (CPA), ROAS, and ROI %.
- Compare performance across platforms (Facebook, Instagram, IndiaMART, Google).
- Identify the top and bottom performing campaigns by ROI.
- Analyze the full conversion funnel: Impressions, Clicks, Leads, Conversions.
- Recommend budget reallocation based on ROAS.
- Track month-over-month revenue growth.

## 🛠️ Tools Used

- MySQL (for data storage and analysis)
- Excel (for reporting)

## 🗄️ Database Schema

Single table - campaigns:
- campaign_id, campaign_name, platform, start_date, end_date
- spend, impressions, clicks, leads, conversions, revenue

## 🔍 Key SQL Techniques Used

- Aggregations: SUM, COUNT, AVG, ROUND
- NULL Handling: NULLIF to prevent division by zero
- Window Functions: RANK, LAG
- CTEs for multi-step analysis
- CASE WHEN for efficiency ratings and budget recommendations
- Date Functions: DATE_FORMAT for monthly grouping

## 📊 Key Business Metrics Calculated

| Metric | Formula | Purpose |
|--------|---------|---------|
| CPL | Spend / Leads | Cost efficiency of lead generation |
| CPA | Spend / Conversions | Cost to acquire a paying customer |
| ROAS | Revenue / Spend | Return on ad spend |
| ROI % | (Revenue - Spend) / Spend * 100 | Overall profitability |
| CTR | Clicks / Impressions * 100 | Ad engagement |
| Lead-to-Conversion % | Conversions / Leads * 100 | Sales team effectiveness |

## 📊 Key Insights

- IndiaMART delivered the highest ROAS, generating strong B2B revenue from bulk orders.
- Instagram had the highest click-through rate but lower conversion to revenue.
- Facebook was the most consistent performer, with balanced CPL and ROAS across campaigns.
- Google Search campaigns generated high lead volume but lower lead quality.
- Budget recommendation: Increase spend on IndiaMART and Facebook; optimize or reduce Google campaigns.

## 📁 Repository Structure

- 01_database_setup.sql - Schema and sample campaign data
- 02_analysis_queries.sql - All 10 analysis queries
- README.md - Project documentation

## 🚀 How to Run

1. Open MySQL Workbench.
2. Run 01_database_setup.sql to create the database and tables.
3. Run 02_analysis_queries.sql to execute all analyses.

## 👤 Author

Yusuf Baig
- LinkedIn: https://www.linkedin.com/in/yusuf-baig-783906210/
- GitHub: https://github.com/Yusufbaig2001
