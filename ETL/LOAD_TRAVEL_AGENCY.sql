USE Agency_DW
GO

MERGE INTO TravelAgency as TT
	USING Agency.dbo.TravelAgency as ST
		ON TT.agency_ID = ST.agency_ID
		and TT.agency_name = ST.agency_name
		and TT.city = ST.city
		and TT.country = ST.country
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.agency_name,
					ST.city,
					ST.country
					)
			WHEN Not Matched By Source
				Then
					DELETE
;


SELECT * FROM Agency_DW.dbo.TravelAgency