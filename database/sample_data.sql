-- =====================================================
-- Sample Data Insertion for ApartmentSales Database
-- =====================================================

USE apartment_sales;

-- =====================================================
-- Insert Locations
-- =====================================================

INSERT INTO locations (country, state_province, city, district, street_address, postal_code, latitude, longitude) VALUES
('USA', 'California', 'Los Angeles', 'Beverly Hills', '9200 Sunset Blvd', '90069', 34.090119, -118.374173),
('USA', 'California', 'Los Angeles', 'Downtown', '801 S Grand Ave', '90017', 34.049148, -118.258301),
('USA', 'New York', 'New York', 'Manhattan', '350 5th Ave', '10118', 40.748441, -73.985664),
('USA', 'New York', 'New York', 'Brooklyn', '1 MetroTech Center', '11201', 40.693943, -73.985135),
('USA', 'Florida', 'Miami', 'South Beach', '1500 Ocean Drive', '33139', 25.787676, -80.130821),
('Canada', 'Ontario', 'Toronto', 'Downtown', '1 Yonge Street', 'M5E 1W7', 43.642566, -79.387057),
('UK', 'England', 'London', 'Westminster', '123 Piccadilly', 'W1J 9HF', 51.507351, -0.127758),
('Australia', 'New South Wales', 'Sydney', 'CBD', '100 George Street', '2000', -33.868820, 151.209296);

-- =====================================================
-- Insert Property Types
-- =====================================================

INSERT INTO property_types (type_name, bedrooms, bathrooms, description) VALUES
('Studio', 0, 1, 'Open-plan living space with separate bathroom'),
('1 Bedroom', 1, 1, 'One bedroom apartment with living area'),
('1 Bedroom + Den', 1, 1, 'One bedroom with additional den/office space'),
('2 Bedroom', 2, 2, 'Two bedroom apartment with two bathrooms'),
('2 Bedroom + Den', 2, 2, 'Two bedroom with additional den/office space'),
('3 Bedroom', 3, 2, 'Three bedroom apartment with two bathrooms'),
('3 Bedroom + Den', 3, 2.5, 'Three bedroom with den and half bath'),
('Penthouse 2BR', 2, 2.5, 'Luxury penthouse with two bedrooms'),
('Penthouse 3BR', 3, 3, 'Luxury penthouse with three bedrooms'),
('Loft', 1, 1.5, 'Modern loft-style apartment');

-- =====================================================
-- Insert Building Complexes
-- =====================================================

INSERT INTO building_complexes (complex_name, location_id, developer_name, construction_year, total_floors, total_units, amenities, description, status) VALUES
('Sunset Plaza Residences', 1, 'Premium Developments LLC', 2023, 25, 180, 'Pool, Gym, Concierge, Valet Parking, Rooftop Garden', 'Luxury high-rise in Beverly Hills', 'completed'),
('Downtown Grand Tower', 2, 'Urban Living Corp', 2022, 40, 320, 'Pool, Gym, Business Center, Sky Lounge', 'Modern downtown living', 'completed'),
('Manhattan Heights', 3, 'NYC Developers Inc', 2024, 35, 250, 'Doorman, Gym, Roof Deck, Pet Spa', 'Premium Manhattan residence', 'under_construction'),
('Brooklyn Bridge View', 4, 'Bridge Developments', 2021, 20, 150, 'Gym, Coworking Space, Garden', 'Modern Brooklyn living with bridge views', 'completed'),
('Ocean Drive Luxury', 5, 'Miami Premium Living', 2023, 30, 200, 'Beach Access, Pool, Spa, Restaurant', 'Luxury oceanfront living', 'completed'),
('Toronto Central Plaza', 6, 'Canadian Urban Dev', 2022, 45, 400, 'Mall Access, Gym, Pool, Concierge', 'Connected to underground mall system', 'completed'),
('Piccadilly Gardens', 7, 'London Prime Properties', 2023, 15, 120, 'Garden, Gym, Library, Butler Service', 'Historic London luxury', 'completed'),
('Sydney Harbour Towers', 8, 'Harbour Developments', 2024, 50, 350, 'Harbour Views, Pool, Gym, Marina Access', 'Iconic harbour views', 'under_construction');

