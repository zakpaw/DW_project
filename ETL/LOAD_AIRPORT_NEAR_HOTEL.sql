USE Agency_DW

go

CREATE VIEW HotelAirportTemps 
AS SELECT
	DW1.hotel_ID,
	DW2.airport_ID,
	DB1.distance,
	DB1.travel_time AS 'travelled_time'
	FROM AgencyData.dbo.AirportNearHotel AS DB1
	JOIN AgencyData.dbo.Hotel AS DB2 ON DB1.hotel_ID = DB2.hotel_ID
	JOIN AgencyData.dbo.Airport AS DB3 ON DB1.airport_ID = DB3.airport_ID
	JOIN Hotel AS DW1 ON DW1.hotel_name = DB2.name
	JOIN DestinationAirport AS DW2 ON DB3.airport_name = DW2.airport_name;
GO


MERGE INTO AirportNearHotel as TT
	USING HotelAirportTemps as ST
		ON TT.distance = ST.distance
			AND TT.travelled_time = ST.travelled_time
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.hotel_ID,
					ST.airport_ID,
					ST.distance,
					ST.travelled_time
					);

DROP VIEW HotelAirportTemps;