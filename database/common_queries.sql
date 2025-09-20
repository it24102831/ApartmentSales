-- =====================================================
-- Common SQL Queries for ApartmentSales System
-- Business Intelligence and Reporting Queries
-- =====================================================

USE apartment_sales;

-- =====================================================
-- 1. PROPERTY SEARCH AND LISTING QUERIES
-- =====================================================

-- Find available apartments within price range
SELECT 
    a.apartment_id,
    a.unit_number,
    bc.complex_name,
    CONCAT(l.city, ', ', l.state_province) as location,
    pt.type_name,
    a.square_footage,
    a.current_price,
    a.furnishing_status,
    a.listing_date
FROM apartments a
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN locations l ON bc.location_id = l.location_id
JOIN property_types pt ON a.type_id = pt.type_id
WHERE a.status = 'available'
  AND a.current_price BETWEEN 500000 AND 1000000
ORDER BY a.current_price ASC;

-- Search apartments by location and features
SELECT DISTINCT
    a.apartment_id,
    a.unit_number,
    bc.complex_name,
    l.city,
    a.current_price,
    GROUP_CONCAT(f.feature_name SEPARATOR ', ') as features
FROM apartments a
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN locations l ON bc.location_id = l.location_id
JOIN apartment_features af ON a.apartment_id = af.apartment_id
JOIN features f ON af.feature_id = f.feature_id
WHERE a.status = 'available'
  AND l.city = 'Los Angeles'
  AND f.feature_name IN ('Hardwood Flooring', 'Balcony', 'In-unit Laundry')
GROUP BY a.apartment_id, a.unit_number, bc.complex_name, l.city, a.current_price
HAVING COUNT(DISTINCT f.feature_name) >= 2
ORDER BY a.current_price;

-- Find apartments by bedroom count and budget
SELECT 
    a.apartment_id,
    bc.complex_name,
    a.unit_number,
    pt.bedrooms,
    pt.bathrooms,
    a.square_footage,
    a.current_price,
    ROUND(a.current_price / a.square_footage, 2) as price_per_sqft
FROM apartments a
JOIN property_types pt ON a.type_id = pt.type_id
JOIN building_complexes bc ON a.complex_id = bc.complex_id
WHERE a.status = 'available'
  AND pt.bedrooms = 2
  AND a.current_price <= 1200000
ORDER BY price_per_sqft ASC;

-- =====================================================
-- 2. SALES PERFORMANCE AND ANALYTICS
-- =====================================================

-- Monthly sales report
SELECT 
    DATE_FORMAT(s.sale_date, '%Y-%m') as sale_month,
    COUNT(*) as total_sales,
    SUM(s.sale_price) as total_revenue,
    AVG(s.sale_price) as avg_sale_price,
    SUM(s.commission_amount) as total_commission
FROM sales s
WHERE s.sale_status = 'completed'
  AND s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m')
ORDER BY sale_month DESC;

-- Top performing agents
SELECT 
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) as agent_name,
    COUNT(s.sale_id) as total_sales,
    SUM(s.sale_price) as total_sales_value,
    SUM(s.commission_amount) as total_commission,
    AVG(s.sale_price) as avg_sale_price,
    MAX(s.sale_date) as last_sale_date
FROM agents a
LEFT JOIN sales s ON a.agent_id = s.agent_id AND s.sale_status = 'completed'
WHERE a.status = 'active'
GROUP BY a.agent_id, a.first_name, a.last_name
ORDER BY total_sales_value DESC
LIMIT 10;

-- Sales by property type
SELECT 
    pt.type_name,
    COUNT(s.sale_id) as units_sold,
    SUM(s.sale_price) as total_revenue,
    AVG(s.sale_price) as avg_price,
    MIN(s.sale_price) as min_price,
    MAX(s.sale_price) as max_price
FROM sales s
JOIN apartments a ON s.apartment_id = a.apartment_id
JOIN property_types pt ON a.type_id = pt.type_id
WHERE s.sale_status = 'completed'
  AND s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY pt.type_name
ORDER BY total_revenue DESC;

-- Sales by location/city
SELECT 
    l.city,
    l.state_province,
    COUNT(s.sale_id) as units_sold,
    SUM(s.sale_price) as total_revenue,
    AVG(s.sale_price) as avg_price
FROM sales s
JOIN apartments a ON s.apartment_id = a.apartment_id
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN locations l ON bc.location_id = l.location_id
WHERE s.sale_status = 'completed'
GROUP BY l.city, l.state_province
ORDER BY total_revenue DESC;