-- =====================================================
-- Insert Features
-- =====================================================

INSERT INTO features (feature_name, feature_category, description) VALUES
('Hardwood Flooring', 'Flooring', 'Premium hardwood floors throughout'),
('Marble Countertops', 'Kitchen', 'Luxury marble kitchen countertops'),
('Stainless Steel Appliances', 'Kitchen', 'High-end stainless steel appliance package'),
('Walk-in Closet', 'Storage', 'Large walk-in closet in master bedroom'),
('Balcony', 'Outdoor', 'Private balcony with city/ocean views'),
('In-unit Laundry', 'Utilities', 'Washer and dryer in unit'),
('Central Air', 'Climate', 'Central air conditioning system'),
('Floor-to-ceiling Windows', 'Windows', 'Panoramic floor-to-ceiling windows'),
('Smart Home Features', 'Technology', 'Integrated smart home automation'),
('Fireplace', 'Amenities', 'Gas or electric fireplace');

-- =====================================================
-- Insert Sample Apartments
-- =====================================================

INSERT INTO apartments (complex_id, type_id, unit_number, floor_number, square_footage, balcony_area, parking_spaces, storage_included, furnishing_status, facing_direction, current_price, original_price, status, listing_date, description) VALUES
-- Sunset Plaza Residences (Beverly Hills)
(1, 1, '501', 5, 750.00, 80.00, 1, TRUE, 'unfurnished', 'south', 850000.00, 850000.00, 'available', '2024-01-15', 'Stunning studio with city views'),
(1, 4, '1205', 12, 1200.00, 150.00, 1, TRUE, 'semi_furnished', 'west', 1450000.00, 1450000.00, 'available', '2024-01-20', 'Luxury 2BR with sunset views'),
(1, 6, '2001', 20, 1800.00, 200.00, 2, TRUE, 'unfurnished', 'south', 2200000.00, 2200000.00, 'sold', '2024-01-10', 'Penthouse-level 3BR with panoramic views'),

-- Downtown Grand Tower (LA Downtown)
(2, 2, '815', 8, 900.00, 100.00, 1, FALSE, 'unfurnished', 'east', 650000.00, 650000.00, 'available', '2024-02-01', 'Modern 1BR in heart of downtown'),
(2, 4, '1520', 15, 1100.00, 120.00, 1, TRUE, 'unfurnished', 'north', 950000.00, 950000.00, 'under_offer', '2024-01-25', 'Spacious 2BR with city lights view'),
(2, 8, '3501', 35, 2500.00, 400.00, 3, TRUE, 'fully_furnished', 'south', 3500000.00, 3500000.00, 'available', '2024-02-05', 'Luxury penthouse with private elevator'),

-- Manhattan Heights (NYC)
(3, 3, '1008', 10, 950.00, 90.00, 0, TRUE, 'unfurnished', 'east', 1200000.00, 1200000.00, 'available', '2024-02-10', '1BR+Den perfect for professionals'),
(3, 5, '1815', 18, 1350.00, 180.00, 0, TRUE, 'semi_furnished', 'south', 1800000.00, 1800000.00, 'reserved', '2024-02-08', '2BR+Den with Central Park views'),

-- Brooklyn Bridge View
(4, 2, '705', 7, 850.00, 100.00, 0, FALSE, 'unfurnished', 'west', 750000.00, 750000.00, 'available', '2024-01-30', 'Brooklyn 1BR with bridge views'),
(4, 4, '1210', 12, 1150.00, 140.00, 1, TRUE, 'unfurnished', 'west', 1100000.00, 1100000.00, 'sold', '2024-01-28', 'Prime 2BR with Manhattan skyline views'),

