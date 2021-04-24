BULK INSERT Agency_Excel
FROM 'data_Agency_Excel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='0x0a');

BULK INSERT Agency_Network_Excel
FROM 'data_Agency_Network_Excel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='0x0a');

BULK INSERT Agency_Excel
FROM 'data_Agency_Excel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='0x0a');

BULK INSERT Agency_Network_Excel
FROM 'data_Agency_Network_Excel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='0x0a');

