CREATE DATABASE hr;
USE hr;
SELECT * FROM hr_analytics;
-- BASIC SQL (1–10)
-- 1. Total number of employees
SELECT COUNT(*) AS total_employees
FROM hr_analytics;
-- 2. Total attrition count
SELECT COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes';
-- 3. Overall attrition rate (%)
SELECT 
ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
) AS attrition_rate
FROM hr_analytics;
-- 4. Employee count by department
SELECT Department, COUNT(*) AS employee_count
FROM hr_analytics
GROUP BY Department;
-- 5. Employee count by job role
SELECT JobRole, COUNT(*) AS employee_count
FROM hr_analytics
GROUP BY JobRole;
-- 6. Employee count by gender
SELECT Gender, COUNT(*) AS employee_count
FROM hr_analytics
GROUP BY Gender;
-- 7. Attrition count by gender
SELECT Gender, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY Gender;
-- 8. Average monthly income
SELECT ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_analytics;
-- 9. Minimum and maximum salary
SELECT 
MIN(MonthlyIncome) AS min_salary,
MAX(MonthlyIncome) AS max_salary
FROM hr_analytics;
-- 10. Employees by education field
SELECT EducationField, COUNT(*) AS employee_count
FROM hr_analytics
GROUP BY EducationField;
-- --------------------------------------------------
-- DASHBOARD-ALIGNED (11–20)
-- 11. Attrition count by job role
SELECT JobRole, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY JobRole;
-- 12. Attrition rate by job role
SELECT 
JobRole,
ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
) AS attrition_rate
FROM hr_analytics
GROUP BY JobRole;
-- 13. Attrition count by age group
SELECT AgeGroup, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY AgeGroup;
-- 14. Attrition by salary slab
SELECT SalarySlab, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY SalarySlab;
-- 15. Avg years at company (attrition)
SELECT ROUND(AVG(YearsAtCompany), 2) AS avg_years
FROM hr_analytics
WHERE Attrition = 'Yes';
-- 16. Attrition by department
SELECT Department, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY Department;
-- 17. Job roles with attrition > 50
SELECT JobRole, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY JobRole
HAVING COUNT(*) > 50;
-- 18. Avg job satisfaction (attrition)
SELECT ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction
FROM hr_analytics
WHERE Attrition = 'Yes';
-- 19. Avg salary: attrition vs non-attrition
SELECT Attrition, ROUND(AVG(MonthlyIncome), 2) AS avg_salary
FROM hr_analytics
GROUP BY Attrition;
-- 20. Attrition by education field
SELECT EducationField, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY EducationField;
-- ---------------------------------------------------
-- INTERMEDIATE (21–30)
-- 21. Tenure category using CASE
SELECT 
EmpID,
CASE 
    WHEN YearsAtCompany < 2 THEN 'Early'
    WHEN YearsAtCompany BETWEEN 2 AND 5 THEN 'Mid'
    ELSE 'Late'
END AS tenure_category
FROM hr_analytics;
-- 22. Attrition by tenure category
SELECT tenure_category, COUNT(*) AS attrition_count
FROM (
    SELECT 
    CASE 
        WHEN YearsAtCompany < 2 THEN 'Early'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN 'Mid'
        ELSE 'Late'
    END AS tenure_category,
    Attrition
    FROM hr_analytics
) t
WHERE Attrition = 'Yes'
GROUP BY tenure_category;
-- 23. Early attrition (≤ 2 years)
SELECT COUNT(*) AS early_attrition
FROM hr_analytics
WHERE Attrition = 'Yes' AND YearsAtCompany <= 2;
-- 24. Attrition rate (JobSatisfaction ≤ 2)
SELECT 
ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
) AS attrition_rate
FROM hr_analytics
WHERE JobSatisfaction <= 2;
-- 25. Attrition: overtime vs non-overtime
SELECT OverTime, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY OverTime;
-- 26. Attrition by marital status
SELECT MaritalStatus, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY MaritalStatus;
-- 27. Attrition by business travel
SELECT BusinessTravel, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY BusinessTravel;
-- 28. Job roles with lowest job satisfaction
SELECT JobRole, ROUND(AVG(JobSatisfaction), 2) AS avg_satisfaction
FROM hr_analytics
GROUP BY JobRole
ORDER BY avg_satisfaction ASC;
-- 29. Avg distance from home (attrition)
SELECT ROUND(AVG(DistanceFromHome), 2) AS avg_distance
FROM hr_analytics
WHERE Attrition = 'Yes';
-- 30. Attrition by work-life balance
SELECT WorkLifeBalance, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY WorkLifeBalance;
-- ---------------------------------------------------
-- ADVANCED (31–40)
-- 31. Employees below company avg salary
SELECT *
FROM hr_analytics
WHERE MonthlyIncome < (SELECT AVG(MonthlyIncome) FROM hr_employee);
-- 32. Attrition rate (below avg salary)
SELECT 
ROUND(
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2
) AS attrition_rate
FROM hr_analytics
WHERE MonthlyIncome < (SELECT AVG(MonthlyIncome) FROM hr_employee);
-- 33. Job roles with above-average attrition
SELECT JobRole
FROM hr_analytics
GROUP BY JobRole
HAVING 
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*) >
(
    SELECT 
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*)
    FROM hr_analytics
);
-- 34. Rank job roles by attrition
SELECT JobRole, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY attrition_count DESC;
-- 35. Top 3 salary slabs (attrition)
SELECT SalarySlab, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY SalarySlab
ORDER BY attrition_count DESC
LIMIT 3;
-- 36. Employees earning less than role average
SELECT e.*
FROM hr_analytics e
JOIN (
    SELECT JobRole, AVG(MonthlyIncome) AS avg_salary
    FROM hr_analytics
    GROUP BY JobRole
) r
ON e.JobRole = r.JobRole
WHERE e.MonthlyIncome < r.avg_salary;
-- 37. Attrition: ≤3 vs >3 years
SELECT 
CASE 
    WHEN YearsAtCompany <= 3 THEN '≤3 Years'
    ELSE '>3 Years'
END AS tenure_group,
COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY tenure_group;
-- 38. Departments with high attrition rate
SELECT Department
FROM hr_analytics
GROUP BY Department
HAVING 
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*) >
(
    SELECT 
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*)
    FROM hr_analytics
);
-- 39. Cumulative attrition by years
SELECT YearsAtCompany, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;
-- 40. Job satisfaction vs attrition
SELECT JobSatisfaction, COUNT(*) AS attrition_count
FROM hr_analytics
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction;