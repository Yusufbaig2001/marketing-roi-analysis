-- ============================================
-- Marketing Campaign ROI Analysis
-- Database Setup
-- ============================================

CREATE DATABASE IF NOT EXISTS marketing_db;
USE marketing_db;

-- Campaigns table
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    platform VARCHAR(30),
    start_date DATE,
    end_date DATE,
    spend DECIMAL(10,2),
    impressions INT,
    clicks INT,
    leads INT,
    conversions INT,
    revenue DECIMAL(10,2)
);

-- Insert sample data (realistic digital marketing figures)
INSERT INTO campaigns VALUES
(1, 'Summer Window Sale',      'Facebook',  '2024-01-05', '2024-01-31', 15000, 250000, 8500, 120, 45, 180000),
(2, 'Door Collection Launch',  'Instagram', '2024-01-15', '2024-02-15', 22000, 320000, 11000, 180, 72, 340000),
(3, 'B2B Bulk Orders',         'IndiaMART', '2024-02-01', '2024-02-29', 30000, 150000, 4500, 250, 88, 520000),
(4, 'Spring Discount',         'Facebook',  '2024-03-01', '2024-03-31', 18000, 280000, 9200, 95, 38, 145000),
(5, 'Premium Doors Ad',        'Instagram', '2024-03-10', '2024-04-10', 25000, 380000, 12500, 160, 65, 310000),
(6, 'Local Search Boost',      'Google',    '2024-04-01', '2024-04-30', 20000, 420000, 15000, 140, 55, 275000),
(7, 'Festival Season Promo',   'Facebook',  '2024-05-01', '2024-05-31', 28000, 450000, 16000, 210, 92, 480000),
(8, 'Dealer Network Ads',      'IndiaMART', '2024-05-15', '2024-06-15', 35000, 180000, 5200, 290, 105, 640000),
(9, 'Retargeting Campaign',    'Instagram', '2024-06-01', '2024-06-30', 12000, 200000, 7800, 70, 28, 110000),
(10, 'Monsoon Windows Ad',     'Google',    '2024-07-01', '2024-07-31', 16000, 350000, 12000, 110, 42, 210000);
