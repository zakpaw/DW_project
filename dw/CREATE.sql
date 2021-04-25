-- DIMENTIONS --
CREATE DATABASE Agency_DW
USE Agency_DW

CREATE TABLE TravelAgency(
	agency_ID INT PRIMARY KEY,
	agency_name VARCHAR(100),
	city VARCHAR(100),
	country VARCHAR(100)
);

CREATE TABLE Employee(
	employee_ID INT PRIMARY KEY,
	travel_agency_ID INT REFERENCES TravelAgency,
	PESEL VARCHAR(11),
	name_surname VARCHAR(45),
    education VARCHAR(14),
	seniority VARCHAR(27),
	is_active BIT -- tutaj mialo byc "active" albo "not active" ale nie wiem
);
ALTER TABLE Employee
ADD CONSTRAINT chk_education 
	CHECK ([education] IN ('Middle school', 'High School', 'College', 'Master', 'PhD') 
		AND [seniority] IN ('up to one year', 'between one and five years', 'more than five years'));

CREATE TABLE Date(
	date_ID INT PRIMARY KEY,
	date INT CHECK(date BETWEEN 1 and 31),
	year INT,
	month VARCHAR(20),
	monthNo INT CHECK(monthNo BETWEEN 1 and 12)
);

CREATE TABLE Time(
	time_ID INT PRIMARY KEY, 
	hour INT CHECK(hour BETWEEN 0 AND 24),
	minute INT CHECK(minute BETWEEN 0 AND 60)
);

CREATE TABLE LocalAirport(
	airport_ID INT PRIMARY KEY,
	airport_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150)
);

CREATE TABLE DestinationAirport(
	airport_ID INT PRIMARY KEY,
	airport_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150)
);

CREATE TABLE Airline(
	airport_ID INT PRIMARY KEY,
	name VARCHAR(150)
);

CREATE TABLE Hotel(
	hotel_ID INT PRIMARY KEY,
	hotel_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150),
	is_befriended BIT DEFAULT 0
);

-- FACTS --
CREATE TABLE AirportNearHotel(
	hotel_ID INT REFERENCES Hotel,
	airport_ID INT REFERENCES DestinationAirport,
	distance INT,
	travelled_time INT
);

CREATE TABLE Flights(
	flight_ID INT PRIMARY KEY,
	flight_NO INT,
	airline_ID INT REFERENCES Airline,
	local_airport_ID INT REFERENCES LocalAirport,
	destination_airport_ID INT REFERENCES DestinationAirport,
	flight_departure_start_ID INT REFERENCES Time,
	flight_departure_end_ID INT REFERENCES Time,
	flight_duration INT,
	cost MONEY,
	discount INT
);

CREATE TABLE TripScheduling(
	employee_ID INT REFERENCES Employee,
	hotel_ID INT REFERENCES Hotel,
	creation_date_ID INT REFERENCES Date,
	creation_time_ID INT REFERENCES Time,
	hotel_start_date_ID INT REFERENCES Date,
	hotel_end_date_ID INT REFERENCES Date,
	hotel_start_time_ID INT REFERENCES Time,
	hotel_end_time_ID INT REFERENCES Time,
	transaction_NO INT,
	hotel_cost MONEY,
	client_price MONEY,
	profit MONEY,
	OTW INT
);