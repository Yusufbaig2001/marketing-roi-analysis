-- =========================================================
-- MARKETING CAMPAIGN PERFORMANCE ANALYSIS
-- Database: marketing_db
-- =========================================================

USE marketing_db;


-- =========================================================
-- 1. DATASET OVERVIEW AND BASIC VALIDATION
-- Check the number of campaigns, date range and totals.
-- =========================================================

SELECT
    COUNT(*) AS total_campaigns,
    MIN(start_date) AS first_campaign_start,
    MAX(end_date) AS last_campaign_end,
    SUM(spend) AS total_ad_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(leads) AS total_leads,
    SUM(conversions) AS total_conversions,
    SUM(revenue) AS total_revenue
FROM campaigns;


-- =========================================================
-- 2. CHECK FOR DUPLICATE CAMPAIGN IDs
-- =========================================================

SELECT
    campaign_id,
    COUNT(*) AS duplicate_count
FROM campaigns
GROUP BY campaign_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 3. CHECK FOR MISSING VALUES
-- =========================================================

SELECT
    SUM(campaign_name IS NULL) AS missing_campaign_names,
    SUM(platform IS NULL) AS missing_platforms,
    SUM(start_date IS NULL) AS missing_start_dates,
    SUM(end_date IS NULL) AS missing_end_dates,
    SUM(spend IS NULL) AS missing_spend,
    SUM(impressions IS NULL) AS missing_impressions,
    SUM(clicks IS NULL) AS missing_clicks,
    SUM(leads IS NULL) AS missing_leads,
    SUM(conversions IS NULL) AS missing_conversions,
    SUM(revenue IS NULL) AS missing_revenue
FROM campaigns;


-- =========================================================
-- 4. CAMPAIGN PERFORMANCE OVERVIEW
-- CPL = Spend / Leads
-- CPA = Spend / Conversions
-- ROAS = Revenue / Ad Spend
-- Revenue less ad spend % is not net profit ROI.
-- =========================================================

SELECT
    campaign_id,
    campaign_name,
    platform,
    spend,
    leads,
    conversions,
    revenue,
    ROUND(spend / NULLIF(leads, 0), 2) AS cost_per_lead,
    ROUND(spend / NULLIF(conversions, 0), 2) AS cost_per_acquisition,
    ROUND(revenue / NULLIF(spend, 0), 2) AS roas,
    ROUND(
        (revenue - spend) * 100.0 / NULLIF(spend, 0),
        2
    ) AS revenue_less_ad_spend_pct
FROM campaigns
ORDER BY roas DESC;


-- =========================================================
-- 5. PLATFORM PERFORMANCE SUMMARY
-- CPL is weighted: total spend / total leads.
-- =========================================================

SELECT
    platform,
    COUNT(*) AS total_campaigns,
    SUM(spend) AS total_spend,
    SUM(leads) AS total_leads,
    SUM(conversions) AS total_conversions,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(spend) / NULLIF(SUM(leads), 0), 2) AS weighted_cpl,
    ROUND(SUM(spend) / NULLIF(SUM(conversions), 0), 2) AS weighted_cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(spend), 0), 2) AS roas
FROM campaigns
GROUP BY platform
ORDER BY roas DESC;


-- =========================================================
-- 6. TOP 3 AND BOTTOM 3 CAMPAIGNS BY ROAS
-- =========================================================

SELECT
    campaign_name,
    platform,
    spend,
    revenue,
    ROUND(revenue / NULLIF(spend, 0), 2) AS roas
FROM campaigns
ORDER BY roas DESC
LIMIT 3;

SELECT
    campaign_name,
    platform,
    spend,
    revenue,
    ROUND(revenue / NULLIF(spend, 0), 2) AS roas
FROM campaigns
ORDER BY roas ASC
LIMIT 3;


-- =========================================================
-- 7. CAMPAIGN EFFICIENCY CLASSIFICATION
-- Thresholds are illustrative business rules.
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(spend / NULLIF(leads, 0), 2) AS cost_per_lead,
    CASE
        WHEN leads = 0 OR leads IS NULL THEN 'Not Available'
        WHEN spend / leads < 100 THEN 'Excellent'
        WHEN spend / leads <= 150 THEN 'Good'
        WHEN spend / leads <= 200 THEN 'Average'
        ELSE 'Poor'
    END AS efficiency_rating
FROM campaigns
ORDER BY cost_per_lead ASC;


-- =========================================================
-- 8. RANK CAMPAIGNS BY ROAS
-- Window Function: RANK()
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(revenue / NULLIF(spend, 0), 2) AS roas,
    RANK() OVER (
        ORDER BY revenue / NULLIF(spend, 0) DESC
    ) AS roas_rank
FROM campaigns;


-- =========================================================
-- 9. BEST CAMPAIGN ON EACH PLATFORM
-- CTE + RANK() window function.
-- =========================================================

WITH ranked_campaigns AS (
    SELECT
        campaign_name,
        platform,
        ROUND(revenue / NULLIF(spend, 0), 2) AS roas,
        RANK() OVER (
            PARTITION BY platform
            ORDER BY revenue / NULLIF(spend, 0) DESC
        ) AS platform_rank
    FROM campaigns
)
SELECT
    platform,
    campaign_name,
    roas
