connect to cs3db3;

--++++++++++++++++++++++++++++++++++++++++++++++
-- CREATE TABLES
--++++++++++++++++++++++++++++++++++++++++++++++

------------------------------------------------
--  DDL Statements for table Route
------------------------------------------------
CREATE TABLE Route
(
RouteID int NOT NULL,
Name varchar(60),
PRIMARY KEY (RouteID)
);

/* CREATE TABLE */
CREATE TABLE Fare(
  Type VARCHAR(20) not null, 
  Fee DECIMAL(10,2),
  primary key (Type)
);

------------------------------------------------
--  DDL Statements for table Bus
------------------------------------------------
CREATE TABLE Bus
(
BusID int NOT NULL,
NumberOfSeats int,
Age int,
Manufacturer varchar(60),
AdvertisingRevenue int,
FuelType varchar(60),
RouteID int NOT NULL,
PRIMARY KEY (BusID),
FOREIGN KEY (RouteID) REFERENCES Route(RouteID) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Person
------------------------------------------------
create table Person(
SIN integer not null,
FirstName varchar(60),
LastName varchar(60),
Sex varchar(60),
Occupation varchar(60),
Street varchar(60),
City varchar(60),
Province varchar(60),
DateOfBirth date,
primary key (SIN)
);


------------------------------------------------
--  DDL Statements for table Phone
------------------------------------------------
create table Phone(
SIN integer not null,
Number bigint not null,
Type varchar(20),
primary key (SIN, Number),
foreign key (SIN) references Person (SIN) on delete cascade
);



------------------------------------------------
--  DDL Statements for table Driver
------------------------------------------------
create table Driver(
SIN integer not null references Person (SIN) on delete cascade,
YearsOfService integer not null,
Salary integer not null,
primary key (SIN)

);
------------------------------------------------
--  DDL Statements for table MaintenancePersonnel
------------------------------------------------
create table MaintenancePersonnel(
SIN integer not null,
YearsOfService integer not null,
Salary integer not null,
Level varchar(20),
AreaSpecialization VARCHAR(100),
primary key (SIN),
foreign key (SIN) references Person (SIN) on delete cascade
);


------------------------------------------------
--  DDL Statements for table Passenger
------------------------------------------------
create table Passenger(
SIN integer not null,
Type varchar(20),
primary key (SIN),
foreign key (SIN) references Person (SIN) on delete cascade,
foreign key (Type) references Fare (Type) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Infraction
------------------------------------------------
create table Infraction(
SIN integer not null,
Date date not null,
Type varchar(60),
Demerit integer,
Fine integer,
primary key (SIN, Date),
foreign key (SIN) references Person (SIN) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Drive
------------------------------------------------
create table Drive(
SIN integer not null,
BusID integer not null,
primary key (SIN,BusID),
foreign key (SIN) references Person (SIN) on delete cascade,
foreign key (BusID) references Bus (BusID) on delete cascade
);
------------------------------------------------
--  DDL Statements for table Fix
------------------------------------------------

create table Fix(
  BusID int not null,
  SIN int not null,
  Date date,
primary key (SIN,BusID),
foreign key (SIN) references Person (SIN) on delete cascade,
foreign key (BusID) references Bus (BusID) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Take
------------------------------------------------
create table Take(
SIN integer not null,
BusID integer not null,
Date date not null,
Time time not null,
primary key(SIN, BusID,Date,Time),
foreign key (SIN) references Person (SIN) on delete cascade,
foreign key (BusID) references Bus (BusID) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Sites
------------------------------------------------
CREATE TABLE Sites
(SIName VARCHAR(100) not null,
PhoneNumber bigint not null, 
Category VARCHAR(100), 
Address VARCHAR(100), 
Capacity int,
primary key (SIName, PhoneNumber)
);

------------------------------------------------
--  DDL Statements for table Stop
------------------------------------------------
CREATE TABLE Stop
(
StopID int NOT NULL,
SName varchar(60),
SIName varchar(60) NOT NULL,
PhoneNumber bigint NOT NULL,
PRIMARY KEY (StopID),
FOREIGN KEY (SIName, PhoneNumber) REFERENCES sites(SIName, PhoneNumber) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Event
------------------------------------------------
CREATE TABLE Event
(
EName varchar(60) NOT NULL,
Time time NOT NULL,
SIName varchar(60) NOT NULL,
PhoneNumber bigint NOT NULL,
Date date NOT NULL,
NumParticipants int,
PRIMARY KEY (EName),
FOREIGN KEY (SIName, PhoneNumber) REFERENCES sites(SIName, PhoneNumber) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Schedule
------------------------------------------------
CREATE TABLE Schedule
(
RouteID int NOT NULL,
StopID int NOT NULL,
ArrivalTime time NOT NULL,
Date date NOT NULL,
PRIMARY KEY (RouteID, StopID, ArrivalTime, Date),
FOREIGN KEY (RouteID) REFERENCES Route(RouteID) on delete cascade,
FOREIGN KEY (StopID) REFERENCES Stop(StopID) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Contain
------------------------------------------------
CREATE TABLE Contain
(
RouteID int NOT NULL,
StopID int NOT NULL,
PRIMARY KEY (RouteID, StopID),
FOREIGN KEY (RouteID) REFERENCES Route(RouteID) on delete cascade,
FOREIGN KEY (StopID) REFERENCES Stop(StopID) on delete cascade
);

------------------------------------------------
--  DDL Statements for table Go
------------------------------------------------
CREATE TABLE Go
(
RouteID int NOT NULL,
SIName varchar(60) NOT NULL,
PhoneNumber bigint NOT NULL,
PRIMARY KEY (RouteID, SIName, PhoneNumber),
FOREIGN KEY (RouteID) REFERENCES Route(RouteID) on delete cascade,
FOREIGN KEY (SIName, PhoneNumber) REFERENCES sites(SIName, PhoneNumber) on delete cascade
);