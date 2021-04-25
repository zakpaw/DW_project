USE Agency_DW
GO

MERGE INTO Airline as TT
	USING Agency.dbo.Airline  as ST
		ON TT.airline_name = ST.name
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.name
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;


SELECT * FROM Agency_DW.dbo.Airline 