FROM ranked_campaigns
WHERE platform_rank = 1
ORDER BY roas DESC;


-- =========================================================
-- 10. MARKETING CONVERSION FUNNEL
-- CTR = Clicks / Impressions
-- Click-to-lead = Leads / Clicks
-- Lead-to-conversion = Conversions / Leads
-- =========================================================

SELECT
    campaign_name,
    platform,
    impressions,
    clicks,
    leads,
    conversions,
    ROUND(clicks * 100.0 / NULLIF(impressions, 0), 2) AS ctr_pct,
    ROUND(leads * 100.0 / NULLIF(clicks, 0), 2) AS click_to_lead_pct,
    ROUND(conversions * 100.0 / NULLIF(leads, 0), 2) AS lead_to_conversion_pct
FROM campaigns
ORDER BY ctr_pct DESC;


-- =========================================================
-- 11. CAMPAIGN START-MONTH SUMMARY
-- Important: campaigns are grouped by start_date.
-- This is NOT actual monthly revenue recognition.
-- =========================================================

SELECT
    DATE_FORMAT(start_date, '%Y-%m') AS campaign_start_month,
    COUNT(*) AS campaigns_started,
    SUM(spend) AS total_campaign_spend,
    SUM(leads) AS total_leads,
    SUM(conversions) AS total_conversions,
    SUM(revenue) AS associated_campaign_revenue,
    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0),
        2
    ) AS roas
FROM campaigns
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY campaign_start_month;


-- =========================================================
-- 12. REVENUE BY CAMPAIGN START MONTH
-- LAG() compares one campaign-start-month cohort
-- with the previous available cohort.
-- =========================================================

WITH monthly_campaigns AS (
    SELECT
        DATE_FORMAT(start_date, '%Y-%m') AS campaign_start_month,
        SUM(revenue) AS associated_revenue
    FROM campaigns
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
),
monthly_comparison AS (
    SELECT
        campaign_start_month,
        associated_revenue,
        LAG(associated_revenue) OVER (
            ORDER BY campaign_start_month
        ) AS previous_cohort_revenue
    FROM monthly_campaigns
)
SELECT
    campaign_start_month,
    associated_revenue,
    previous_cohort_revenue,
    ROUND(
        (associated_revenue - previous_cohort_revenue) * 100.0
        / NULLIF(previous_cohort_revenue, 0),
        2
    ) AS change_vs_previous_cohort_pct
FROM monthly_comparison
ORDER BY campaign_start_month;


-- =========================================================
-- 13. CAMPAIGN REVENUE CONTRIBUTION
-- Identify each campaign's share of total revenue.
-- =========================================================

SELECT
    campaign_name,
    platform,
    revenue,
    ROUND(
        revenue * 100.0 / NULLIF(
            (SELECT SUM(revenue) FROM campaigns),
            0
        ),
        2
    ) AS revenue_contribution_pct
FROM campaigns
ORDER BY revenue_contribution_pct DESC;


-- =========================================================
-- 14. CAMPAIGN DURATION AND DAILY AD SPEND
-- Daily spend is an average across the campaign period.
-- =========================================================

SELECT
    campaign_name,
    platform,
    start_date,
    end_date,
    DATEDIFF(end_date, start_date) + 1 AS campaign_duration_days,
    spend,
    ROUND(
        spend / NULLIF(DATEDIFF(end_date, start_date) + 1, 0),
        2
    ) AS average_daily_spend
FROM campaigns
ORDER BY average_daily_spend DESC;


-- =========================================================
-- 15. PLATFORM BUDGET RECOMMENDATIONS
-- Illustrative ROAS thresholds:
-- Above 15 = Increase
-- 10 to 15 = Maintain
-- Below 10 = Review / Reduce
-- Validate business margins before reallocating budgets.
-- =========================================================

SELECT
    platform,
    SUM(spend) AS current_spend,
    SUM(revenue) AS total_revenue,
    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0),
        2
    ) AS roas,
    CASE
        WHEN SUM(spend) = 0 THEN 'Insufficient Data'
        WHEN SUM(revenue) / SUM(spend) > 15 THEN 'Increase Budget'
        WHEN SUM(revenue) / SUM(spend) >= 10 THEN 'Maintain Budget'
        ELSE 'Review / Reduce Budget'
    END AS budget_recommendation
FROM campaigns
GROUP BY platform
ORDER BY roas DESC;


-- =========================================================
-- 16. OVERALL MARKETING PERFORMANCE SUMMARY
-- Revenue less ad spend is before product costs and
-- other operating expenses. It is not net profit.
-- =========================================================

SELECT
    SUM(spend) AS total_ad_spend,
    SUM(revenue) AS total_revenue,
    SUM(leads) AS total_leads,
    SUM(conversions) AS total_conversions,
    ROUND(
        SUM(spend) / NULLIF(SUM(leads), 0),
        2
    ) AS overall_cpl,
    ROUND(
        SUM(spend) / NULLIF(SUM(conversions), 0),
        2
    ) AS overall_cpa,
    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0),
        2
    ) AS overall_roas,
    ROUND(
        (SUM(revenue) - SUM(spend)) * 100.0
        / NULLIF(SUM(spend), 0),
        2
    ) AS revenue_less_ad_spend_pct
FROM campaigns;
```