-- Ocean Drive Luxury (Miami)
(5, 1, '308', 3, 700.00, 120.00, 1, TRUE, 'fully_furnished', 'east', 950000.00, 950000.00, 'available', '2024-02-12', 'Oceanfront studio with beach access'),
(5, 6, '1505', 15, 1600.00, 250.00, 2, TRUE, 'semi_furnished', 'east', 2100000.00, 2100000.00, 'available', '2024-02-15', 'Luxury 3BR with ocean views'),

-- Toronto Central Plaza
(6, 2, '1012', 10, 800.00, 80.00, 1, TRUE, 'unfurnished', 'north', 520000.00, 520000.00, 'available', '2024-02-18', 'Downtown Toronto 1BR with city views'),
(6, 4, '2508', 25, 1050.00, 100.00, 1, TRUE, 'unfurnished', 'south', 720000.00, 720000.00, 'under_offer', '2024-02-20', 'Modern 2BR with CN Tower views');

-- =====================================================
-- Insert Sample Apartment Features
-- =====================================================

INSERT INTO apartment_features (apartment_id, feature_id, feature_value) VALUES
-- Sunset Plaza features
(1, 1, 'Oak hardwood'), (1, 5, '80 sq ft'), (1, 6, 'Bosch'), (1, 7, 'Central'),
(2, 1, 'Walnut hardwood'), (2, 2, 'Carrara marble'), (2, 3, 'Viking'), (2, 5, '150 sq ft'), (2, 8, 'Floor-to-ceiling'), (2, 9, 'Nest system'),
(3, 1, 'Brazilian cherry'), (3, 2, 'Calacatta marble'), (3, 3, 'Sub-Zero'), (3, 4, 'His/hers closets'), (3, 5, '200 sq ft'), (3, 10, 'Gas fireplace'),

-- Downtown Grand features
(4, 1, 'Engineered oak'), (4, 5, '100 sq ft'), (4, 6, 'LG'), (4, 7, 'Central'),
(5, 1, 'Bamboo'), (5, 2, 'Quartz'), (5, 3, 'KitchenAid'), (5, 5, '120 sq ft'), (5, 8, 'Panoramic'),
(6, 1, 'Italian marble'), (6, 2, 'Statuario marble'), (6, 3, 'Miele'), (6, 4, 'Custom built-ins'), (6, 5, '400 sq ft'), (6, 9, 'Control4'), (6, 10, 'Double-sided fireplace');

-- =====================================================
-- Insert Sample Customers
-- =====================================================

INSERT INTO customers (first_name, last_name, email, phone, date_of_birth, nationality, preferred_contact, budget_min, budget_max, preferred_location_id, notes) VALUES
('John', 'Smith', 'john.smith@email.com', '+1-555-0101', '1985-03-15', 'American', 'both', 800000.00, 1200000.00, 1, 'Looking for luxury apartment in Beverly Hills'),
('Emily', 'Johnson', 'emily.johnson@email.com', '+1-555-0102', '1990-07-22', 'American', 'email', 600000.00, 900000.00, 2, 'First-time buyer, prefers downtown LA'),
('Michael', 'Chen', 'michael.chen@email.com', '+1-555-0103', '1978-11-08', 'Canadian', 'phone', 1000000.00, 1500000.00, 3, 'Investment property in Manhattan'),
('Sarah', 'Williams', 'sarah.williams@email.com', '+1-555-0104', '1992-05-18', 'American', 'both', 700000.00, 1100000.00, 4, 'Young professional, Brooklyn preferred'),
('David', 'Rodriguez', 'david.rodriguez@email.com', '+1-555-0105', '1980-09-25', 'American', 'email', 900000.00, 2500000.00, 5, 'Luxury oceanfront property in Miami'),
('Lisa', 'Thompson', 'lisa.thompson@email.com', '+1-416-555-0106', '1987-12-03', 'Canadian', 'both', 400000.00, 700000.00, 6, 'Relocating to Toronto for work'),
('James', 'Brown', 'james.brown@email.com', '+44-20-7946-0107', '1975-04-12', 'British', 'phone', 800000.00, 1500000.00, 7, 'London executive looking for luxury flat'),
('Anna', 'Wilson', 'anna.wilson@email.com', '+61-2-9876-0108', '1988-08-30', 'Australian', 'email', 600000.00, 1200000.00, 8, 'Sydney harbour views preferred');

