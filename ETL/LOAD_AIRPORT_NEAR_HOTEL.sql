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
	JOIN Hotel AS DW1 ON DW1.hotel_name = DB2.name AND DW1.city = DB2.city AND DW1.country = DB2.country
	JOIN DestinationAirport AS DW2 ON DB3.airport_name = DW2.airport_name AND DW2.city = DB3.city AND DW2.country = DB3.country
GO


MERGE INTO AirportNearHotel as TT
	USING HotelAirportTemps as ST
		ON TT.hotel_ID = ST.hotel_ID AND
		   TT.airport_ID = ST.airport_ID
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
