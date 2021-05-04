USE Agency_DW
GO
MERGE INTO TravelAgency as TT
	USING AgencyData.dbo.TravelAgency as ST
		ON TT.agency_name = ST.agency_name
		and TT.city = ST.city
		and TT.country = ST.country
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.agency_name,
					ST.city,
					ST.country
					);
