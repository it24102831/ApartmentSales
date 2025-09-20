-- =====================================================
-- Database Setup and Test Script
-- Run this to create and populate the ApartmentSales database
-- =====================================================

-- Note: This script assumes you have MySQL/MariaDB running
-- Modify connection parameters as needed for your environment

-- Step 1: Create the database schema
SOURCE schema.sql;

-- Step 2: Populate with sample data
SOURCE sample_data.sql;

-- Step 3: Test basic functionality
-- =====================================================
-- Basic validation queries
-- =====================================================

-- Verify table creation
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'apartment_sales'
ORDER BY TABLE_NAME;

-- Verify sample data insertion
SELECT 'Locations' as table_name, COUNT(*) as record_count FROM locations
UNION ALL
SELECT 'Building Complexes', COUNT(*) FROM building_complexes
UNION ALL  
SELECT 'Property Types', COUNT(*) FROM property_types
UNION ALL
SELECT 'Apartments', COUNT(*) FROM apartments
UNION ALL
SELECT 'Features', COUNT(*) FROM features
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Agents', COUNT(*) FROM agents
UNION ALL
SELECT 'Sales', COUNT(*) FROM sales
UNION ALL
SELECT 'Payment Schedule', COUNT(*) FROM payment_schedule
UNION ALL
SELECT 'Inquiries', COUNT(*) FROM inquiries
UNION ALL
SELECT 'Viewings', COUNT(*) FROM viewings;

-- Test view functionality
SELECT 'Available Apartments View' as test_name, COUNT(*) as record_count 
FROM available_apartments
UNION ALL
SELECT 'Agent Performance View', COUNT(*) 
FROM agent_performance
UNION ALL
SELECT 'Customer Activity View', COUNT(*) 
FROM customer_activity;

-- Test foreign key relationships
SELECT 
    'Referential Integrity Check' as test_name,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS - No orphaned records'
        ELSE CONCAT('FAIL - ', COUNT(*), ' orphaned records found')
    END as result
FROM (
    -- Check for apartments without valid complex_id
    SELECT apartment_id FROM apartments a 
    LEFT JOIN building_complexes bc ON a.complex_id = bc.complex_id 
    WHERE bc.complex_id IS NULL
    
    UNION ALL
    
    -- Check for sales without valid apartment_id
    SELECT sale_id FROM sales s 
    LEFT JOIN apartments a ON s.apartment_id = a.apartment_id 
    WHERE a.apartment_id IS NULL
    
    UNION ALL
    
    -- Check for sales without valid customer_id
    SELECT sale_id FROM sales s 
    LEFT JOIN customers c ON s.customer_id = c.customer_id 
    WHERE c.customer_id IS NULL
) orphaned_records;

-- Test sample queries to ensure they execute properly
-- =====================================================

-- Sample query 1: Available apartments under $1M
SELECT 
    'Available Apartments Under $1M' as query_name,
    COUNT(*) as matching_records
FROM available_apartments 
WHERE current_price < 1000000;

-- Sample query 2: Agent performance summary
SELECT 
    'Agent Performance Summary' as query_name,
    COUNT(*) as agents_with_sales
FROM agent_performance 
WHERE total_sales > 0;

-- Sample query 3: Customer conversion rate
SELECT 
    'Customer Conversion Analysis' as query_name,
    ROUND(
        SUM(CASE WHEN total_purchases > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) as conversion_percentage
FROM customer_activity;

-- Database size and performance information
-- =====================================================

SELECT 
    'Database Size Information' as info_type,
    ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) as size_mb,
    COUNT(*) as total_tables
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'apartment_sales';

-- Index usage information
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM information_schema.STATISTICS 
WHERE TABLE_SCHEMA = 'apartment_sales'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- Success message
SELECT 
    '🎉 Database Setup Complete!' as status,
    'All tables created and populated successfully' as message,
    'You can now run queries from common_queries.sql' as next_step;