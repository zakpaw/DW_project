USE Agency_DW
GO

CREATE VIEW DestinationTemps
    AS SELECT
    DB2.flight_NO,
    DB3.airport_ID,
    DB4.airport_name,
    DB4.city,
    DB4.country,
    DB1.offer_ID
    FROM AgencyData.dbo.ParadiseOffer AS DB1
    JOIN AgencyData.dbo.Flight AS DB2 ON DB1.offer_ID = DB2.paradise_offer_id
    JOIN AgencyData.dbo.TravelBetween AS DB3 ON DB2.flight_NO = DB3.flight_NO
    JOIN AgencyData.dbo.Airport AS DB4 ON DB4.airport_ID = DB3.airport_ID
    ORDER BY DB1.offer_ID

CREATE VIEW DestinationFlights
    AS SELECT DISTINCT
        CASE WHEN F.date > F2.date THEN  F2.flight_NO
            ELSE F.flight_NO END as flight_NO,
        CASE WHEN F.date > F2.date THEN  F2.date
            ELSE F.date END as date
    FROM AgencyData.dbo.Flight AS F
    JOIN AgencyData.dbo.Flight AS F2 ON F.paradise_offer_id = F2.paradise_offer_id
    WHERE F.flight_NO <> F2.flight_NO


SELECT * FROM DestinationFlights
DROP VIEW DestinationFlights

    SELECT * FROM DestinationTemps
        ORDER BY offer_ID
SELECT * FROM AirportNearHotel


DROP VIEW DestinationTemps
SELECT * FROM AgencyData.dbo.Flight 
ORDER BY paradise_offer_id

SELECT DISTINCT flight_NO FROM AgencyData.dbo.Flight
ORDER BY flight_NO



MERGE INTO DestinationAirport as TT
    USING AgencyData.dbo.Airport as ST
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


SELECT * FROM DestinationAirport