use balaji_supermarket;

create schema datestudent;

DROP TABLE if exists datestudent.student;
CREATE TABLE datestudent.student
(
	student_id int not null identity(1,1),
	student_name varchar(20) not null,
	admitted_date datetime,
	leaving_date datetime
)
GO

ALTER TABLE datestudent.student 
ADD CONSTRAINT pk_datestudent_student_student_id 
PRIMARY KEY(student_id);

INSERT INTO datestudent.student(student_name,admitted_date,leaving_date)
SELECT 'Varun' studnet_name,10-06-2022 admitted_date,10-06-2025 union all
SELECT 'Nithya',22-05-2021,25-06-2024 union all
SELECT 'Sathya',10-11-2020,10-11-2023;

SELECT * FROM datestudent.student;





SELECT SYSDATETIME();
SELECT getdate();
SELECT SYSDATETIMEOFFSET();
SELECT SYSUTCDATETIME();
SELECT CURRENT_TIMESTAMP;
SELECT GETUTCDATE();

SELECT DATENAME(YEAR, GETDATE()) AS 'year';
SELECT DATENAME(QUARTER, GETDATE())AS QUARTER;
SELECT DATENAME(MONTH, GETDATE()) AS 'month';
SELECT DATENAME(HOUR, GETDATE()) AS 'hour';
SELECT DATENAME(DAYOFYEAR, GETDATE())   AS 'DayOfYear';  
SELECT DATENAME(WEEK, GETDATE()) AS 'Week';    
SELECT DATENAME(ISO_WEEK, GETDATE()) AS 'Week';

SELECT DAY(GETDATE()) AS 'DAY'
SELECT MONTH(GETDATE()) AS 'MONTH'
SELECT YEAR(GETDATE()) AS 'YEAR'

SELECT DATEFROMPARTS(2025,5,8) AS 'DATE';

DATEADD
 