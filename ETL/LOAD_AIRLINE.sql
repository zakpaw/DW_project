USE Agency_DW
GO

MERGE INTO Airline as TT
	USING AgencyData.dbo.Airline  as ST
		ON TT.airline_name = ST.name
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.name
					);

SELECT * FROM AgencyData.dbo.Airline 