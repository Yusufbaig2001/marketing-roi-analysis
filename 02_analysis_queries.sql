-- ============================================
-- Marketing Campaign ROI Analysis
-- Analysis Queries
-- ============================================

USE marketing_db;

-- 1. Campaign Performance Overview
-- Key metrics: CPL, CPA, ROAS, ROI %
SELECT campaign_name, platform, spend, leads, conversions, revenue,
       ROUND(spend / NULLIF(leads, 0), 2) AS cost_per_lead,
       ROUND(spend / NULLIF(conversions, 0), 2) AS cost_per_acquisition,
       ROUND(revenue / NULLIF(spend, 0), 2) AS roas,
       ROUND((revenue - spend) * 100.0 / NULLIF(spend, 0), 2) AS roi_pct
FROM campaigns
ORDER BY roi_pct DESC;

-- 2. Platform Performance Summary
SELECT platform,
       COUNT(*) AS total_campaigns,
       SUM(spend) AS total_spend,
       SUM(leads) AS total_leads,
       SUM(conversions) AS total_conversions,
       SUM(revenue) AS total_revenue,
       ROUND(SUM(spend) / SUM(leads), 2) AS avg_cpl,
       ROUND(SUM(revenue) / SUM(spend), 2) AS avg_roas
FROM campaigns
GROUP BY platform
ORDER BY avg_roas DESC;

-- 3. Best & Worst Performing Campaigns
-- Top 3 by ROI
SELECT campaign_name, platform, revenue, spend,
       ROUND((revenue - spend) * 100.0 / spend, 2) AS roi_pct
FROM campaigns
ORDER BY roi_pct DESC
LIMIT 3;

-- 4. Monthly Campaign Performance
SELECT DATE_FORMAT(start_date, '%Y-%m') AS month,
       SUM(spend) AS total_spend,
       SUM(leads) AS total_leads,
       SUM(revenue) AS total_revenue,
       ROUND(SUM(revenue) / SUM(spend), 2) AS monthly_roas
FROM campaigns
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY month;

-- 5. Campaign Efficiency Rating (CASE WHEN)
SELECT campaign_name, platform,
       ROUND(spend / NULLIF(leads, 0), 2) AS cost_per_lead,
       CASE 
           WHEN spend / leads < 100 THEN 'Excellent'
           WHEN spend / leads BETWEEN 100 AND 150 THEN 'Good'
           WHEN spend / leads BETWEEN 150 AND 200 THEN 'Average'
           ELSE 'Poor'
       END AS efficiency_rating
FROM campaigns
ORDER BY cost_per_lead ASC;

-- 6. Rank Campaigns by ROAS (Window Function)
SELECT campaign_name, platform,
       ROUND(revenue / spend, 2) AS roas,
       RANK() OVER (ORDER BY revenue / spend DESC) AS roas_rank
FROM campaigns;

-- 7. Top Campaign per Platform (Window Function + CTE)
WITH ranked AS (
    SELECT campaign_name, platform,
           ROUND(revenue / spend, 2) AS roas,
           RANK() OVER (PARTITION BY platform ORDER BY revenue / spend DESC) AS rnk
    FROM campaigns
)
SELECT platform, campaign_name, roas
FROM ranked
WHERE rnk = 1
ORDER BY roas DESC;

-- 8. Click-Through Rate & Conversion Funnel Analysis
SELECT campaign_name, platform,
       impressions, clicks, leads, conversions,
       ROUND(clicks * 100.0 / impressions, 2) AS ctr_pct,
       ROUND(leads * 100.0 / clicks, 2) AS click_to_lead_pct,
       ROUND(conversions * 100.0 / leads, 2) AS lead_to_conversion_pct
FROM campaigns
ORDER BY ctr_pct DESC;

-- 9. Month-over-Month Revenue Growth
WITH monthly AS (
    SELECT DATE_FORMAT(start_date, '%Y-%m') AS month,
           SUM(revenue) AS revenue
    FROM campaigns
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 
             / LAG(revenue) OVER (ORDER BY month), 2) AS growth_pct
FROM monthly
ORDER BY month;

-- 10. Budget Reallocation Recommendation
SELECT platform,
       SUM(spend) AS current_spend,
       SUM(revenue) AS total_revenue,
       ROUND(SUM(revenue) / SUM(spend), 2) AS roas,
       CASE 
           WHEN SUM(revenue) / SUM(spend) > 10 THEN 'Increase Budget'
           WHEN SUM(revenue) / SUM(spend) >= 5 THEN 'Maintain Budget'
           ELSE 'Reduce Budget'
       END AS recommendation
FROM campaigns
GROUP BY platform
ORDER BY roas DESC;
