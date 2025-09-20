# ApartmentSales Database - EER Diagram Documentation

## Overview
This document describes the Enhanced Entity-Relationship (EER) diagram and database schema for the ApartmentSales web application. The database is designed to manage apartment sales, customer relationships, agent performance, and financial transactions.

## Database Structure

### Core Entities

#### 1. **Locations**
- **Purpose**: Stores hierarchical location information for properties
- **Key Fields**: country, state_province, city, district, street_address, coordinates
- **Relationships**: One-to-many with building_complexes and customers

#### 2. **Building Complexes**
- **Purpose**: Represents apartment buildings or development complexes
- **Key Fields**: complex_name, developer_name, construction_year, amenities
- **Relationships**: 
  - Many-to-one with locations
  - One-to-many with apartments

#### 3. **Property Types**
- **Purpose**: Defines apartment configurations (studio, 1BR, 2BR, etc.)
- **Key Fields**: type_name, bedrooms, bathrooms
- **Relationships**: One-to-many with apartments

#### 4. **Apartments**
- **Purpose**: Individual apartment units available for sale
- **Key Fields**: unit_number, square_footage, current_price, status
- **Relationships**: 
  - Many-to-one with building_complexes and property_types
  - One-to-many with sales, inquiries, viewings
  - Many-to-many with features

#### 5. **Features**
- **Purpose**: Property features and amenities (hardwood floors, balcony, etc.)
- **Key Fields**: feature_name, feature_category
- **Relationships**: Many-to-many with apartments through apartment_features

### People and Organizations

#### 6. **Customers**
- **Purpose**: Potential buyers and clients
- **Key Fields**: personal info, budget range, preferred_location
- **Relationships**: 
  - Many-to-one with locations (preferred)
  - One-to-many with sales, inquiries, viewings

#### 7. **Agents**
- **Purpose**: Real estate agents and sales representatives
- **Key Fields**: license info, commission_rate, specialization
- **Relationships**: 
  - Self-referencing (manager-subordinate)
  - One-to-many with sales, inquiries, viewings

### Transactions and Activities

#### 8. **Sales**
- **Purpose**: Completed and pending apartment sales transactions
- **Key Fields**: sale_price, commission_amount, sale_status, payment_method
- **Relationships**: 
  - Many-to-one with apartments, customers, agents
  - One-to-many with payment_schedule

#### 9. **Payment Schedule**
- **Purpose**: Installment payment tracking for sales
- **Key Fields**: installment_number, due_date, amount, payment_status
- **Relationships**: Many-to-one with sales

#### 10. **Inquiries**
- **Purpose**: Customer inquiries and information requests
- **Key Fields**: inquiry_type, status, follow_up_date
- **Relationships**: 
  - Many-to-one with customers, apartments, agents
  - One-to-many with viewings

#### 11. **Viewings**
- **Purpose**: Scheduled and completed property viewings
- **Key Fields**: scheduled_datetime, viewing_status, customer_feedback
- **Relationships**: Many-to-one with inquiries, apartments, customers, agents

## Entity Relationships

### Primary Relationships

1. **Location → Building Complex**: One location can have multiple building complexes
2. **Building Complex → Apartment**: One complex contains multiple apartments
3. **Property Type → Apartment**: One type can apply to multiple apartments
4. **Customer → Sale**: One customer can make multiple purchases
5. **Agent → Sale**: One agent can handle multiple sales
6. **Apartment → Sale**: One apartment can only be sold once (business rule)
7. **Sale → Payment Schedule**: One sale can have multiple payment installments

### Secondary Relationships

1. **Customer → Inquiry**: Customers can make multiple inquiries
2. **Inquiry → Viewing**: Inquiries can lead to multiple viewings
3. **Agent → Customer Interaction**: Agents manage customer relationships
4. **Apartment → Feature**: Many-to-many relationship for property features

## Business Rules and Constraints

### Data Integrity Rules

1. **Unique Constraints**:
   - Each apartment unit number must be unique within a building complex
   - Customer email addresses must be unique
   - Agent license numbers must be unique
   - Agent email addresses must be unique

