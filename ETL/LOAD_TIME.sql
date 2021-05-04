USE Agency_DW
GO

DECLARE @HoursInDay int, @MinutesInHour int
SELECT @HoursInDay = 23, @MinutesInHour = 59

DECLARE @H int, @M int
SELECT @H = 0, @M = 0

WHILE @H <= @HoursInDay
	BEGIN
		WHILE @M <= @MinutesInHour
		BEGIN
			INSERT INTO Time ([hour], [minute])
			VALUES(@H, @M);

			SET @M = @M + 1
		END
	SET @H = @H + 1
	SET @M = 0
END
	