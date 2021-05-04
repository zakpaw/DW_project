USE Agency_DW
GO

CREATE VIEW HotelTemps
AS
SELECT 
	name,
	city,
	country,
	CASE 
		WHEN is_befriended = 'Yes' THEN 'befriended'
		WHEN is_befriended = 'No' THEN 'not-befriended'
	END AS 	is_befriended
	FROM AgencyData.dbo.Hotel;


MERGE INTO Hotel as TT
	USING HotelTemps as ST
		ON TT.hotel_name = ST.name
			AND TT.city = ST.city
			AND TT.country = ST.country
			AND TT.is_befriended = ST.is_befriended
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.name,
					ST.city,
					ST.country,
					ST.is_befriended
					);
DROP VIEW HotelTemps;