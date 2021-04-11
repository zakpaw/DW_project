CREATE TABLE TravelAgency(
	agency_ID VARCHAR(5) PRIMARY KEY,
	agency_name VARCHAR(30),
	city VARCHAR(30),
	country VARCHAR(30)
);
CREATE TABLE Employee(
	ID VARCHAR(5) PRIMARY KEY,
	name VARCHAR(15),
	surname VARCHAR(15),
	agency_ID VARCHAR(5) REFERENCES TravelAgency
);
CREATE TABLE Client(
	PESEL VARCHAR(11) PRIMARY KEY,
	name VARCHAR(15),
	surname VARCHAR(30),
	email VARCHAR(30),
	telephone_number INT
	);

CREATE TABLE Hotel(
	hotel_ID varchar(5) PRIMARY KEY,
	name VARCHAR(30),
	address VARCHAR(15),
	city VARCHAR(30),
	country VARCHAR(30),
	starting_hour TIME,
	ending_hour TIME,
	opinion INT,
	is_befriended VARCHAR(3)
	);

CREATE TABLE HotelOffer(
	offer_ID VARCHAR(5) PRIMARY KEY,
	start_date DATE,
	end_date DATE,
	price FLOAT,
	capacity INT,
	discount FLOAT,
	type_of_board VARCHAR(30),
	hotel_ID VARCHAR(5) REFERENCES Hotel
);
CREATE TABLE ParadiseOffer(
	offer_ID VARCHAR(5) PRIMARY KEY,
	costs FLOAT,
	OTW FLOAT,
	creation_date DATE,
	employee_ID VARCHAR(5) REFERENCES Employee,
	hotel_offer_ID VARCHAR(5) REFERENCES HotelOffer
);
CREATE TABLE Payment(
	transaction_no VARCHAR(12) PRIMARY KEY,
	amount FLOAT,
	payment_date DATE,
	payment_method VARCHAR(20),
	offer_ID VARCHAR(5) REFERENCES ParadiseOffer,
	client_PESEL VARCHAR(11) REFERENCES Client
);
CREATE TABLE Opinion(
	opinion_ID VARCHAR(5) PRIMARY KEY,
	overall_reat INT,
	location INT,
	food INT,
	hotel INT,
	time_management INT,
	travelAgent INT,
	client_PESEL VARCHAR(11) REFERENCES Client,
	offer_ID VARCHAR(5) REFERENCES ParadiseOffer
	);

CREATE TABLE Airline(
	ID VARCHAR(5) PRIMARY KEY,
	name VARCHAR(30),
	email VARCHAR(30),
	telephone_number INT,
	discount FLOAT,
	);

CREATE TABLE Flight(
	flight_NO VARCHAR(5) PRIMARY KEY,
	airplane VARCHAR(20),
	cost FLOAT,
	date DATE,
	arrival_time TIME,
	departure_time TIME,
	destination VARCHAR(30),
	continent VARCHAR(30),
	airline_ID VARCHAR(5) REFERENCES Airline
);
CREATE TABLE Airport (
	airport_ID VARCHAR(5) PRIMARY KEY,
	airport_name VARCHAR(30),
	city VARCHAR(30),
	country VARCHAR(30),
);
CREATE TABLE TravelBetween(
	airport_ID VARCHAR(5) REFERENCES Airport,
	flight_NO VARCHAR(5) REFERENCES Flight,
	PRIMARY KEY(airport_ID, flight_NO)
);
CREATE TABLE ClientOffer(
	client_PESEL VARCHAR(11) REFERENCES Client,
	offer_ID VARCHAR(5) REFERENCES ParadiseOffer,
	PRIMARY KEY(client_PESEL, offer_ID)
);
CREATE TABLE AirportNearHotel(
	hotel_ID VARCHAR(5) REFERENCES Hotel,
	airport_ID VARCHAR(5) REFERENCES Airport,
	distance INT,
	travel_time TIME,
	PRIMARY KEY(hotel_ID, airport_ID)
);


DROP TABLE CLIENT;
DROP TABLE EMPLOYEE;
DROP TABLE Opinion;
DROP TABLE Hotel_Offer;
DROP TABLE ParadiseOffer;
DROP TABLE TravelAgency;
DROP TABLE Flight;
DROP TABLE TravelBetween;
DROP TABLE AirportNearHotel;
DROP TABLE Airport;
DROP TABLE Airline;
DROP TABLE ClientOffer;
DROP TABLE PAYMENT;
DROP TABLE HOTEL;