-- =====================================================
-- Insert Sample Agents
-- =====================================================

INSERT INTO agents (first_name, last_name, email, phone, license_number, license_expiry_date, commission_rate, specialization, hire_date, status) VALUES
('Robert', 'Martinez', 'robert.martinez@realestate.com', '+1-555-1001', 'CA-RE-001234', '2025-12-31', 0.0300, 'Luxury Properties', '2020-01-15', 'active'),
('Jennifer', 'Davis', 'jennifer.davis@realestate.com', '+1-555-1002', 'CA-RE-001235', '2025-06-30', 0.0275, 'Downtown Properties', '2019-03-10', 'active'),
('William', 'Garcia', 'william.garcia@realestate.com', '+1-555-1003', 'NY-RE-002001', '2025-09-15', 0.0350, 'Manhattan Luxury', '2021-05-20', 'active'),
('Michelle', 'Anderson', 'michelle.anderson@realestate.com', '+1-555-1004', 'NY-RE-002002', '2025-11-20', 0.0300, 'Brooklyn Properties', '2020-08-12', 'active'),
('Christopher', 'Taylor', 'christopher.taylor@realestate.com', '+1-555-1005', 'FL-RE-003001', '2025-07-10', 0.0325, 'Waterfront Properties', '2018-11-30', 'active'),
('Amanda', 'White', 'amanda.white@realestate.com', '+1-416-555-1006', 'ON-RE-004001', '2025-05-25', 0.0280, 'Urban Condos', '2019-09-15', 'active'),
('Daniel', 'Jackson', 'daniel.jackson@realestate.com', '+44-20-7946-1007', 'UK-RE-005001', '2025-03-18', 0.0400, 'Prime London Properties', '2017-02-28', 'active'),
('Rachel', 'Lee', 'rachel.lee@realestate.com', '+61-2-9876-1008', 'NSW-RE-006001', '2025-08-08', 0.0320, 'Harbour Properties', '2020-06-10', 'active');

-- =====================================================
-- Insert Sample Sales
-- =====================================================

INSERT INTO sales (apartment_id, customer_id, agent_id, sale_price, commission_amount, sale_date, contract_date, closing_date, sale_status, payment_method, down_payment, mortgage_amount, financing_bank, notes) VALUES
-- Completed sales
(3, 1, 1, 2200000.00, 66000.00, '2024-02-15', '2024-02-10', '2024-03-15', 'completed', 'mortgage', 440000.00, 1760000.00, 'Wells Fargo Private Bank', 'Smooth transaction, buyer very satisfied'),
(11, 4, 4, 1100000.00, 33000.00, '2024-02-20', '2024-02-18', '2024-03-20', 'completed', 'cash', 1100000.00, 0.00, NULL, 'Cash purchase, quick closing'),

-- Pending sales
(5, 2, 2, 950000.00, 26062.50, '2024-02-25', '2024-02-23', '2024-03-25', 'pending', 'mortgage', 190000.00, 760000.00, 'Bank of America', 'Waiting for final mortgage approval'),
(8, 3, 3, 1800000.00, 63000.00, '2024-02-28', '2024-02-26', '2024-03-28', 'pending', 'mixed', 900000.00, 900000.00, 'Chase Private Client', 'High-value client, expedited processing'),
(14, 6, 6, 720000.00, 20160.00, '2024-03-01', '2024-02-28', '2024-03-30', 'pending', 'mortgage', 144000.00, 576000.00, 'RBC Royal Bank', 'First-time buyer program');

-- =====================================================
-- Insert Sample Payment Schedule
-- =====================================================

