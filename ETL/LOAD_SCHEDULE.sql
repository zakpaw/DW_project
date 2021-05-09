USE Agency_DW
GO

CREATE VIEW FlightsStartTemps
AS 
SELECT DISTINCT
	DW2.airline_ID,
	DW1.airport_ID AS 'destination_airport_ID',
	DW3.time_ID AS 'flight_departure_start_ID',
	DB3.paradise_offer_id
FROM AgencyData.dbo.Airport AS DB1 
JOIN AgencyData.dbo.TravelBetween AS DB2 ON DB2.airport_ID = DB1.airport_ID
JOIN DestinationAirport AS DW1 ON DW1.airport_name = DB1.airport_name
JOIN AgencyData.dbo.Flight AS DB3 ON DB3.flight_NO = DB2.flight_NO
JOIN AgencyData.dbo.Airline AS DB4 ON DB4.ID = DB3.airline_ID
JOIN Airline AS DW2 ON DB4.name = DW2.airline_name
JOIN Time AS DW3 ON DB3.departure_time = DW3.hour AND DW3.minute = 0;
GO


CREATE VIEW HotelStartTemps
AS SELECT
	DW1.time_ID AS 'hotel_start_time_ID',
	DW2.date_ID AS 'hotel_start_date_ID',
	DW2.date,
	DB2.price AS 'hotel_cost',
	DB1.offer_ID,
	V1.airline_ID,
	V1.destination_airport_ID,
	V1.flight_departure_start_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN Time AS DW1 ON DW1.hour = DB3.starting_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.start_date) 	AND DW2.year = YEAR(DB2.start_date) AND DW2.month = DATENAME(month,DB2.start_date)
	JOIN FlightsStartTemps AS V1 ON V1.paradise_offer_id = DB1.offer_ID
GO

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
GO

CREATE VIEW FlightEndTemps
AS SELECT 
	DW1.airport_ID AS 'local_airport_ID',
	DW2.time_ID AS 'flight_departure_end_ID',
	DB1.offer_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN FlightsStartTemps AS V1 ON DB1.offer_ID = V1.paradise_offer_id
	JOIN AgencyData.dbo.Flight AS DB2 ON DB2.paradise_offer_id = DB1.offer_ID
	JOIN AgencyData.dbo.TravelBetween AS DB3 ON DB3.flight_NO = DB2.flight_NO
	JOIN AgencyData.dbo.Airport AS DB4 ON DB4.airport_ID = DB3.airport_ID
	JOIN LocalAirport AS DW1 ON DW1.airport_name = DB4.airport_name 
		AND DW1.airport_ID <> V1.destination_airport_ID
	JOIN Time AS DW2 ON DW2.hour = DB2.departure_time AND DW2.minute = 0
GO

CREATE VIEW HotelEndTemps
AS SELECT
	DW1.time_ID AS 'hotel_end_time_ID',
	DW2.date_ID AS 'hotel_end_date_ID',
	DB1.offer_ID,
	DB3.name AS 'hotel_name',
	[name_surname] = Cast([empName] + ' ' + [empSurname] as nvarchar(128)),
	DB4.PESEL,
	v1.flight_departure_end_ID,
	V1.local_airport_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN AgencyData.dbo.HotelOffer AS DB2 ON DB2.offer_ID = DB1.hotel_offer_ID
	JOIN AgencyData.dbo.Hotel AS DB3 ON DB3.hotel_ID = DB2.hotel_ID
	JOIN EmpTemp AS DB4 ON DB4.employeeID = DB1.employee_ID 
	JOIN FlightEndTemps AS V1 ON V1.offer_ID = db1.offer_ID
	JOIN Time AS DW1 ON DW1.hour = DB3.ending_hour AND DW1.minute = 0
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.end_date) 
		AND DW2.year = YEAR(DB2.end_date) 
		AND DW2.month = DATENAME(month,DB2.end_date);
GO

CREATE VIEW SchedulingTemps
AS SELECT DISTINCT
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
	JOIN Flights AS DW5 ON DW5.airline_ID = V2.airline_ID AND 
						   DW5.destination_airport_ID = V2.destination_airport_ID AND 
						   DW5.flight_departure_start_ID = V2.flight_departure_start_ID AND
						   DW5.local_airport_ID = V3.local_airport_ID AND
						   DW5.flight_departure_end_ID = V3.flight_departure_end_ID
GO

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
	TT.transaction_no = ST.transaction_no
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

-- SELECT * FROM SchedulingTemps
-- ORDER BY creation_time_ID
DROP VIEW HotelStartTemps;
DROP VIEW HotelEndTemps;
DROP VIEW SchedulingTemps;
DROP TABLE Agency_DW.dbo.EmpTemp;
DROP VIEW FlightsStartTemps;
DROP VIEW FlightEndTemps;
-- SELECT * FROM TripScheduling

