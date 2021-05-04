USE Agency_DW
GO

CREATE VIEW DestinationFlights
    AS SELECT DISTINCT
        CASE WHEN F.date > F2.date THEN  F2.flight_NO
            ELSE F.flight_NO END as flight_NO,
        CASE WHEN F.date > F2.date THEN  F2.date
            ELSE F.date END as date
    FROM AgencyData.dbo.Flight AS F
    JOIN AgencyData.dbo.Flight AS F2 ON F.paradise_offer_id = F2.paradise_offer_id
    WHERE F.flight_NO <> F2.flight_NO;

CREATE VIEW DestinationTemps
	AS SELECT
	DB2.airport_name,
	DB2.city,
	DB2.country
	FROM DestinationFlights AS V1
	JOIN AgencyData.dbo.TravelBetween AS DB1 ON V1.flight_NO = DB1.flight_NO
	JOIN AgencyData.dbo.Airport AS DB2 ON DB2.airport_ID = DB1.airport_ID;

	   
MERGE INTO DestinationAirport as TT
	USING DestinationTemps as ST
		ON TT.airport_name = ST.airport_name
		and TT.city = ST.city
		and TT.country = ST.country
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.airport_name,
					ST.city,
					ST.country
					);


DROP VIEW DestinationFlights;

DROP VIEW DestinationTemps;