USE Agency_DW;

-- DIMENTIONS --
CREATE TABLE TravelAgency( --done
	agency_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	agency_name VARCHAR(100),
	city VARCHAR(100),
	country VARCHAR(100)
);

CREATE TABLE Employee( --poprawic
	employee_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	travel_agency_ID INT REFERENCES TravelAgency,
	PESEL VARCHAR(12),
	name_surname VARCHAR(45),
    education VARCHAR(14),
	seniority VARCHAR(27),
	is_active INT CHECK(is_active = 0 OR is_active = 1) 
);
ALTER TABLE Employee 
ADD CONSTRAINT chk_education 
	CHECK (education IN ('Middle school', 'High School', 'College', 'Master', 'PhD') 
		AND seniority IN ('up to one year', 'between one and five years', 'more than five years'));

CREATE TABLE Date( --done
	date_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	date INT CHECK(date BETWEEN 1 and 31),
	year INT,
	month VARCHAR(20),
	monthNo INT CHECK(monthNo BETWEEN 1 and 12)
);

CREATE TABLE Time( --done
	time_ID INTEGER IDENTITY(1,1) PRIMARY KEY, 
	hour INT CHECK(hour BETWEEN 0 AND 24),
	minute INT CHECK(minute BETWEEN 0 AND 60)
);

CREATE TABLE LocalAirport(--done
	airport_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	airport_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150)
);

CREATE TABLE DestinationAirport(-- done
	airport_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	airport_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150)
);

CREATE TABLE Airline( --done
	airline_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	airline_name VARCHAR(150)
);

CREATE TABLE Hotel( --done
	hotel_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	hotel_name VARCHAR(150),
	city VARCHAR(150),
	country VARCHAR(150),
	is_befriended VARCHAR(14) CHECK(is_befriended = 'befriended' OR is_befriended = 'not-befriended') 
);

-- FACTS --
CREATE TABLE AirportNearHotel(-- done
	hotel_ID INT REFERENCES Hotel,
	airport_ID INT REFERENCES DestinationAirport,
	distance INT,
	travelled_time INT
	PRIMARY KEY(hotel_ID, airport_ID)
);

CREATE TABLE Flights(
	flight_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	airline_ID INT REFERENCES Airline,
	local_airport_ID INT REFERENCES LocalAirport,
	destination_airport_ID INT REFERENCES DestinationAirport,
	flight_departure_start_ID INT REFERENCES Time,
	flight_departure_end_ID INT REFERENCES Time,
	flight_duration INT,
	cost MONEY,
	airline_discount FLOAT
);

CREATE TABLE TripScheduling(
	flight_ID INT REFERENCES Flights,
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
	OTW INT,
	PRIMARY KEY(flight_ID, employee_ID, hotel_ID, creation_date_ID, creation_time_ID, hotel_start_date_ID, hotel_end_date_ID, hotel_start_time_ID, hotel_end_time_ID)
);
-- USE Agency_DW;

-- SELECT * FROM  TripScheduling;
-- SELECT * FROM Flights;
-- SELECT * FROM AirportNearHotel;
-- SELECT * FROM Employee;
-- SELECT * FROM  Date;
-- SELECT * FROM Time;
-- SELECT * FROM LocalAirport;
-- SELECT * FROM DestinationAirport;
-- SELECT * FROM Airline;
-- SELECT * FROM Hotel;