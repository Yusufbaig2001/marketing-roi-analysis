# Marketing Campaign ROI Analysis

SQL and Power BI analysis of 10 digital marketing campaigns across Facebook, Instagram, IndiaMART and Google. The project calculates CPL, CPA, ROAS and ROI, compares platforms, and turns the results into budget recommendations.

**Headline finding:** IndiaMART delivered the best return (ROAS 17.85) at the lowest cost per lead (₹120), while the three weakest campaigns (Spring Discount, Retargeting, Premium Doors Ad) each cost over ₹150 per lead.

> **Data note:** the dataset is a small sample (10 campaigns, ₹221K spend) modelled on campaigns I ran at a UPVC manufacturer. Figures are illustrative, and the very high ROAS and ROI values are a feature of the sample data, not real results.

## 📊 Power BI Dashboard

![Executive Overview](powerbi_dashboard/page1_campaigns.png)

A 3-page interactive dashboard built on this dataset:

- **Executive Overview**: KPIs, ROAS by platform, campaign performance
- **Platform Deep Dive**: platform comparison, conversion funnel, monthly trends
- **Campaign Efficiency**: performance categories, budget recommendations

**Built with:** Power BI Desktop, DAX, Power Query · 📂 [Full dashboard documentation →](powerbi_dashboard/README.md)

---

## 📋 Business Problem

A UPVC manufacturer was running digital campaigns on Facebook, Instagram, IndiaMART and Google but had no clear view of which platforms gave the best return on ad spend. The business needed to find its best campaigns and cut the weakest.

## 🎯 Objectives

- Calculate Cost Per Lead (CPL), Cost Per Acquisition (CPA), ROAS and ROI %
- Compare performance across platforms
- Identify the best and worst campaigns
- Analyse the funnel: impressions, clicks, leads, conversions
- Recommend budget changes based on ROAS
- Track month-over-month revenue

## 🛠️ Tools Used

- **MySQL**: data storage and 10 analysis queries
- **Power BI**, **DAX** and **Power Query**: interactive dashboard

## 🗄️ Database Schema

Single table `campaigns`: campaign_id, campaign_name, platform, start_date, end_date, spend, impressions, clicks, leads, conversions, revenue

## 🔍 Key SQL Techniques Used

- Aggregations: SUM, COUNT, AVG, ROUND
- NULL handling: NULLIF to prevent division by zero
- Window functions: RANK, LAG
- CTEs for multi-step analysis
- CASE WHEN for efficiency ratings and budget recommendations
- Date functions: DATE_FORMAT for monthly grouping

## 📐 Metrics Calculated

| Metric | Formula | Purpose |
| --- | --- | --- |
| CPL | Spend / Leads | Cost efficiency of lead generation |
| CPA | Spend / Conversions | Cost to acquire a paying customer |
| ROAS | Revenue / Spend | Return on ad spend |
| ROI % | (Revenue - Spend) / Spend × 100 | Overall profitability |
| CTR | Clicks / Impressions × 100 | Ad engagement |
| Lead-to-Conversion % | Conversions / Leads × 100 | Sales team effectiveness |

## 📊 Results by Platform

| Platform | Spend | Leads | Conversions | Revenue | ROAS | CPL |
| --- | --- | --- | --- | --- | --- | --- |
| IndiaMART | ₹65,000 | 540 | 193 | ₹1,160,000 | 17.85 | ₹120.4 |
| Google | ₹36,000 | 250 | 97 | ₹485,000 | 13.47 | ₹144.0 |
| Facebook | ₹61,000 | 425 | 175 | ₹805,000 | 13.20 | ₹143.5 |
| Instagram | ₹59,000 | 410 | 165 | ₹760,000 | 12.88 | ₹143.9 |
| **Total** | **₹221,000** | **1,625** | **630** | **₹3.21M** | **14.52** | |

## 🔍 Key Insights

- **IndiaMART** earned 36% of revenue from 29% of spend, with the best ROAS (17.85) and the lowest CPL (₹120)
- **Dealer Network Ads** (IndiaMART) has the highest campaign ROAS (18.29)
- **Facebook, Instagram and Google** have almost the same CPL (₹143–144), so ROAS separates them: Google 13.47, Facebook 13.20, Instagram 12.88
- **Facebook** converts the most leads (41% of leads convert, vs 36% for IndiaMART), but IndiaMART earns more revenue per conversion
- **7 of 10 campaigns** are "Good" (CPL ₹100–150) and **3 are "Poor"** (CPL over ₹150): Premium Doors Ad, Retargeting Campaign and Spring Discount
- **Spring Discount** (Facebook) is the worst campaign, with ROAS 8.06 and CPL ₹189

## 💡 Budget Recommendations

Rule used in DAX: ROAS above 15 = increase, 10 to 15 = maintain, below 10 = reduce.

- **Increase** IndiaMART budget (ROAS 17.85)
- **Maintain** Google, Facebook and Instagram
- **Pause or optimise** the three Poor campaigns, starting with Spring Discount

## 📁 Repository Structure

```
marketing-roi-analysis/
├── 01_database_setup.sql     # Schema and sample campaign data
├── 02_analysis_queries.sql   # All 10 analysis queries
├── powerbi_dashboard/        # Dashboard screenshots and documentation
└── README.md
```

## 🚀 How to Run

1. Open MySQL Workbench.
2. Run `01_database_setup.sql` to create the database and table.
3. Run `02_analysis_queries.sql` to execute the analysis.

## 👤 Author

**Yusuf Baig**, Data Analyst | Open to roles in Dubai, UAE

- LinkedIn: [yusuf-baig-783906210](https://www.linkedin.com/in/yusuf-baig-783906210/)
- GitHub: [@Yusufbaig2001](https://github.com/Yusufbaig2001)
