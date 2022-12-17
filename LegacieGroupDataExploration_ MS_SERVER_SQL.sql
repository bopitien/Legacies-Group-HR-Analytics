/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Employee_Name]
      ,[EmpID]
      ,[Position]
      ,[DOB]
      ,[Sex]
      ,[MaritalDesc]
      ,[CitizenDesc]
      ,[RaceDesc]
      ,[DateofHire]
      ,[DateofTermination]
      ,[TermReason]
      ,[EmploymentStatus]
      ,[Department]
      ,[ManagerName]
      ,[ManagerID]
      ,[RecruitmentSource]
      ,[PerformanceScore]
      ,[EngagementSurvey]
      ,[EmpSatisfaction]
      ,[LastPerformanceReview_Date]
      ,[Absences]
  FROM [Legaciegroup Database].[dbo].[Legacies]

  SELECT *
   FROM [Legaciegroup Database].[dbo].[Legacies]

   --Change M and F abbrevations into Male and Female 
 
 UPDATE Legacies
 SET Sex = 
	CASE 
       WHEN Sex = 'M' THEN 'Male'
       WHEN Sex = 'F' THEN 'Female'
       END
  FROM [Legaciegroup Database].[dbo].[Legacies]


  --Name the following columns apprioprately  marital status ,dob,empsatisfaction,Racedesc,citizendesc

  sp_rename 'legacies.MaritalDesc', 'MaritalStatus', 'COLUMN';

  sp_rename 'legacies.DOB', 'DateOfBirth', 'COLUMN';

  sp_rename 'legacies.empsatisfaction', 'employee_satisfaction', 'COLUMN';

  sp_rename 'legacies.RaceDesc', 'Race', 'COLUMN';

  sp_rename 'legacies.CitizenDesc', 'Citizenship', 'COLUMN';


--  Descriptive Analytics

--1. What is the total number of employees
SELECT COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies




--2. What position has the highest and lowest number of employees

SELECT TOP 1 position , COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY Position
ORDER BY Total_Employees DESC



SELECT TOP 1 position , COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY Position
ORDER BY Total_Employees ASC

--3. Calculate the age of each employee from their DOB


SELECT dateofbirth , DATEDIFF(YEAR,dateofbirth,GETDATE()) as Age
FROM [Legaciegroup Database].dbo.Legacies


--4. Group Employee age in to 5 categories (20 – 29, 30 – 39, 40-49, 50-59, >60). What age group has the highest and lowest employees

CREATE VIEW legacieviewtable AS 
(SELECT dateofbirth , DATEDIFF(YEAR,dateofbirth,GETDATE()) as Age FROM [Legaciegroup Database].dbo.Legacies)



SELECT dateofbirth , Age ,
 
      CASE
	WHEN Age <=29 THEN  'youth'
	WHEN Age <=39 THEN  'Early Adult'
	WHEN Age <=49 THEN  'Middle Aged'
	WHEN Age <=59 THEN  'Elderly'
	WHEN Age > 60 THEN  'Aged'
	
	END AS AgeCategories

FROM legacieviewtable

--OR another way to get it done is to create a column AGE AND AGE GROUP  and populatE  with the case statement 

ALTER TABLE legacies
ADD Age INT

UPDATE legacies
SET Age = DATEDIFF(YEAR,dateofbirth,GETDATE()) ;
-------------------------------------------------------------------------------------------------------
ALTER TABLE legacies
ADD Agegroup varchar(100)

UPDATE legacies
SET Agegroup = 
  CASE
	WHEN DATEDIFF(YEAR,dateofbirth,GETDATE()) <=29 THEN  'youth'
	WHEN DATEDIFF(YEAR,dateofbirth,GETDATE()) <=39 THEN  'Early Adult'
	WHEN DATEDIFF(YEAR,dateofbirth,GETDATE()) <=49 THEN  'Middle Aged'
	WHEN DATEDIFF(YEAR,dateofbirth,GETDATE()) <=59 THEN  'Elderly'
	WHEN DATEDIFF(YEAR,dateofbirth,GETDATE()) > 60 THEN  'Aged'
END ;
-------------------------------------------------------------------------------------------------------

SELECT dateofbirth , age, agegroup
FROM [Legaciegroup Database].dbo.Legacies



--5. What is the proportion of male and female employees?

SELECT sex,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY Sex



--6. What is the total number of employee in each marital Status?


SELECT Maritalstatus,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY Maritalstatus
ORDER BY Total_Employees DESC 


--7. What are the unique citizen description and the total number of 
--employees?

SELECT citizenship,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY citizenship
ORDER BY Total_Employees DESC




--8. What are the unique race and the total number of employees?


SELECT Race,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY Race
ORDER BY Total_Employees DESC

--9. Calculate the length of service using the Hire date. What is the min and max length of service?



--add new column lengthofsservice and populate the column

ALTER TABLE legacies
ADD lengthofsevice INT ;


