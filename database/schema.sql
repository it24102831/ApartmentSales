-- =====================================================
-- ApartmentSales Database Schema
-- Enhanced Entity-Relationship (EER) Diagram Implementation
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS apartment_sales;
USE apartment_sales;

-- =====================================================
-- Core Entity Tables
-- =====================================================

-- Locations table (supports hierarchical locations)
CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100),
    street_address VARCHAR(255),
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Building complexes/developments
CREATE TABLE building_complexes (
    complex_id INT PRIMARY KEY AUTO_INCREMENT,
    complex_name VARCHAR(200) NOT NULL,
    location_id INT NOT NULL,
    developer_name VARCHAR(200),
    construction_year YEAR,
    total_floors INT,
    total_units INT,
    amenities TEXT,
    description TEXT,
    status ENUM('under_construction', 'completed', 'renovation') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Property types (apartment configurations)
CREATE TABLE property_types (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(100) NOT NULL UNIQUE,
    bedrooms INT NOT NULL,
    bathrooms DECIMAL(2,1) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Apartments/Properties
CREATE TABLE apartments (
    apartment_id INT PRIMARY KEY AUTO_INCREMENT,
    complex_id INT NOT NULL,
    type_id INT NOT NULL,
    unit_number VARCHAR(50) NOT NULL,
    floor_number INT,
    square_footage DECIMAL(8,2),
    balcony_area DECIMAL(6,2),
    parking_spaces INT DEFAULT 0,
    storage_included BOOLEAN DEFAULT FALSE,
    furnishing_status ENUM('unfurnished', 'semi_furnished', 'fully_furnished') DEFAULT 'unfurnished',
    facing_direction ENUM('north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest'),
    current_price DECIMAL(12,2) NOT NULL,
    original_price DECIMAL(12,2),
    status ENUM('available', 'sold', 'reserved', 'under_offer') DEFAULT 'available',
    listing_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (complex_id) REFERENCES building_complexes(complex_id),
    FOREIGN KEY (type_id) REFERENCES property_types(type_id),
    UNIQUE KEY unique_unit (complex_id, unit_number)
);

-- Property features (many-to-many relationship)
CREATE TABLE features (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    feature_name VARCHAR(100) NOT NULL UNIQUE,
    feature_category VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE apartment_features (
    apartment_id INT,
    feature_id INT,
    feature_value VARCHAR(100),
    PRIMARY KEY (apartment_id, feature_id),
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);

-- =====================================================
-- People and Organizations
-- =====================================================

-- Customers/Buyers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    nationality VARCHAR(100),
    preferred_contact ENUM('email', 'phone', 'both') DEFAULT 'both',
    budget_min DECIMAL(12,2),
    budget_max DECIMAL(12,2),
    preferred_location_id INT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive', 'blacklisted') DEFAULT 'active',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (preferred_location_id) REFERENCES locations(location_id)
);

-- Real Estate Agents
CREATE TABLE agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_number VARCHAR(100) UNIQUE,
    license_expiry_date DATE,
    commission_rate DECIMAL(5,4) DEFAULT 0.0300, -- 3% default
    specialization VARCHAR(200),
    hire_date DATE NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    manager_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (manager_id) REFERENCES agents(agent_id)
);

-- =====================================================
-- Sales and Financial Transactions
-- =====================================================

-- Sales transactions
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    apartment_id INT NOT NULL,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL,
    commission_amount DECIMAL(10,2),
    sale_date DATE NOT NULL,
    contract_date DATE,
    closing_date DATE,
    sale_status ENUM('pending', 'completed', 'cancelled', 'failed') DEFAULT 'pending',
    payment_method ENUM('cash', 'mortgage', 'installment', 'mixed'),
    down_payment DECIMAL(12,2),
    mortgage_amount DECIMAL(12,2),
    financing_bank VARCHAR(200),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- Payment schedule for installment sales
CREATE TABLE payment_schedule (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_status ENUM('pending', 'paid', 'overdue', 'waived') DEFAULT 'pending',
    payment_method VARCHAR(100),
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id) ON DELETE CASCADE,
    UNIQUE KEY unique_installment (sale_id, installment_number)
);

-- =====================================================
-- Customer Interactions and Marketing
-- =====================================================

