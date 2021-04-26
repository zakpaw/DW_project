BULK INSERT Agency_Excel
FROM '/home/db/data/data_Agency_Excel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Agency_Network_Excel
FROM '/home/db/data/data_Agency_Network_Excel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Agency_Excel
FROM '/home/db/data/data_Agency_Excel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Agency_Network_Excel
FROM '/home/db/data/data_Agency_Network_Excel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

