USE Agency_DW
GO


If (object_id('dbo.AgencyTemp') is not null) DROP TABLE dbo.AgencyTemp;
CREATE TABLE dbo.AgencyTemp(agencyID varchar(300), agencyName varchar(300), AgencyeAddress varchar(300), zipcode varchar(7), city varchar(200), telephone varchar(20), email varchar(300));
go

BULK INSERT dbo.AgencyTemp
FROM '/home/db/data/data_Agency_Excel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

If (object_id('dbo.EmployeesTemp') is not null) DROP TABLE dbo.EmployeesTemp;
CREATE TABLE dbo.EmployeesTemp(agencyID VARCHAR(255) , employeeID VARCHAR(255), PESEL VARCHAR(15), empName varchar(255), 
								empSurname varchar(255), birthDate date, education varchar(255),
								startWorkDate date, endWorkDate date, tripsSold int);
go

BULK INSERT dbo.EmployeesTemp
    FROM '/home/db/data/data_Agency_Network_Excel0.csv'
 WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

-- SELECT * FROM EmployeesTemp
-- ORDER BY PESEL

If (object_id('ETLEmployeeData') is not null) Drop View ETLEmployeeData;
go
CREATE VIEW ETLEmployeeData
AS
SELECT 
	t3.[agency_ID], 
	t1.[PESEL],
	[NameAndSurname] = Cast([empName] + ' ' + [empSurname] as nvarchar(128)),
	CASE
		WHEN DATEDIFF(year, [startWorkDate], isNull([endWorkDate], CURRENT_TIMESTAMP)) <=1 THEN 'up to one year'
		WHEN DATEDIFF(year, [startWorkDate], isNull([endWorkDate], CURRENT_TIMESTAMP)) BETWEEN 1 AND 5 THEN 'between one and five years'
		ELSE 'more than five years'
	END AS [Seniority],
	t1.[Education]
FROM EmployeesTemp as t1
JOIN AgencyTemp as t2 ON t1.agencyID = t2.agencyID
JOIN TravelAgency as t3 ON t2.agencyName = t3.agency_name 
;
go

MERGE INTO Employee as TT
	USING ETLEmployeeData as ST
		ON TT.PESEL = ST.PESEL
			WHEN Not Matched
				THEN
					INSERT (travel_agency_ID,PESEL,name_surname,education,seniority,is_active) Values (
					ST.agency_ID,
					ST.PESEL,
					ST.NameAndSurname,
					ST.Education,
					ST.Seniority ,
					1				
					)
			WHEN Matched
				AND (ST.agency_ID <> TT.travel_agency_ID
				OR ST.NameAndSurname <> TT.name_surname
				OR ST.Seniority <> TT.Seniority
				OR ST.Education <> TT.Education)
			THEN
				UPDATE
				SET TT.is_active = 0
			WHEN Not Matched BY Source
			AND TT.PESEL != 'UNKNOWN'
			THEN
				UPDATE
				SET TT.is_active = 0
			;

-- INSERTING CHANGED ROWS TO THE DIMSELLER TABLE
INSERT INTO Employee(
	travel_agency_ID,
	PESEL, 
	name_surname,
	Education, 
	seniority, 
	is_active
	)
	SELECT 
		agency_ID, 
		PESEL, 
		NameAndSurname, 
		Education, 
		seniority,
		1
			
	FROM ETLEmployeeData
	EXCEPT
	SELECT 
		travel_agency_ID, 
		PESEL, 
		name_surname, 
		Education, 
		seniority,
		is_active
	FROM Employee;

--UPDATE Agency_DW.dbo.Employee 
--SET PESEL = '01234566781'
--WHERE PESEL = 90280325631;

-- SELECT * FROM Employee
-- ORDER BY name_surname
-- DELETE FROM Employee
DROP TABLE dbo.AgencyTemp;
DROP TABLE dbo.EmployeesTemp;
Drop VIEW ETLEmployeeData; 

