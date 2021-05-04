USE Agency_DW


If (object_id('DestinationTemp') is not null) Drop view DestinationTemp;
go

CREATE VIEW DestinationTemp
AS 
SELECT DISTINCT
	DW2.airline_ID,
	DW1.airport_ID AS 'destination_airport_ID',
	DW3.time_ID AS 'flight_departure_start_ID',
	DB4.discount AS 'airline_discount',
	DB3.arrival_time - DB3.departure_time AS 'flight_duration',
	DB3.paradise_offer_id,
	DB3.cost AS 'flight_cost'
FROM AgencyData.dbo.Airport AS DB1 
JOIN AgencyData.dbo.TravelBetween AS DB2 ON DB2.airport_ID = DB1.airport_ID
JOIN DestinationAirport AS DW1 ON DW1.airport_name = DB1.airport_name
JOIN AgencyData.dbo.Flight AS DB3 ON DB3.flight_NO = DB2.flight_NO
JOIN AgencyData.dbo.Airline AS DB4 ON DB4.ID = DB3.airline_ID
JOIN Airline AS DW2 ON DB4.name = DW2.airline_name
JOIN Time AS DW3 ON DB3.departure_time = DW3.hour AND DW3.minute = 0;
GO

If (object_id('FlightsTemp') is not null) Drop view FlightsTemp;
go
CREATE VIEW FlightsTemp
AS SELECT 
	V1.airline_ID,
	DW1.airport_ID AS 'local_airport_ID',
	V1.destination_airport_ID,
	V1.flight_departure_start_ID,
	DW2.time_ID AS 'flight_departure_end_ID',
	V1.flight_duration,
	V1.flight_cost * 2 AS 'cost',
	V1.airline_discount
	FROM AgencyData.dbo.ParadiseOffer AS DB1 
	JOIN DestinationTemp AS V1 ON DB1.offer_ID = V1.paradise_offer_id
	JOIN AgencyData.dbo.Flight AS DB2 ON DB2.paradise_offer_id = DB1.offer_ID
	JOIN AgencyData.dbo.TravelBetween AS DB3 ON DB3.flight_NO = DB2.flight_NO
	JOIN AgencyData.dbo.Airport AS DB4 ON DB4.airport_ID = DB3.airport_ID
	JOIN LocalAirport AS DW1 ON DW1.airport_name = DB4.airport_name 
		AND DW1.airport_ID <> V1.destination_airport_ID
	JOIN Time AS DW2 ON DW2.hour = DB2.departure_time AND DW2.minute = 0
GO
		
MERGE INTO Flights as TT
	USING FlightsTemp as ST
		ON 
		TT.airline_ID = ST.airline_ID AND
		TT.local_airport_ID = ST.local_airport_ID AND 
		TT.destination_airport_ID = ST.destination_airport_ID AND
		TT.flight_departure_start_ID = ST.flight_departure_start_ID AND
		TT.flight_departure_end_ID = ST.flight_departure_end_ID AND
		TT.flight_duration = ST.flight_duration AND 
		TT.cost = ST.cost AND 
		TT.airline_discount = ST.airline_discount
			WHEN Not Matched
				THEN
					INSERT (airline_ID, local_airport_ID, destination_airport_ID, flight_departure_start_ID, flight_departure_end_ID, flight_duration, cost, airline_discount)
					VALUES ( 
					ST.airline_ID,
					ST.local_airport_ID,
					ST.destination_airport_ID,
					ST.flight_departure_start_ID,
					ST.flight_departure_end_ID,
					ST.flight_duration,
					ST.cost,
					ST.airline_discount
					);

DROP VIEW DestinationTemp;
DROP VIEW FlightsTemp;