-- =====================================================
-- 3. CUSTOMER ANALYTICS
-- =====================================================

-- Customer engagement analysis
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email,
    COUNT(DISTINCT i.inquiry_id) as total_inquiries,
    COUNT(DISTINCT v.viewing_id) as total_viewings,
    COUNT(DISTINCT s.sale_id) as total_purchases,
    DATEDIFF(CURDATE(), c.registration_date) as days_since_registration,
    CASE 
        WHEN COUNT(DISTINCT s.sale_id) > 0 THEN 'Converted'
        WHEN COUNT(DISTINCT v.viewing_id) > 0 THEN 'Active Viewer'
        WHEN COUNT(DISTINCT i.inquiry_id) > 0 THEN 'Inquired'
        ELSE 'Registered Only'
    END as customer_status
FROM customers c
LEFT JOIN inquiries i ON c.customer_id = i.customer_id
LEFT JOIN viewings v ON c.customer_id = v.customer_id
LEFT JOIN sales s ON c.customer_id = s.customer_id AND s.sale_status = 'completed'
WHERE c.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.registration_date
ORDER BY total_purchases DESC, total_viewings DESC;

-- Customer budget vs purchase analysis
SELECT 
    CASE 
        WHEN c.budget_max IS NULL THEN 'No Budget Set'
        WHEN s.sale_price <= c.budget_max THEN 'Within Budget'
        WHEN s.sale_price > c.budget_max THEN 'Over Budget'
    END as budget_category,
    COUNT(*) as customer_count,
    AVG(s.sale_price) as avg_purchase_price,
    AVG(c.budget_max) as avg_budget_max
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_status = 'completed'
GROUP BY budget_category;

-- Lead conversion funnel
SELECT 
    'Total Customers' as stage,
    COUNT(*) as count,
    100.0 as percentage
FROM customers
WHERE status = 'active'

UNION ALL

SELECT 
    'Made Inquiries' as stage,
    COUNT(DISTINCT c.customer_id) as count,
    ROUND(COUNT(DISTINCT c.customer_id) * 100.0 / (SELECT COUNT(*) FROM customers WHERE status = 'active'), 2) as percentage
FROM customers c
JOIN inquiries i ON c.customer_id = i.customer_id
WHERE c.status = 'active'

UNION ALL

SELECT 
    'Scheduled Viewings' as stage,
    COUNT(DISTINCT c.customer_id) as count,
    ROUND(COUNT(DISTINCT c.customer_id) * 100.0 / (SELECT COUNT(*) FROM customers WHERE status = 'active'), 2) as percentage
FROM customers c
JOIN viewings v ON c.customer_id = v.customer_id
WHERE c.status = 'active'

UNION ALL

SELECT 
    'Made Purchases' as stage,
    COUNT(DISTINCT c.customer_id) as count,
    ROUND(COUNT(DISTINCT c.customer_id) * 100.0 / (SELECT COUNT(*) FROM customers WHERE status = 'active'), 2) as percentage
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE c.status = 'active' AND s.sale_status = 'completed';

-- =====================================================
-- 4. INVENTORY MANAGEMENT
-- =====================================================

-- Current inventory status
SELECT 
    a.status,
    COUNT(*) as unit_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM apartments), 2) as percentage,
    AVG(a.current_price) as avg_price,
    SUM(a.current_price) as total_inventory_value
FROM apartments a
GROUP BY a.status
ORDER BY unit_count DESC;

