SELECT * FROM hr LIMIT 5;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS number
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY gender;


-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS number
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY race
ORDER BY number DESC;


-- 3. What is the age distribution of employees in the company?
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE termdate is null or termdate >= curdate();

SELECT 
  CASE 
    WHEN age >= 20 AND age <= 29 THEN '20s'
    WHEN age >= 30 AND age <= 39 THEN '30s'
    WHEN age >= 40 AND age <= 49 THEN '40s'
    ELSE '50s' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  termdate is null or termdate >= curdate()
GROUP BY age_group
ORDER BY age_group;


-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) as count
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY location;


-- 5. What is the average length of employment for employees who have been terminated?
SELECT CONCAT(ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0), ' years') AS avg_length_of_employment
FROM hr
WHERE termdate is not null AND termdate <= CURDATE();


-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) as number
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY department, gender
ORDER BY department;


-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) as number
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY jobtitle
ORDER BY jobtitle DESC;


-- 8. Which department has the highest turnover rate?
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate is not null THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate is null THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() AND termdate is not null THEN 1 ELSE 0 END) / COUNT(*) * 100) as "termination_rate(%)"
FROM hr
GROUP BY department
ORDER BY "termination_rate(%)" DESC;


-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) as number
FROM hr
WHERE termdate is null or termdate >= curdate()
GROUP BY location_state
ORDER BY number DESC;


-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS percent_net_change
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate is not null AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM 
        hr
    GROUP BY 
        YEAR(hire_date)
) subquery
ORDER BY 
    year ASC;
    
    
-- 11. What is the tenure distribution for each department?
SELECT department, CONCAT(ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0), ' years') AS avg_length_of_employment
FROM hr
WHERE termdate is not null AND termdate <= CURDATE()
GROUP BY department;