-- Customer inquiries and viewings
CREATE TABLE inquiries (
    inquiry_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    apartment_id INT,
    agent_id INT,
    inquiry_type ENUM('viewing_request', 'information_request', 'price_inquiry', 'general') NOT NULL,
    inquiry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('new', 'in_progress', 'completed', 'cancelled') DEFAULT 'new',
    notes TEXT,
    follow_up_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- Property viewings
CREATE TABLE viewings (
    viewing_id INT PRIMARY KEY AUTO_INCREMENT,
    inquiry_id INT,
    apartment_id INT NOT NULL,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    scheduled_datetime DATETIME NOT NULL,
    actual_datetime DATETIME,
    duration_minutes INT,
    viewing_status ENUM('scheduled', 'completed', 'no_show', 'cancelled') DEFAULT 'scheduled',
    customer_feedback TEXT,
    interest_level ENUM('high', 'medium', 'low', 'none'),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (inquiry_id) REFERENCES inquiries(inquiry_id),
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- =====================================================
-- Indexes for Performance
-- =====================================================

-- Location indexes
CREATE INDEX idx_location_city ON locations(city);
CREATE INDEX idx_location_postal ON locations(postal_code);

-- Building complex indexes
CREATE INDEX idx_complex_location ON building_complexes(location_id);
CREATE INDEX idx_complex_status ON building_complexes(status);

-- Apartment indexes
CREATE INDEX idx_apartment_complex ON apartments(complex_id);
CREATE INDEX idx_apartment_type ON apartments(type_id);
CREATE INDEX idx_apartment_status ON apartments(status);
CREATE INDEX idx_apartment_price ON apartments(current_price);
CREATE INDEX idx_apartment_listing_date ON apartments(listing_date);

-- Customer indexes
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_customer_location ON customers(preferred_location_id);
CREATE INDEX idx_customer_budget ON customers(budget_min, budget_max);

-- Agent indexes
CREATE INDEX idx_agent_email ON agents(email);
CREATE INDEX idx_agent_license ON agents(license_number);
CREATE INDEX idx_agent_status ON agents(status);

-- Sales indexes
CREATE INDEX idx_sales_apartment ON sales(apartment_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_agent ON sales(agent_id);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_status ON sales(sale_status);

-- Payment indexes
CREATE INDEX idx_payment_sale ON payment_schedule(sale_id);
CREATE INDEX idx_payment_due_date ON payment_schedule(due_date);
CREATE INDEX idx_payment_status ON payment_schedule(payment_status);

-- Inquiry and viewing indexes
CREATE INDEX idx_inquiry_customer ON inquiries(customer_id);
CREATE INDEX idx_inquiry_apartment ON inquiries(apartment_id);
CREATE INDEX idx_inquiry_date ON inquiries(inquiry_date);
CREATE INDEX idx_viewing_datetime ON viewings(scheduled_datetime);
CREATE INDEX idx_viewing_customer ON viewings(customer_id);

-- =====================================================
-- Views for Common Queries
-- =====================================================

-- Available apartments with full details
CREATE VIEW available_apartments AS
SELECT 
    a.apartment_id,
    a.unit_number,
    a.floor_number,
    a.square_footage,
    a.current_price,
    a.furnishing_status,
    pt.type_name,
    pt.bedrooms,
    pt.bathrooms,
    bc.complex_name,
    bc.amenities as complex_amenities,
    l.city,
    l.district,
    l.street_address,
    a.listing_date,
    a.description
FROM apartments a
JOIN property_types pt ON a.type_id = pt.type_id
JOIN building_complexes bc ON a.complex_id = bc.complex_id
JOIN locations l ON bc.location_id = l.location_id
WHERE a.status = 'available';

-- Agent sales performance
CREATE VIEW agent_performance AS
SELECT 
    ag.agent_id,
    CONCAT(ag.first_name, ' ', ag.last_name) as agent_name,
    COUNT(s.sale_id) as total_sales,
    SUM(s.sale_price) as total_sales_value,
    AVG(s.sale_price) as avg_sale_price,
    SUM(s.commission_amount) as total_commission,
    MIN(s.sale_date) as first_sale_date,
    MAX(s.sale_date) as last_sale_date
FROM agents ag
LEFT JOIN sales s ON ag.agent_id = s.agent_id AND s.sale_status = 'completed'
WHERE ag.status = 'active'
GROUP BY ag.agent_id, ag.first_name, ag.last_name;

-- Customer activity summary
CREATE VIEW customer_activity AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email,
    COUNT(DISTINCT i.inquiry_id) as total_inquiries,
    COUNT(DISTINCT v.viewing_id) as total_viewings,
    COUNT(DISTINCT s.sale_id) as total_purchases,
    MAX(i.inquiry_date) as last_inquiry_date,
    MAX(v.scheduled_datetime) as last_viewing_date
FROM customers c
LEFT JOIN inquiries i ON c.customer_id = i.customer_id
LEFT JOIN viewings v ON c.customer_id = v.customer_id
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE c.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;