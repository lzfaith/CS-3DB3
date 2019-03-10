connect to cs3db3;

--++++++++++++++++++++++++++++++++++++++++++++++
-- CREATE TABLES
--++++++++++++++++++++++++++++++++++++++++++++++


------------------------------------------------
--  DDL Statements for table Person**
------------------------------------------------
CREATE TABLE Person(
    ID INT NOT NULL,
    first_name VARCHAR(10),
    last_name VARCHAR(10),
    date_birth DATE,
    gender VARCHAR(10),
    st_ad CHAR(20),
    city_ad CHAR(20),
    province VARCHAR(10),
    primary key (ID)

);


------------------------------------------------
--  DDL Statements for table Phone**
------------------------------------------------
CREATE TABLE Phone(
    phoneNmb INT NOT NULL,
    type CHAR(10),
    person_ID INT,
    primary key (PhoneNmb),
    foreign key (person_ID) references Person(ID) ON DELETE CASCADE

);



------------------------------------------------
--  DDL Statements for table Passenger**
------------------------------------------------
CREATE TABLE Passenger(
    type CHAR(20),
    passenger_ID INT,
    foreign key (passenger_ID) references Person(ID)
);


------------------------------------------------
--  DDL Statements for fare**
------------------------------------------------
CREATE TABLE Fare(
    price REAL NOT NULL,
    passenger_ID INT,
    primary key (price),
    foreign key (passenger_ID) references Person(ID)
);

------------------------------------------------
--  DDL Statements for table Driver**
------------------------------------------------
CREATE TABLE Driver(
    salary REAL,
    ser_year INT,
    driver_ID INT,
    foreign key (driver_ID) references Person(ID)

);


------------------------------------------------
--  DDL Statements for table Infraction**
------------------------------------------------
CREATE TABLE Infraction(
    driver_ID INT NOT NULL,
    penalty REAL,
    ocu_date DATE NOT NULL,
    point INT,
    type CHAR(20) NOT NULL,
    primary key (driver_ID, ocu_date, type),
    foreign key (driver_ID) references Person(ID) ON DELETE CASCADE
);


------------------------------------------------
--  DDL Statements for table Maintenance_person**
------------------------------------------------
CREATE TABLE Maintenance_person(
    Maintenance_person_ID INT,
    specialization CHAR(20),
    level CHAR(20),
    salary REAL,
    ser_year INT,
    foreign key (Maintenance_person_ID) references Person(ID)
);


------------------------------------------------
--  DDL Statements for table Bus**
------------------------------------------------
CREATE TABLE Bus(
    bus_ID INT NOT NULL,
    opera_year INT,
    seat_Nmb INT,
    manufacture CHAR(20),
    revenue_ad REAL,
    fuel_type CHAR(20),
    primary key (bus_ID)

);

------------------------------------------------
--  DDL Statements for table Fix**
------------------------------------------------
CREATE TABLE Fix(
    date DATE,
    bus_ID INT,
    Maintenance_person_ID INT,
    foreign key (bus_ID) references Bus(bus_ID) ON DELETE CASCADE,
    foreign key (Maintenance_person_ID) references Person(ID) ON DELETE CASCADE
);


------------------------------------------------
--  DDL Statements for table Drive**
------------------------------------------------
CREATE TABLE Drive(
    bus_ID INT,
    driver_ID INT,
    foreign key (driver_ID) references Person(ID) ON DELETE CASCADE,
    foreign key (bus_ID) references Bus(bus_ID) ON DELETE CASCADE
);


------------------------------------------------
--  DDL Statements for table Stop**
------------------------------------------------
CREATE TABLE Stop(
    name VARCHAR(10),
    stop_ID INT NOT NULL,
    primary key (stop_ID)
);

------------------------------------------------
--  DDL Statements for table Route**
------------------------------------------------
CREATE TABLE Route(
    route_ID int NOT NULL,
    Name varchar(60),
    primary key (route_ID),
    stop_ID INT,
    bus_ID INT,
    foreign key (stop_ID) references Stop(stop_ID),
    foreign key (bus_ID) references Bus(bus_ID)
);


------------------------------------------------
--  DDL Statements for table Schedule**
------------------------------------------------
CREATE TABLE Schedule(
    bus_ID INT,
    route_ID INT,
    stop_ID INT,
    arriv_time TIME,
    date DATE,
    foreign key (bus_ID) references Bus(bus_ID),
    foreign key (route_ID) references Route(route_ID),
    foreign key (stop_ID) references Stop(stop_ID)
);


------------------------------------------------
--  DDL Statements for table Site**
------------------------------------------------
CREATE TABLE Site(
    site_name CHAR(20) NOT NULL,
    address CHAR(20),
    catagory CHAR(20),
    capacity REAL,
    phone_Nmb INT,
    route_ID INT,
    stop_ID INT,
    primary key (site_name),
    foreign key (stop_ID) references Stop(stop_ID),
    foreign key (route_ID) references Route(route_ID)

);

------------------------------------------------
--  DDL Statements for table Event**
------------------------------------------------
CREATE TABLE Event(
    event_name VARCHAR(20) NOT NULL,
    date DATE,
    time TIME,
    parti_Nmb REAL,
    site_name VARCHAR(10),
    primary key (event_name),
    foreign key (site_name) references Site(site_name) ON DELETE CASCADE
);




------------------------------------------------
-- List all tables your created
------------------------------------------------
list tables;