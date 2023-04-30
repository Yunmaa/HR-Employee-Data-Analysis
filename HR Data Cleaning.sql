CREATE DATABASE hrproject;

USE hrproject;

SELECT *
FROM hr;

-- Renaming the id column to remove the special characters
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- To check the data types of each column
DESCRIBE hr;

SELECT birthdate
FROM hr;

-- First, turn off the safe mode to allow for updating of the table, which will be changed back to 1 after the data cleaning
SET sql_safe_updates = 0;

-- To change the date columns from text to date format and make all uniform
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

SELECT termdate
FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


-- To create an age column
ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*)
FROM hr
WHERE age < 18;