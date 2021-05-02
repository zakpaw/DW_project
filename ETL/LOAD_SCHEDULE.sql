CREATE TABLE TripScheduling(
	flight_ID INT REFERENCES Flights,
	employee_ID INT REFERENCES Employee,
	hotel_ID INT REFERENCES Hotel,
	creation_date_ID INT REFERENCES Date,
	creation_time_ID INT REFERENCES Time,
	hotel_start_date_ID INT REFERENCES Date,--
	hotel_end_date_ID INT REFERENCES Date,--
	hotel_start_time_ID INT REFERENCES Time,
	hotel_end_time_ID INT REFERENCES Time,
	transaction_NO INT,
	hotel_cost MONEY, --
	client_price MONEY,
	profit MONEY,
	OTW INT, --
	PRIMARY KEY(flight_ID, employee_ID, hotel_ID, creation_date_ID, creation_time_ID, hotel_start_date_ID, hotel_end_date_ID, hotel_start_time_ID, hotel_end_time_ID)
);

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
-- Nie mamy creation time w Paradise tylko creation date i chyba trzeba to time wywaliæi mieæ nadziejê, zê debil siê nie skapnie
USE Agency_DW


CREATE VIEW HotelStartTemps
AS SELECT
	DW1.time_ID AS 'hotel_start_time_ID',
	DW2.date_ID AS 'hotel_start_date_ID',
	DW2.date,
	DB2.price AS 'hotel_cost',
	DB1.offer_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN Time AS DW1 ON DW1.hour = DB3.starting_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.start_date) 	AND DW2.year = YEAR(DB2.start_date) AND DW2.month = DATENAME(month,DB2.start_date)

	SELECT * FROM HotelStartTemps
	ORDER BY offer_ID
	DROP VIEW HotelStartTemps

CREATE VIEW HotelEndTemps
AS SELECT
	DW1.time_ID AS 'hotel_end_time_ID',
	DW2.date_ID AS 'hotel_end_date_ID',
	DB1.offer_ID,
	DB3.name AS 'hotel_name'
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN AgencyData.dbo.Employee AS DB4 ON DB4.ID = DB1.employee_ID 
	JOIN Time AS DW1 ON DW1.hour = DB3.ending_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.end_date) AND DW2.year = YEAR(DB2.end_date) AND DW2.month = DATENAME(month,DB2.end_date)
	
SELECT * FROM HotelEndTemps
ORDER BY offer_ID
DROP VIEW HotelEndTemps


CREATE VIEW EmployeeScheduleTemp
AS SELECT 
	DB1.employee_ID,
	[name_surname] = Cast([empName] + ' ' + [empSurname] as nvarchar(128)),
	DB1.offer_ID,
	V1.PESEL
	FROM AgencyData.dbo.ParadiseOffer AS DB1
	JOIN EmployeesTemp AS V1 ON V1.employeeID = DB1.employee_ID

SELECT * FROM EmployeeScheduleTemp
DROP VIEW EmployeeScheduleTemp

CREATE VIEW SchedulingTemps
AS SELECT
	DW1.employee_ID,
	DW3.hotel_ID,
	DW2.date_ID AS 'creation_date_ID',
	V2.hotel_start_date_ID,
	V3.hotel_end_date_ID,
	V2.hotel_start_time_ID,
	V3.hotel_end_time_ID,
	DB2.transaction_no,
	V2.hotel_cost,
	profit = DB2.amount - V2.hotel_cost,
	DB1.OTW,
	DB1.offer_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1
	JOIN EmployeeScheduleTemp AS V1 ON V1.employee_ID = DB1.employee_ID 
	JOIN HotelStartTemps AS V2 ON V2.offer_ID = DB1.offer_ID
	JOIN HotelEndTemps AS V3 ON V3.offer_ID = DB1.offer_ID
	JOIN AgencyData.dbo.Payment AS DB2 ON DB2.offer_ID = DB1.offer_ID
	JOIN Employee AS DW1 ON DW1.name_surname = V1.name_surname
	JOIN Date AS DW2 ON DW2.date = DAY(DB1.creation_date) AND DW2.year = YEAR(DB1.creation_date) AND DW2.month = DATENAME(month,DB1.creation_date)
	JOIN Time AS DW4 ON DW4.hour = DB1.creation_time AND DW4.minute = 0
	JOIN Hotel as DW3 ON DW3.hotel_name = V3.hotel_name 

SELECT * FROM SchedulingTemps

DROP VIEW SchedulingTemps
DROP VIEW HotelStartTemps
-- trzeba braæ imiê i nazwisko z  excela
DROP VIEW HotelEndTemps
USE Agency_DW
select * from Employee
select * from EmployeeScheduleTemp
select * from  EmployeesTemp





