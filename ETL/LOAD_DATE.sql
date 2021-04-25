USE Agency_DW
go
Declare @StartDate date; 
Declare @EndDate date;

SELECT @StartDate = '1980-01-01', @EndDate = '2022-01-01';

Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
	Begin
		Insert Into Date 
		( [Date]
		, [Year]
		, [Month]
		, [MonthNo]
		)
		Values ( 
		    CONVERT(INT, DAY(@DateInProcess))
		  , CONVERT(INT, YEAR(@DateInProcess))
		  , CONVERT(VARCHAR(20), DATENAME(month, @DateInProcess))
		  , CONVERT(INT, Month(@DateInProcess))
		); 
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go
