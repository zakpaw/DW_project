USE Agency_DW
GO

SET IDENTITY_INSERT Airline ON;  
GO
INSERT INTO Airline (airline_ID, airline_name)
VALUES (-1, 'UNKNOWN')
SET IDENTITY_INSERT Airline OFF;  

SET IDENTITY_INSERT TravelAgency ON;  
GO
INSERT INTO TravelAgency (agency_ID, agency_name, city, country)
VALUES (-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN')
SET IDENTITY_INSERT TravelAgency OFF;  

SET IDENTITY_INSERT Hotel ON;  
GO 
INSERT INTO Hotel (hotel_ID, hotel_name, city, country, is_befriended) 
VALUES (-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', NULL)
SET IDENTITY_INSERT Hotel OFF;  

SET IDENTITY_INSERT DestinationAirport ON;  
GO
INSERT INTO DestinationAirport (airport_ID, airport_name, city, country)
VALUES (-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN')
SET IDENTITY_INSERT DestinationAirport OFF;  

SET IDENTITY_INSERT LocalAirport ON;  
GO
INSERT INTO LocalAirport (airport_ID, airport_name, city, country)
VALUES (-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN')
SET IDENTITY_INSERT LocalAirport OFF;  

SET IDENTITY_INSERT Employee ON;  
GO 
INSERT INTO Employee (employee_ID, travel_agency_ID, PESEL, name_surname, education, seniority, is_active) 
VALUES (-1, NULL, 'UNKNOWN', 'UNKNOWN', NULL, NULL, 1)
SET IDENTITY_INSERT Employee OFF;  
