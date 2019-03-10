--connect to database
connect to cs3db3;

--+++++++++++++++++++++++++++++++++++
--1.Identify all buses (busID, age, manufacturer) with advertising revenue greater than $9000
--+++++++++++++++++++++++++++++++++++
SELECT BusID, Age, Manufacturer
FROM BUS
WHERE advertisingRevenue > '9000';


--+++++++++++++++++++++++++++++++++++
--Find the number of students in the database. A student is defined as a person with a
--student occupation or is less than 25 years old. Do not include duplicates. (Hint: If needed, you
--may use the date() function.)
--+++++++++++++++++++++++++++++++++++
SELECT COUNT(*) AS NumberOfStudents
FROM Person s2, (SELECT DISTINCT(SIN)
                FROM Person s1
                WHERE s1.Occupation = 'student' OR s1.DateOfBirth >= '1/1/1993')si
WHERE s2.SIN = si.SIN;


--+++++++++++++++++++++++++++++++++++
--3.How many students took bus route #5 on May 3rd, 2017?
--+++++++++++++++++++++++++++++++++++
SELECT COUNT(*) AS NumberOfStudents
FROM Take tk, Bus b, (SELECT DISTINCT(s1.SIN)
                      FROM Person s1
                      WHERE s1.Occupation = 'student')si
WHERE tk.Date = '5/3/2017' 
      AND tk.SIN = si.SIN 
      AND tk.BusID = b.BusID 
      AND b.RouteID = 5;


--+++++++++++++++++++++++++++++++++++
--4.For each bus route, find the total advertising revenue. Return the bus route number
--and the total revenue. Order the results in descending order of total revenue.
--+++++++++++++++++++++++++++++++++++
SELECT RouteID, SUM(AdvertisingRevenue) AS AdRevenue
FROM Bus
GROUP BY RouteID
ORDER BY SUM(AdvertisingRevenue) DESC;


--+++++++++++++++++++++++++++++++++++
--5(a)Find all drivers who have less than 3 infractions. Return the driver’s ID, first
--name and last name.
--+++++++++++++++++++++++++++++++++++
SELECT S1.SIN, S1.FirstName, S1.LastName
FROM Person S1, (SELECT SIN
              FROM infraction
              GROUP BY SIN
              HAVING COUNT(Date) < 3) Inf
WHERE S1.SIN = Inf.SIN;


--+++++++++++++++++++++++++++++++++++
--5(b)For each driver, return the total demerit points and total fines incurred. Do not
--include drivers with less than 2 demerit points in the result. Sort the result such that the
--most offending drivers (in terms of demerit points, total fines) are listed first.
--+++++++++++++++++++++++++++++++++++
SELECT Inf.SIN, SUM(Inf.Demerit) AS TotalDemerit, SUM(Inf.Fine) AS TotalFine
FROM Infraction Inf, Driver Dr
WHERE Dr.SIN = Inf.SIN
GROUP BY Inf.SIN
HAVING SUM(Inf.Demerit) >= 2
ORDER BY SUM(Inf.Demerit) DESC;


--+++++++++++++++++++++++++++++++++++
--6.Determine those buses that are the unique (only) bus made by their manufacturer.
--Return the busID and the manufacturer.
--+++++++++++++++++++++++++++++++++++
SELECT b1.BusID, b1.Manufacturer
FROM Bus b1
WHERE b1.Manufacturer IN (SELECT b2.Manufacturer
                         FROM Bus b2
                         GROUP BY b2.Manufacturer
                         HAVING COUNT(b2.BusID) < 2);


--+++++++++++++++++++++++++++++++++++
--7(a).For each passenger type, find the total fare revenues. Return the passenger type
--and the total (fare) revenue.
--+++++++++++++++++++++++++++++++++++
--take should be applied 
SELECT Fr.type, SUM(Fr.fee) AS TotalRevenue
FROM Passenger Pr, Fare Fr, Take tk
WHERE Pr.type = Fr.type AND tk.SIN = Pr.SIN
GROUP BY Fr.type;


--+++++++++++++++++++++++++++++++++++
--7(b).Extend your query in part (a) to only list passenger types with revenues greater
--than $500.
--+++++++++++++++++++++++++++++++++++
--take should be applied 
SELECT Fr.type, SUM(Fr.fee) AS TotalRevenue
FROM Passenger Pr, Fare Fr, Take tk
WHERE Pr.type = Fr.type AND Pr.SIN = Tk.SIN
GROUP BY Fr.type
HAVING SUM(Fr.fee) > 500;


--+++++++++++++++++++++++++++++++++++
--7(c).Extend your query in part (a) to return the most profitable passenger type (in
--terms of total fare revenue) on May 1, 2017.
--+++++++++++++++++++++++++++++++++++
SELECT Pr.Type
FROM Passenger Pr, Fare Fr, Take Ta
WHERE Pr.type = Fr.type AND Pr.SIN = Ta.SIN AND Ta.date = '5/1/2017'
GROUP BY Pr.Type
ORDER BY SUM(Fr.Fee) DESC 
FETCH FIRST 1 ROW ONLY;


