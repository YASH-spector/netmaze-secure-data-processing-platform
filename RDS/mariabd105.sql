Create Database
CREATE DATABASE netmaze_db;
USE netmaze_db;

File Validation Log Table
CREATE TABLE file_validation_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(50),
    validation_status VARCHAR(50),
    processed_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

S3 Upload Log Table
CREATE TABLE s3_upload_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255),
    upload_status VARCHAR(50),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Insert Queries When validation succeeds

INSERT INTO file_validation_log 
(file_name, file_size, file_type, validation_status)
VALUES 
('data1.csv', 2048, 'csv', 'VALID');

When validation fail

INSERT INTO file_validation_log 
(file_name, file_size, file_type, validation_status)
VALUES 
('malware.exe', 1024, 'exe', 'QUARANTINE');

Select Queries View all logs
SELECT * FROM file_validation_log;

View only failed files
SELECT * FROM file_validation_log
WHERE validation_status = 'QUARANTINE';

Count valid files
SELECT COUNT(*) FROM file_validation_log
WHERE validation_status = 'VALID';
