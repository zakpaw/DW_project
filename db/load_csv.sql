USE AgencyData;

BULK INSERT Hotel
FROM '/home/db/data/data_Hotel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Airport
FROM '/home/db/data/data_Airport0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT AirportNearHotel
FROM '/home/db/data/data_AirportNearHotel0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT HotelOffer
FROM '/home/db/data/data_HotelOffer0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Flight
FROM '/home/db/data/data_Flight0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Airline
FROM '/home/db/data/data_Airline0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT TravelAgency
FROM '/home/db/data/data_TravelAgency0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT TravelBetween
FROM '/home/db/data/data_TravelBetween0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT ParadiseOffer
FROM '/home/db/data/data_ParadiseOffer0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Employee
FROM '/home/db/data/data_Employee0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Client
FROM '/home/db/data/data_Client0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT ClientOffer
FROM '/home/db/data/data_ClientOffer0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Payment
FROM '/home/db/data/data_Payment0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Opinion
FROM '/home/db/data/data_Opinion0.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Hotel
FROM '/home/db/data/data_Hotel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Airport
FROM '/home/db/data/data_Airport1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT AirportNearHotel
FROM '/home/db/data/data_AirportNearHotel1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT HotelOffer
FROM '/home/db/data/data_HotelOffer1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Flight
FROM '/home/db/data/data_Flight1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Airline
FROM '/home/db/data/data_Airline1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT TravelAgency
FROM '/home/db/data/data_TravelAgency1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT TravelBetween
FROM '/home/db/data/data_TravelBetween1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT ParadiseOffer
FROM '/home/db/data/data_ParadiseOffer1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Employee
FROM '/home/db/data/data_Employee1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Client
FROM '/home/db/data/data_Client1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT ClientOffer
FROM '/home/db/data/data_ClientOffer1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Payment
FROM '/home/db/data/data_Payment1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

BULK INSERT Opinion
FROM '/home/db/data/data_Opinion1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = '|',
ROWTERMINATOR='<>');

