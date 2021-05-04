USE Agency_DW

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
	JOIN Date AS DW2 ON DW2.date = DAY(DB2.end_date) 
		AND DW2.year = YEAR(DB2.end_date) 
		AND DW2.month = DATENAME(month,DB2.end_date);

CREATE VIEW EmployeeScheduleTemp
AS SELECT 
	DB1.employee_ID,
	[name_surname] = Cast([name] + ' ' + [surname] as nvarchar(128)),
	DB1.offer_ID
	FROM AgencyData.dbo.ParadiseOffer AS DB1
	JOIN AgencyData.dbo.Employee AS DB2 ON DB2.ID = DB1.employee_ID;


CREATE VIEW SchedulingTemps
AS SELECT
	DW5.flight_ID,
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
	JOIN Flights AS DW5 ON DW5.cost = V2.cost AND DW5.flight_duration = V2.flight_duration; --AND DW5.airline_discount = V2.discount 

DROP VIEW HotelStartTemps;
DROP VIEW HotelEndTemps;
DROP VIEW EmployeeScheduleTemp;
DROP VIEW SchedulingTemps;
DROP VIEW StartFlights;




