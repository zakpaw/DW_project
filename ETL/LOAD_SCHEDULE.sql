USE Agency_DW
GO

CREATE VIEW StartFlights
    AS SELECT DISTINCT
        CASE WHEN F.date > F2.date THEN  F2.flight_NO
            ELSE F.flight_NO END as flight_NO,
        CASE WHEN F.date > F2.date THEN  F2.paradise_offer_id
            ELSE F.paradise_offer_id END as 'paradise_offer'
    FROM AgencyData.dbo.Flight AS F
    JOIN AgencyData.dbo.Flight AS F2 ON F.paradise_offer_id = F2.paradise_offer_id
    WHERE F.flight_NO <> F2.flight_NO;

CREATE VIEW HotelStartTemps
AS SELECT
	DW1.time_ID AS 'hotel_start_time_ID',
	DW2.date_ID AS 'hotel_start_date_ID',
	DW2.date,
	DB2.price AS 'hotel_cost',
	DB1.offer_ID,
	DB4.arrival_time - DB4.departure_time AS 'flight_duration',
	DB4.cost * 2 AS 'cost',
	DB5.discount
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN Time AS DW1 ON DW1.hour = DB3.starting_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.start_date) 	AND DW2.year = YEAR(DB2.start_date) AND DW2.month = DATENAME(month,DB2.start_date)
	JOIN StartFlights AS V1 ON V1.paradise_offer = DB1.offer_ID
	JOIN AgencyData.dbo.Flight AS DB4 ON DB4.flight_NO = V1.flight_NO
	JOIN AgencyData.dbo.Airline AS DB5 ON DB5.ID = DB4.airline_ID;


If (object_id('dbo.EmpTemp') is not null) DROP TABLE dbo.EmployeesTemp;
CREATE TABLE dbo.EmpTemp(agencyID VARCHAR(255) , employeeID VARCHAR(255), PESEL VARCHAR(15), empName varchar(255), 
								empSurname varchar(255), birthDate date, education varchar(255),
								startWorkDate date, endWorkDate date, tripsSold int);
go

BULK INSERT dbo.EmpTemp
    FROM '/home/db/data/data_Agency_Network_Excel0.csv'
 WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

CREATE VIEW HotelEndTemps
AS SELECT
	DW1.time_ID AS 'hotel_end_time_ID',
	DW2.date_ID AS 'hotel_end_date_ID',
	DB1.offer_ID,
	DB3.name AS 'hotel_name',
	[name_surname] = Cast([empName] + ' ' + [empSurname] as nvarchar(128)),
	DB4.PESEL
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN EmpTemp AS DB4 ON DB4.employeeID = DB1.employee_ID 
	JOIN Time AS DW1 ON DW1.hour = DB3.ending_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.end_date) 
		AND DW2.year = YEAR(DB2.end_date) 
		AND DW2.month = DATENAME(month,DB2.end_date);

SELECT * FROM HotelEndTemps
ORDER BY offer_ID


CREATE VIEW SchedulingTemps
AS SELECT
	DW5.flight_ID,
	DW1.employee_ID,
	DW3.hotel_ID,
	DW2.date_ID AS 'creation_date_ID',
	DW4.time_ID AS 'creation_time_ID',
	V2.hotel_start_date_ID,
	V3.hotel_end_date_ID,
	V2.hotel_start_time_ID,
	V3.hotel_end_time_ID,
	DB2.transaction_no,
	V2.hotel_cost,
	DB2.amount AS 'client_price',
	profit = DB2.amount - V2.hotel_cost,
	DB1.OTW,
	DB1.offer_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1
	JOIN HotelStartTemps AS V2 ON V2.offer_ID = DB1.offer_ID
	JOIN HotelEndTemps AS V3 ON V3.offer_ID = DB1.offer_ID
	JOIN AgencyData.dbo.Payment AS DB2 ON DB2.offer_ID = DB1.offer_ID
	JOIN Employee AS DW1 ON DW1.PESEL = V3.PESEL
	JOIN Date AS DW2 ON DW2.date = DAY(DB1.creation_date) AND DW2.year = YEAR(DB1.creation_date) AND DW2.month = DATENAME(month,DB1.creation_date)
	JOIN Time AS DW4 ON DW4.hour = DB1.creation_time AND DW4.minute = 0
	JOIN Hotel as DW3 ON DW3.hotel_name = V3.hotel_name 
	JOIN Flights AS DW5 ON DW5.cost = V2.cost AND DW5.flight_duration = V2.flight_duration AND DW5.airline_discount = V2.discount;


MERGE INTO TripScheduling as TT
	USING SchedulingTemps as ST
		ON 
	TT.flight_ID = ST.flight_ID and
	TT.employee_ID = ST.employee_ID AND
	TT.hotel_ID = ST.hotel_ID AND
	TT.creation_date_ID = ST.creation_date_ID AND
	TT.creation_time_ID = ST.creation_time_ID AND
	TT.hotel_start_date_ID = ST.hotel_start_date_ID AND
	TT.hotel_end_date_ID = ST.hotel_end_date_ID AND
	TT.hotel_start_time_ID = ST.hotel_start_time_ID AND
	TT.hotel_end_time_ID = ST.hotel_end_time_ID AND
	TT.transaction_no = ST.transaction_no AND
	TT.client_price = ST.client_price AND
	TT.hotel_cost = ST.hotel_cost AND
	TT.profit = ST. profit AND
	TT.OTW = ST.OTW 
			WHEN Not Matched
				THEN
					INSERT (flight_ID, employee_ID, hotel_ID, creation_date_ID, creation_time_ID, hotel_start_date_ID, hotel_end_date_ID, hotel_start_time_ID, hotel_end_time_ID, transaction_no, client_price, hotel_cost, profit, OTW )
					VALUES ( 
					ST.flight_ID,
					ST.employee_ID,
					ST.hotel_ID,
					ST.creation_date_ID,
					ST.creation_time_ID,
					ST.hotel_start_date_ID,
					ST.hotel_end_date_ID,
					ST.hotel_start_time_ID,
					ST.hotel_end_time_ID,
					ST.transaction_no,
					ST.client_price,
					ST.hotel_cost,
					ST. profit,
					ST.OTW );

SELECT * FROM SchedulingTemps
ORDER BY creation_time_ID
DROP VIEW HotelStartTemps;
DROP VIEW HotelEndTemps;
DROP VIEW SchedulingTemps;
DROP VIEW StartFlights;

SELECT * FROM TripScheduling

