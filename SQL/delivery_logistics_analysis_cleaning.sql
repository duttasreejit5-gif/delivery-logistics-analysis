create database delivery_logistics;
use delivery_logistics;
create table delivery_data (
    delivery_id VARCHAR(50),
    delivery_partner VARCHAR(50),
    package_type VARCHAR(50),
    vehicle_type VARCHAR(50),
    delivery_mode VARCHAR(50),
    region VARCHAR(50),
    weather_condition VARCHAR(50),
    distance_km DECIMAL(10,2),
    package_weight_kg DECIMAL(10,2),
    delivery_time_hours DECIMAL(10,2),
    expected_time_hours DECIMAL(10,2),
    delayed_flag VARCHAR(10),
    delivery_status VARCHAR(20),
    delivery_rating INT,
    delivery_cost DECIMAL(12,2)
);

alter table delivery_data
modify delivery_time_hours varchar(50),
modify expected_time_hours varchar(50);

describe delivery_data;

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Update the file path below according to your local MySQL setup.
LOAD DATA LOCAL INFILE 'YOUR_LOCAL_PATH/Delivery_Logistics.csv'
INTO TABLE delivery_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    delivery_id,
    delivery_partner,
    package_type,
    vehicle_type,
    delivery_mode,
    region,
    weather_condition,
    distance_km,
    package_weight_kg,
    delivery_time_hours,
    expected_time_hours,
    @delayed,
    delivery_status,
    delivery_rating,
    delivery_cost
)
SET delayed_flag = @delayed;

-- ============================================
-- Create analytical fields
-- ============================================

ALTER TABLE delivery_data
ADD COLUMN delivery_time_hours_clean DECIMAL(10,2),
ADD COLUMN expected_time_hours_clean DECIMAL(10,2),
ADD COLUMN delay_hours DECIMAL(10,2),
ADD COLUMN on_time_flag VARCHAR(10);

UPDATE delivery_data
SET
    delivery_time_hours_clean = CAST(RIGHT(delivery_time_hours, 9) AS DECIMAL(10,2)),
    expected_time_hours_clean = CAST(RIGHT(expected_time_hours, 9) AS DECIMAL(10,2));

UPDATE delivery_data
SET
    delay_hours = delivery_time_hours_clean - expected_time_hours_clean,
    on_time_flag = CASE
        WHEN delivery_time_hours_clean <= expected_time_hours_clean THEN 'Yes'
        ELSE 'No'
    END;

-- Verify cleaned analytical fields
SELECT
    COUNT(*) AS total_records,
    COUNT(delivery_time_hours_clean) AS valid_delivery_times,
    COUNT(expected_time_hours_clean) AS valid_expected_times,
    COUNT(delay_hours) AS valid_delay_values
FROM delivery_data;