2. **Status Constraints**:
   - Apartments can only be 'available', 'sold', 'reserved', or 'under_offer'
   - Sales can be 'pending', 'completed', 'cancelled', or 'failed'
   - Only one 'completed' sale per apartment is allowed

3. **Financial Rules**:
   - Sale price must be positive
   - Commission amount is calculated based on agent commission rate
   - Down payment + mortgage amount should equal sale price

4. **Date Constraints**:
   - Listing date cannot be in the future
   - Closing date must be after contract date
   - Payment due dates must be logical sequence

### Business Logic

1. **Apartment Status Workflow**:
   ```
   available → under_offer → sold
        ↓
   reserved → sold
   ```

2. **Sales Process**:
   ```
   inquiry → viewing → offer → contract → closing → completed
   ```

3. **Payment Processing**:
   - Cash sales: Single payment on closing
   - Mortgage sales: Down payment + mortgage disbursement
   - Installment sales: Multiple scheduled payments

## Database Views

### 1. **available_apartments**
- Shows all available apartments with complete details
- Joins apartments, property_types, building_complexes, and locations
- Filters for status = 'available'

### 2. **agent_performance**
- Aggregates sales performance metrics by agent
- Includes total sales, revenue, commission, and averages
- Useful for performance reviews and commission calculations

### 3. **customer_activity**
- Summarizes customer engagement and activity
- Tracks inquiries, viewings, and purchases
- Helps identify active prospects and conversion rates

## Indexes and Performance

### Primary Indexes
- All primary keys have clustered indexes
- Foreign key relationships have non-clustered indexes

### Performance Indexes
- **Price-based searches**: Index on apartments.current_price
- **Location searches**: Index on locations.city and postal_code
- **Date-based queries**: Indexes on listing_date, sale_date, inquiry_date
- **Status filtering**: Indexes on various status fields

### Composite Indexes
- **Customer budget**: Index on (budget_min, budget_max)
- **Apartment search**: Index on (status, current_price)
- **Payment tracking**: Index on (due_date, payment_status)

## Query Patterns

### Common Search Patterns

1. **Property Search**:
   - By location, price range, property type
   - By features and amenities
   - By availability status

2. **Sales Analytics**:
   - Monthly/quarterly sales reports
   - Agent performance metrics
   - Revenue by property type or location

3. **Customer Management**:
   - Lead tracking and conversion
   - Customer activity analysis
   - Follow-up scheduling

4. **Financial Reporting**:
   - Commission calculations
   - Payment tracking
   - Outstanding balances

## Data Migration and Setup

### Setup Order
1. Create database and tables (schema.sql)
2. Insert reference data (locations, property_types, features)
3. Insert master data (building_complexes, apartments)
4. Insert people data (customers, agents)
5. Insert transaction data (sales, payments, inquiries, viewings)

### Sample Data
- 8 locations across major cities
- 8 building complexes with various amenities
- 10 property types from studio to penthouse
- 14 apartment units with different features
- 8 customers with varying budgets and preferences
- 8 agents with different specializations
- 5 sales transactions (completed and pending)
- Multiple inquiries and viewings

## Security Considerations

### Data Protection
- Customer personal information (PII) should be encrypted
- Agent license numbers are sensitive business data
- Financial transaction details require audit trails

### Access Control
- Role-based permissions for different user types
- Agents should only access their assigned customers/sales
- Managers can view team performance data
- Customers can only view their own data

### Audit Requirements
- Track all changes to sales transactions
- Log all price changes for apartments
- Maintain history of customer interactions
- Record all payment transactions

## Future Enhancements

### Potential Extensions
1. **Document Management**: Store contracts, agreements, photos
2. **Communication Tracking**: Email/SMS integration
3. **Marketing Campaigns**: Lead source tracking, campaign effectiveness
4. **Property Management**: Maintenance requests, tenant information
5. **Financial Integration**: Mortgage pre-approval, payment gateway integration
6. **Mobile App Support**: APIs for mobile applications
7. **Analytics Dashboard**: Real-time reporting and visualizations

### Scalability Considerations
- Partition large tables by date or location
- Implement read replicas for reporting queries
- Consider NoSQL for document storage (photos, contracts)
- Implement caching for frequently accessed data
- Add full-text search capabilities for property descriptions