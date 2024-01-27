USE Glassdoor_Job_Postings
GO

--1. What are the top 5 companies with the highest overall ratings?
SELECT TOP 5 company, company_rating FROM Glassdoor_Job_Postings ORDER BY company_rating DESC;

--2. What is the average salary for each employment type?
SELECT employment_type, AVG(salary_avg_estimate) AS average_salary FROM Glassdoor_Job_Postings GROUP BY employment_type;

--3. Which industry has the highest average company rating?
SELECT industry, AVG(company_rating) AS average_rating FROM Glassdoor_Job_Postings GROUP BY industry
ORDER BY average_rating DESC;

--4. How does the average company rating correlate with the size of the company?
SELECT company_size, AVG(company_rating) AS average_rating FROM Glassdoor_Job_Postings GROUP BY company_size ORDER BY average_rating DESC;

--5. What is the distribution of job titles in the dataset?
SELECT job_title, COUNT(*) AS job_count FROM Glassdoor_Job_Postings GROUP BY job_title ORDER BY job_count DESC;

--6. What is the average company rating and work-life balance rating for each location?
SELECT location, AVG(company_rating) AS avg_company_rating, AVG(work_life_balance_rating) AS avg_work_life_balance FROM Glassdoor_Job_Postings
GROUP BY location;

--7. Which companies have the highest average compensation and benefits rating?
SELECT company, AVG(comp_and_benefits_rating) AS avg_comp_benefits_rating FROM Glassdoor_Job_Postings GROUP BY company
ORDER BY avg_comp_benefits_rating DESC;

--8. What is the distribution of employment types within each industry?
SELECT industry, employment_type, COUNT(*) AS employment_count FROM Glassdoor_Job_Postings GROUP BY industry, employment_type
ORDER BY industry, employment_count DESC;

--9. Which companies were founded before the year 2000?
SELECT company, company_founded FROM Glassdoor_Job_Postings WHERE company_founded < 2000;

--10. What is the overall average salary across all job positions?
SELECT AVG(salary_avg_estimate) AS overall_avg_salary FROM Glassdoor_Job_Postings;

--11. For each industry, what is the average company rating, and how does it compare to the overall average company rating?
SELECT industry, AVG(company_rating) AS avg_industry_rating, AVG(company_rating) - (SELECT AVG(company_rating) FROM Glassdoor_Job_Postings) AS rating_difference
FROM Glassdoor_Job_Postings
GROUP BY industry
ORDER BY avg_industry_rating DESC;

--12. What is the average work-life balance rating for companies in each industry, considering only positions with a salary above the overall average salary?
SELECT industry, AVG(work_life_balance_rating) AS avg_work_life_balance FROM Glassdoor_Job_Postings 
WHERE salary_avg_estimate > (SELECT AVG(salary_avg_estimate) FROM Glassdoor_Job_Postings)
GROUP BY industry
ORDER BY avg_work_life_balance DESC;

--13. For companies with a rating above 4.0, what is the distribution of job titles and their average salaries?
SELECT job_title, AVG(salary_avg_estimate) AS avg_salary FROM Glassdoor_Job_Postings WHERE company_rating > 4.0 GROUP BY job_title
ORDER BY avg_salary DESC;

--14. For each employment type, what is the average compensation and benefits rating, and how does it compare to the overall average rating in the dataset?
SELECT employment_type, AVG(comp_and_benefits_rating) AS avg_comp_benefits_rating,
       AVG(comp_and_benefits_rating) - (SELECT AVG(comp_and_benefits_rating) FROM Glassdoor_Job_Postings) AS rating_difference
FROM Glassdoor_Job_Postings
GROUP BY employment_type
ORDER BY avg_comp_benefits_rating DESC;

--15. Which industries have the highest and lowest variability in company ratings (standard deviation)?
SELECT industry, AVG(company_rating) AS avg_rating, STDEV(company_rating) AS rating_deviation FROM Glassdoor_Job_Postings GROUP BY industry
ORDER BY rating_deviation DESC;

--16. For companies founded after 1990, what is the average salary for each industry, and how does it compare to the overall average salary?
SELECT industry, AVG(salary_avg_estimate) AS avg_salary,
AVG(salary_avg_estimate) - (SELECT AVG(salary_avg_estimate) FROM Glassdoor_Job_Postings) AS salary_difference FROM Glassdoor_Job_Postings
WHERE company_founded > 1990
GROUP BY industry
ORDER BY avg_salary DESC;

--17. For each industry, what percentage of companies have a work-life balance rating above the overall average work-life balance rating?
SELECT industry, COUNT(CASE WHEN work_life_balance_rating > avg_rating THEN 1 END) * 100.0 / COUNT(*) AS percentage_above_average
FROM (SELECT industry, work_life_balance_rating, AVG(work_life_balance_rating) OVER () AS avg_rating FROM Glassdoor_Job_Postings) AS subquery
GROUP BY industry;

--18. What is the median salary for each job title in the dataset?
SELECT DISTINCT job_title, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_avg_estimate) OVER (PARTITION BY job_title) AS median_salary
FROM Glassdoor_Job_Postings;