UPDATE legacies
SET lengthofsevice = CASE
		WHEN DateofTermination IS NULL THEN DATEDIFF(YEAR,DateofHire,GETDATE())
		WHEN DateofTermination IS NOT NULL THEN DATEDIFF(YEAR,DateofHire,DateofTermination)
 END 
FROM [Legaciegroup Database].dbo.Legacies  ;


--min and max length of service?

SELECT MIN(lengthofsevice) AS minimum_lengthofsevice , MAX(lengthofsevice) AS maximum_lengthofsevice
FROM [Legaciegroup Database].DBO.Legacies
WHERE lengthofsevice <> 0





--10. What recruitment source brought in the most employees?



SELECT TOP 1 RecruitmentSource,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY RecruitmentSource
ORDER BY Total_Employees DESC




--11. What is the proportion of employees across all performance Score

SELECT PerformanceScore,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY PerformanceScore
ORDER BY Total_Employees desc

--12. What is the average employee satisfaction 

SELECT AVG(employee_satisfaction )AS Average_employee_satisfaction 
FROM [Legaciegroup Database].dbo.Legacies

--13. What is the average employee engagement
SELECT AVG(EngagementSurvey )AS Average_employee_engagementSurvey
FROM [Legaciegroup Database].dbo.Legacies




--Tailored Data Analytics

--1. What is the proportion of employee in each employment status


SELECT EmploymentStatus,COUNT(empid) as Total_Employees
FROM [Legaciegroup Database].dbo.Legacies
GROUP BY EmploymentStatus
ORDER BY Total_Employees desc



--2. Calculate the length of service of each employee using the Hire date. What is the Minimum and Maximum length of service

SELECT Employee_Name, lengthofsevice 
FROM [Legaciegroup Database].DBO.Legacies
ORDER BY lengthofsevice DESC


SELECT MIN(lengthofsevice) AS minimum_lengthofsevice , MAX(lengthofsevice) AS maximum_lengthofsevice
FROM [Legaciegroup Database].DBO.Legacies
WHERE lengthofsevice <> 0


--3. Calculate how many years employee stay before leaving? What is average number of years?

SELECT employee_name, DATEDIFF(YEAR,DateofHire,DateofTermination) AS NoOfYearsStayed
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL ;


--What is average number of years?

SELECT AVG(NoOfYearsStayed) FROM (SELECT employee_name, DATEDIFF(YEAR,DateofHire,DateofTermination) AS NoOfYearsStayed
FROM [Legaciegroup Database].dbo.Legacies WHERE DateofTermination IS NOT NULL ) AS average_years_stayed

   --OR ALTERNATIVELY  


CREATE VIEW oldemployees AS (SELECT employee_name, DATEDIFF(YEAR,DateofHire,DateofTermination) AS NoOfYearsStayed
FROM [Legaciegroup Database].dbo.Legacies WHERE DateofTermination IS NOT NULL)

SELECT AVG(NoOfYearsStayed) AS average_years_stayed  FROM oldemployees


--4. What is the main reason for people terminating their contract?


SELECT TOP 1 termreason , COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY termreason
ORDER BY Terminated_Employee DESC



--5. What department has the highest terminated employee?



SELECT TOP 1 Department , COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Department
ORDER BY Terminated_Employee DESC


--6. What is the split of terminated employee by Gender?

SELECT Sex , COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Sex
ORDER BY Terminated_Employee DESC

--7. What is the split of terminated employee by age group?



SELECT Agegroup, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Agegroup
ORDER BY Terminated_Employee DESC


--8. What is the split of terminated employee by Citizen Description?

SELECT citizenship, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY citizenship
ORDER BY Terminated_Employee DESC

--9. What is the split of terminated employee by Race Description?

SELECT Race, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Race
ORDER BY Terminated_Employee DESC

--10. What is the split of terminated employee by recruitment source?


SELECT RecruitmentSource, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY RecruitmentSource
ORDER BY Terminated_Employee DESC

--11. What is the split of terminated employee by performance score?

SELECT PerformanceScore, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY PerformanceScore
ORDER BY Terminated_Employee DESC


--12. What is the split of terminated employee by Engagement?


SELECT EngagementSurvey, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY EngagementSurvey
ORDER BY Terminated_Employee DESC

--13. What is the split of terminated employee by Satisfaction?

SELECT employee_satisfaction, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY employee_satisfaction
ORDER BY Terminated_Employee DESC

--14. What is the split of terminated employee by Department?

SELECT Department, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Department
ORDER BY Terminated_Employee DESC

--15. What is the split of terminated employee by Marital Status?SELECT Maritalstatus, COUNT(empid) AS Terminated_Employee
FROM [Legaciegroup Database].dbo.Legacies
WHERE DateofTermination IS NOT NULL
GROUP BY Maritalstatus
ORDER BY Terminated_Employee DESC