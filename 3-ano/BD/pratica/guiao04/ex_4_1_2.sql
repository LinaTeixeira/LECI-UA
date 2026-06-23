CREATE SCHEMA reservaVoos;
GO

CREATE TABLE reservaVoos.Airport (
    AirportCode VARCHAR(10) PRIMARY KEY,
    AirportCity VARCHAR(100),
    AirportState VARCHAR(50),
    AirportName VARCHAR(150)
);

CREATE TABLE reservaVoos.Flight (
    FlightNumber INT PRIMARY KEY,
    Airline VARCHAR(100),
    Weekdays VARCHAR(50)
);

CREATE TABLE reservaVoos.AirplaneType (
    AirplaneTypeName VARCHAR(50) PRIMARY KEY,
    MaxSeats INT,
    Company VARCHAR(100)
);

CREATE TABLE reservaVoos.Airplane (
    AirplaneID INT PRIMARY KEY,
    TotalNoSeats INT,
    AirplaneTypeName VARCHAR(50),
    FOREIGN KEY (AirplaneTypeName) REFERENCES reservaVoos.AirplaneType(AirplaneTypeName)
);

CREATE TABLE reservaVoos.CanLand (
    AirplaneTypeName VARCHAR(50),
    AirportCode VARCHAR(10),
    PRIMARY KEY (AirplaneTypeName, AirportCode),
    FOREIGN KEY (AirplaneTypeName) REFERENCES reservaVoos.AirplaneType(AirplaneTypeName),
    FOREIGN KEY (AirportCode) REFERENCES reservaVoos.Airport(AirportCode)
);

CREATE TABLE reservaVoos.Fare (
    FareCode VARCHAR(20) PRIMARY KEY,
    Amount DECIMAL(10,2),
    Restrictions VARCHAR(255),
    FlightNumber INT,
    FOREIGN KEY (FlightNumber) REFERENCES reservaVoos.Flight(FlightNumber)
);

CREATE TABLE reservaVoos.FlightLeg (
    LegNo INT PRIMARY KEY,
    ScheduledArrivalTime TIME,
    ScheduledDepartureTime TIME,
    FlightNumber INT,
    AirportCode VARCHAR(10),
    FOREIGN KEY (FlightNumber) REFERENCES reservaVoos.Flight(FlightNumber),
    FOREIGN KEY (AirportCode) REFERENCES reservaVoos.Airport(AirportCode)
);

CREATE TABLE reservaVoos.LegInstance (
    LegInstanceDate DATE PRIMARY KEY,
    NoAvailableSeats INT,
    ArrivalTime TIME,
    DepartureTime TIME,
    AirplaneID INT,
    LegNo INT,
    AirportCode VARCHAR(10),
    FOREIGN KEY (AirplaneID) REFERENCES reservaVoos.Airplane(AirplaneID),
    FOREIGN KEY (LegNo) REFERENCES reservaVoos.FlightLeg(LegNo),
    FOREIGN KEY (AirportCode) REFERENCES reservaVoos.Airport(AirportCode)
);

CREATE TABLE reservaVoos.Seat (
    SeatNo INT PRIMARY KEY,
    CustomerName VARCHAR(150),
    Cellphone VARCHAR(20),
    LegInstanceDate DATE,
    FOREIGN KEY (LegInstanceDate) REFERENCES reservaVoos.LegInstance(LegInstanceDate)
);