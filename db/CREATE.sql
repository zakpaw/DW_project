USE AgencyData;

CREATE TABLE TravelAgency(
	agency_ID INT IDENTITY(1,1) PRIMARY KEY,
	agency_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150)
);

CREATE TABLE Employee(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(15),
	surname VARCHAR(15),
	agency_ID INT REFERENCES TravelAgency
);

CREATE TABLE Client(
	client_ID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(150),
	surname VARCHAR(150),
	email VARCHAR(150),
	telephone_number INT
	);

CREATE TABLE Hotel(
	hotel_ID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(150),
	address VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150),
	starting_hour INT,
	ending_hour INT,
	opinion INT,
	is_befriended VARCHAR(4)
);

CREATE TABLE HotelOffer(
	offer_ID INT IDENTITY(1,1) PRIMARY KEY,
	start_date DATE,
	end_date DATE,
	price FLOAT,
	capacity INT,
	discount FLOAT,
	hotel_ID INT REFERENCES Hotel
);

CREATE TABLE ParadiseOffer(
	offer_ID INT IDENTITY(1,1) PRIMARY KEY,
	costs FLOAT,
	OTW FLOAT,
	creation_date DATE,
	creation_time INT,
	employee_ID INT REFERENCES Employee,
	hotel_offer_ID INT REFERENCES HotelOffer
);

CREATE TABLE Payment(
	transaction_no INT IDENTITY(1,1) PRIMARY KEY,
	amount FLOAT,
	payment_date DATE,
	payment_method VARCHAR(50),
	offer_ID INT REFERENCES ParadiseOffer,
	client_PESEL INT REFERENCES Client
);

CREATE TABLE Opinion(
	opinion_ID INT IDENTITY(1,1) PRIMARY KEY,
	overall_reat INT,
	location INT,
	food INT,
	hotel INT,
	time_management INT,
	travelAgent INT,
	client_PESEL INT REFERENCES Client,
	offer_ID INT REFERENCES ParadiseOffer
);

CREATE TABLE Airline(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(150),
	email VARCHAR(150),
	telephone_number INT,
	discount FLOAT,
);

CREATE TABLE Flight(
	flight_NO INT IDENTITY(1,1) PRIMARY KEY,
	airplane VARCHAR(150),
	cost FLOAT,
	date DATE,
	arrival_time INT,
	departure_time INT,
	destination VARCHAR(150),
	continent VARCHAR(150),
	airline_ID INT REFERENCES Airline,
	paradise_offer_id INT REFERENCES ParadiseOffer

);

CREATE TABLE Airport (
	airport_ID INT IDENTITY(1,1) PRIMARY KEY,
	airport_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150),
);

CREATE TABLE TravelBetween(
	airport_ID INT REFERENCES Airport,
	flight_NO INT REFERENCES Flight,
	PRIMARY KEY(airport_ID, flight_NO)
);

CREATE TABLE ClientOffer(
	client_PESEL INT REFERENCES Client,
	offer_ID INT REFERENCES ParadiseOffer,
	PRIMARY KEY(client_PESEL, offer_ID)
);

CREATE TABLE AirportNearHotel(
	hotel_ID INT REFERENCES Hotel,
	airport_ID INT REFERENCES Airport,
	distance INT,
	travel_time FLOAT,
	PRIMARY KEY(hotel_ID, airport_ID)
);