-- Inventory by building complex
SELECT 
    bc.complex_name,
    l.city,
    COUNT(*) as total_units,
    SUM(CASE WHEN a.status = 'available' THEN 1 ELSE 0 END) as available_units,
    SUM(CASE WHEN a.status = 'sold' THEN 1 ELSE 0 END) as sold_units,
    SUM(CASE WHEN a.status = 'under_offer' THEN 1 ELSE 0 END) as under_offer_units,
    ROUND(SUM(CASE WHEN a.status = 'sold' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as occupancy_rate,
    AVG(CASE WHEN a.status = 'available' THEN a.current_price END) as avg_available_price
FROM building_complexes bc
JOIN locations l ON bc.location_id = l.location_id
JOIN apartments a ON bc.complex_id = a.complex_id
GROUP BY bc.complex_id, bc.complex_name, l.city
ORDER BY occupancy_rate DESC;

-- Days on market analysis
SELECT 
    CASE 
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 30 THEN '0-30 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 60 THEN '31-60 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 90 THEN '61-90 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 180 THEN '91-180 days'
        ELSE '180+ days'
    END as days_on_market,
    COUNT(*) as unit_count,
    AVG(a.current_price) as avg_price
FROM apartments a
WHERE a.status = 'available'
GROUP BY 
    CASE 
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 30 THEN '0-30 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 60 THEN '31-60 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 90 THEN '61-90 days'
        WHEN DATEDIFF(CURDATE(), a.listing_date) <= 180 THEN '91-180 days'
        ELSE '180+ days'
    END
ORDER BY 
    CASE days_on_market
        WHEN '0-30 days' THEN 1
        WHEN '31-60 days' THEN 2
        WHEN '61-90 days' THEN 3
        WHEN '91-180 days' THEN 4
        WHEN '180+ days' THEN 5
    END;

-- =====================================================
-- 5. FINANCIAL REPORTING
-- =====================================================

-- Payment status report
SELECT 
    ps.payment_status,
    COUNT(*) as payment_count,
    SUM(ps.amount) as total_amount,
    COUNT(CASE WHEN ps.due_date < CURDATE() AND ps.payment_status = 'pending' THEN 1 END) as overdue_count,
    SUM(CASE WHEN ps.due_date < CURDATE() AND ps.payment_status = 'pending' THEN ps.amount ELSE 0 END) as overdue_amount
FROM payment_schedule ps
GROUP BY ps.payment_status;

-- Commission analysis by agent
SELECT 
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) as agent_name,
    a.commission_rate,
    COUNT(s.sale_id) as completed_sales,
    SUM(s.sale_price) as total_sales_value,
    SUM(s.commission_amount) as total_commission_earned,
    AVG(s.commission_amount) as avg_commission_per_sale
FROM agents a
LEFT JOIN sales s ON a.agent_id = s.agent_id AND s.sale_status = 'completed'
WHERE a.status = 'active'
GROUP BY a.agent_id, a.first_name, a.last_name, a.commission_rate
ORDER BY total_commission_earned DESC;

-- Pending transactions requiring attention
SELECT 
    s.sale_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    bc.complex_name,
    a.unit_number,
    s.sale_price,
    s.sale_status,
    s.contract_date,
    s.closing_date,
    DATEDIFF(s.closing_date, CURDATE()) as days_to_closing,
    ag.first_name as agent_first_name,
    ag.last_name as agent_last_name
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN apartments a ON s.apartment_id = a.apartment_id
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN agents ag ON s.agent_id = ag.agent_id
WHERE s.sale_status IN ('pending', 'under_offer')
ORDER BY s.closing_date ASC;

-- =====================================================
-- 6. OPERATIONAL QUERIES
-- =====================================================

-- Upcoming viewings schedule
SELECT 
    v.viewing_id,
    v.scheduled_datetime,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.phone as customer_phone,
    bc.complex_name,
    a.unit_number,
    CONCAT(ag.first_name, ' ', ag.last_name) as agent_name,
    ag.phone as agent_phone,
    v.viewing_status
FROM viewings v
JOIN customers c ON v.customer_id = c.customer_id
JOIN apartments a ON v.apartment_id = a.apartment_id
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN agents ag ON v.agent_id = ag.agent_id
WHERE v.scheduled_datetime >= CURDATE()
  AND v.viewing_status = 'scheduled'
ORDER BY v.scheduled_datetime ASC;

-- Follow-up inquiries requiring attention
SELECT 
    i.inquiry_id,
    i.inquiry_type,
    i.follow_up_date,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email,
    c.phone,
    CONCAT(ag.first_name, ' ', ag.last_name) as assigned_agent,
    i.status,
    DATEDIFF(CURDATE(), i.follow_up_date) as days_overdue
FROM inquiries i
JOIN customers c ON i.customer_id = c.customer_id
LEFT JOIN agents ag ON i.agent_id = ag.agent_id
WHERE i.follow_up_date <= CURDATE()
  AND i.status IN ('new', 'in_progress')
ORDER BY i.follow_up_date ASC;

-- Property maintenance and status updates needed
SELECT 
    bc.complex_name,
    bc.status as complex_status,
    COUNT(*) as total_apartments,
    SUM(CASE WHEN a.status = 'available' THEN 1 ELSE 0 END) as available_units,
    bc.construction_year,
    YEAR(CURDATE()) - bc.construction_year as building_age,
    bc.amenities
FROM building_complexes bc
JOIN apartments a ON bc.complex_id = a.complex_id
WHERE bc.status IN ('under_construction', 'renovation')
   OR (YEAR(CURDATE()) - bc.construction_year) > 10
GROUP BY bc.complex_id, bc.complex_name, bc.status, bc.construction_year, bc.amenities
ORDER BY building_age DESC;