--+++++++++++++++++++++++++++++++++++
--8(a).Determine the most popular bus route on May 7, 2017 (according to the number
--of passengers). Return the route ID and the number of passenger trips.
--+++++++++++++++++++++++++++++++++++
SELECT Rt.RouteID, COUNT(*) AS NumberOfPassenger
FROM Route Rt, Take Tk, Bus Bs
WHERE Tk.Date = '5/7/2017' AND Tk.BusID = Bs.BusID AND Bs.RouteID = Rt.RouteID
GROUP BY Rt.RouteID
HAVING COUNT(*) = (SELECT MAX(y.num)
                   FROM (SELECT COUNT(*) as num
                         FROM Take Tk2, Bus Bs2, Route Rt2
                         WHERE Tk2.Date = '5/7/2017' AND Tk2.BusID = Bs2.BusID AND Bs2.RouteID = Rt2.RouteID 
                         GROUP BY Rt2.RouteID)y);


--+++++++++++++++++++++++++++++++++++
--8(b).Which day contained the largest volume of passenger trips? Return the date and
--the number of trips taken.
--+++++++++++++++++++++++++++++++++++
SELECT Tk.Date, COUNT(Tk.SIN) AS NumberOfTrips
FROM Take Tk
GROUP BY Tk.Date
HAVING COUNT(Tk.SIN) = (SELECT MAX(y.num)
                        FROM (SELECT COUNT(*) as num
                              FROM Take Tk2
                              GROUP BY Tk2.Date)y);


--+++++++++++++++++++++++++++++++++++
--9).Find all persons who visited a library on either May 5, 2017 or May 6, 2017. Return
--the person’s occupation. Do not include duplicates.
--+++++++++++++++++++++++++++++++++++
SELECT DISTINCT(Pr.Occupation)
FROM Sites St, Person Pr, Go g, Bus Bs, Take Tk
WHERE St.Category = 'Library' 
      AND St.SIName = g.SIName 
      AND g.RouteID = Bs.RouteID 
      AND Bs.BusID = Tk.BusID 
      AND Pr.SIN = Tk.SIN 
      AND (Tk.Date = '5/5/2017' OR Tk.Date = '5/6/2017');


--+++++++++++++++++++++++++++++++++++
--10).Find the drivers who have worked with HSR for more than 5 years, with a salary
--greater than $80000, and with less than 10 demerit points on their driving record. Return the
--driver’s first name, last name, and ID.
--+++++++++++++++++++++++++++++++++++
SELECT Pr.FirstName, Pr.LastName, Pr.SIN AS ID
FROM Driver Dr, Person Pr
WHERE Dr.YearsOfService > 5 AND Dr.Salary > 80000 AND Dr.SIN IN (SELECT Inf.SIN
                                                                 FROM Infraction Inf
                                                                 GROUP BY Inf.SIN
                                                                 HAVING SUM(Inf.Demerit) < 10) AND Dr.SIN = Pr.SIN;


--+++++++++++++++++++++++++++++++++++
--11).Find all students who attended the ”Marauders Tennis” match and arrived via a bus
--on route 4. Return the student’s first name, last name, and their gender.
--+++++++++++++++++++++++++++++++++++
SELECT p.FirstName, p.LastName, p.Sex
FROM Person p, Bus b, Take t, Event e, Go g
WHERE b.RouteID = 4 
      AND t.BusID = b.BusID
      AND b.RouteID = g.RouteID 
      AND g.SIName = e.SIName
      AND e.EName = 'Marauders Tennis'
      AND p.Occupation = 'student'
      AND p.SIN = t.SIN
      AND t.date = e.date;




--+++++++++++++++++++++++++++++++++++
--12.Assuming that the bus schedule has not changed since May 2017. Suppose you would
--like to attend the ”Marauders Basketball” game (an event). The game starts at 5pm, and you’d
--like to arrive at the site between 4:20pm and 4:50pm, which routes can you take? Use May 1,
--2017 as a reference date for the bus schedule information. List the route ID, the bus stop name
--(where you should get off the bus), and the scheduled arrival time.
--+++++++++++++++++++++++++++++++++++
SELECT sc.RouteID, sp.SName, sc.ArrivalTime
FROM Schedule sc, Stop sp, (SELECT g.RouteID 
                            FROM Go g, Event e
                            WHERE e.EName = 'Marauders Basketball' AND e.SIName = g.SIName)rt
WHERE sc.RouteID = rt.RouteID 
      AND sc.StopID = sp.StopID 
      AND sc.ArrivalTime >= '16:20:00' 
      AND sc.ArrivalTime <= '16:50:00' 
      AND sc.Date = '5/1/2017';