INSERT INTO payment_schedule (sale_id, installment_number, due_date, amount, payment_date, payment_status, payment_method, reference_number) VALUES
-- Payment schedule for sale_id 3 (pending mortgage sale)
(3, 1, '2024-02-25', 190000.00, '2024-02-25', 'paid', 'Wire Transfer', 'WT-2024-001'),
(3, 2, '2024-03-25', 760000.00, NULL, 'pending', 'Mortgage Disbursement', NULL),

-- Payment schedule for sale_id 4 (pending mixed payment)
(4, 1, '2024-02-28', 900000.00, '2024-02-28', 'paid', 'Wire Transfer', 'WT-2024-002'),
(4, 2, '2024-03-28', 900000.00, NULL, 'pending', 'Mortgage Disbursement', NULL),

-- Payment schedule for sale_id 5 (pending mortgage)
(5, 1, '2024-03-01', 144000.00, '2024-03-01', 'paid', 'Certified Check', 'CC-2024-001'),
(5, 2, '2024-03-30', 576000.00, NULL, 'pending', 'Mortgage Disbursement', NULL);

-- =====================================================
-- Insert Sample Inquiries
-- =====================================================

INSERT INTO inquiries (customer_id, apartment_id, agent_id, inquiry_type, status, notes, follow_up_date) VALUES
(1, 1, 1, 'viewing_request', 'completed', 'Customer interested in studio apartment', '2024-03-10'),
(1, 2, 1, 'information_request', 'completed', 'Requested floor plans and amenities info', '2024-03-05'),
(2, 4, 2, 'price_inquiry', 'in_progress', 'Negotiating price for 1BR downtown', '2024-03-08'),
(3, 7, 3, 'viewing_request', 'new', 'High-value client wants Manhattan viewing', '2024-03-12'),
(5, 12, 5, 'information_request', 'completed', 'Oceanfront property inquiry', '2024-03-07'),
(6, 13, 6, 'viewing_request', 'in_progress', 'Toronto relocation inquiry', '2024-03-15'),
(7, 1, 1, 'general', 'new', 'General inquiry about Beverly Hills properties', '2024-03-20'),
(8, 13, 6, 'price_inquiry', 'completed', 'Comparing Toronto vs Sydney prices', '2024-03-18');

-- =====================================================
-- Insert Sample Viewings
-- =====================================================

INSERT INTO viewings (inquiry_id, apartment_id, customer_id, agent_id, scheduled_datetime, actual_datetime, duration_minutes, viewing_status, customer_feedback, interest_level, notes) VALUES
(1, 1, 1, 1, '2024-02-20 14:00:00', '2024-02-20 14:00:00', 45, 'completed', 'Beautiful views but prefers larger space', 'medium', 'Customer liked the building amenities'),
(2, 2, 1, 1, '2024-02-22 11:00:00', '2024-02-22 11:15:00', 60, 'completed', 'Perfect size and layout, very interested', 'high', 'Ready to make offer after seeing unit'),
(3, 4, 2, 2, '2024-03-01 16:00:00', '2024-03-01 16:00:00', 30, 'completed', 'Good value but wants price reduction', 'medium', 'Price negotiation ongoing'),
(4, 7, 3, 3, '2024-03-15 10:00:00', NULL, NULL, 'scheduled', NULL, NULL, 'High-priority client viewing'),
(5, 12, 5, 5, '2024-02-25 13:00:00', '2024-02-25 13:00:00', 75, 'completed', 'Exceeded expectations, ocean views amazing', 'high', 'Client very impressed with property'),
(6, 13, 6, 6, '2024-03-10 15:30:00', '2024-03-10 15:45:00', 40, 'completed', 'Good location but concerned about size', 'low', 'May need to show larger units'),
(8, 13, 8, 6, '2024-03-08 12:00:00', '2024-03-08 12:00:00', 50, 'completed', 'Comparing with Sydney market, interested', 'medium', 'International buyer, needs financing info');