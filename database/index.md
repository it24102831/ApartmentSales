# ApartmentSales Database Schema Files

This directory contains the complete SQL implementation of the Enhanced Entity-Relationship (EER) diagram for the ApartmentSales web-based apartment sales system.

## Files Overview

### 📄 Core Database Files

1. **`schema.sql`** - Complete database schema definition
   - Creates all tables with proper relationships
   - Defines indexes for performance optimization
   - Creates views for common queries
   - Implements constraints and business rules

2. **`sample_data.sql`** - Sample data for testing and development
   - Realistic test data across all entities
   - Demonstrates relationships between tables
   - Includes various scenarios (completed sales, pending transactions, etc.)

3. **`common_queries.sql`** - Business intelligence and reporting queries
   - Property search and listing queries
   - Sales performance analytics
   - Customer engagement analysis
   - Inventory management reports
   - Financial reporting queries
   - Operational queries for daily use

4. **`setup_test.sql`** - Database setup and validation script
   - Automated setup process
   - Data integrity verification
   - Performance testing queries
   - Relationship validation

5. **`README.md`** - Comprehensive documentation
   - Detailed EER diagram explanation
   - Entity relationships and business rules
   - Database design decisions
   - Performance considerations
   - Security guidelines

## Quick Start

### Option 1: MySQL/MariaDB Setup
```sql
-- 1. Connect to your MySQL server
mysql -u root -p

-- 2. Run the setup script
source /path/to/database/setup_test.sql

-- 3. Test with sample queries
source /path/to/database/common_queries.sql
```

### Option 2: Manual Setup
```sql
-- 1. Create schema
source schema.sql

-- 2. Insert sample data
source sample_data.sql

-- 3. Run validation tests
source setup_test.sql
```

## Database Schema Overview

### 📊 Entity Count Summary
- **11 Main Tables**: Core business entities
- **3 Views**: Pre-built query views for common operations
- **20+ Indexes**: Performance optimization
- **Sample Data**: 100+ records across all tables

### 🔗 Key Relationships
```
locations (1) ──→ (n) building_complexes (1) ──→ (n) apartments
    ↓                                                    ↓
customers (n) ──→ (n) sales (n) ──→ (1) payment_schedule
    ↓                   ↑
inquiries (1) ──→ (n) viewings    agents (1) ──→ (n) sales
```

### 🏢 Core Entities

1. **Location Management**
   - `locations` - Geographic information
   - `building_complexes` - Property developments

2. **Property Catalog**
   - `property_types` - Apartment configurations  
   - `apartments` - Individual units
   - `features` + `apartment_features` - Property amenities

3. **People & Organizations**
   - `customers` - Buyers and prospects
   - `agents` - Sales representatives

4. **Business Transactions**
   - `sales` - Purchase transactions
   - `payment_schedule` - Payment tracking
   - `inquiries` - Customer inquiries
   - `viewings` - Property showings

## Query Categories

### 🔍 Property Search Queries
- Search by location, price, features
- Availability filtering
- Property comparisons

### 📈 Sales Analytics
- Monthly/quarterly reports
- Agent performance metrics
- Revenue analysis by type/location

### 👥 Customer Management  
- Lead tracking and conversion
- Customer activity analysis
- Engagement metrics

### 💰 Financial Reporting
- Commission calculations
- Payment tracking
- Outstanding balances

### 🏠 Inventory Management
- Availability status
- Days on market analysis
- Building occupancy rates

## Business Rules Implemented

### Data Integrity
- ✅ Unique apartment units per building
- ✅ Unique customer email addresses
- ✅ Agent license validation
- ✅ Price and financial constraints

### Workflow Management
- ✅ Apartment status progression
- ✅ Sales process tracking
- ✅ Payment scheduling logic
- ✅ Inquiry → Viewing → Sale pipeline

### Performance Features
- ✅ Optimized indexes for common searches
- ✅ Pre-computed views for complex queries
- ✅ Efficient relationship structures
- ✅ Scalable design patterns

## Sample Use Cases

### For Sales Agents
```sql
-- Find available apartments in customer's budget
SELECT * FROM available_apartments 
WHERE current_price BETWEEN 800000 AND 1200000
AND city = 'Los Angeles';

-- View upcoming appointments
SELECT * FROM viewings 
WHERE agent_id = 1 AND scheduled_datetime >= NOW()
ORDER BY scheduled_datetime;
```

### For Management
```sql
-- Monthly sales performance
SELECT agent_name, total_sales, total_sales_value 
FROM agent_performance 
ORDER BY total_sales_value DESC;

-- Inventory status overview
SELECT status, COUNT(*) as units, AVG(current_price) as avg_price
FROM apartments GROUP BY status;
```

### For Marketing
```sql
-- Customer conversion funnel
SELECT stage, count, percentage FROM (
  -- ... lead conversion analysis query
);

-- Property feature popularity
SELECT feature_name, COUNT(*) as apartment_count
FROM apartment_features af
JOIN features f ON af.feature_id = f.feature_id
GROUP BY feature_name ORDER BY apartment_count DESC;
```

## Technology Compatibility

### Database Engines
- ✅ **MySQL 5.7+** (Primary target)
- ✅ **MariaDB 10.3+** (Fully compatible)  
- ⚠️ **PostgreSQL** (Minor syntax adjustments needed)
- ⚠️ **SQL Server** (Moderate adjustments for data types)

### Framework Integration
- Compatible with ORMs (Laravel Eloquent, Django ORM, etc.)
- RESTful API ready structure
- Suitable for microservices architecture
- Mobile app backend ready

## Next Steps

1. **Deploy Database**: Use `setup_test.sql` for quick deployment
2. **Customize Data**: Modify `sample_data.sql` for your specific needs  
3. **Add Queries**: Extend `common_queries.sql` with business-specific reports
4. **Integrate Application**: Connect your web application to the database
5. **Monitor Performance**: Use the provided indexes and optimize as needed

## Support & Documentation

- 📖 Full documentation in `README.md`
- 🔧 Setup instructions in `setup_test.sql`
- 💼 Business queries in `common_queries.sql`
- 🗃️ Complete schema in `schema.sql`

---

**Created for**: ApartmentSales Web Application  
**Database Type**: Relational (MySQL/MariaDB)  
**Schema Version**: 1.0  
**Last Updated**: 2024