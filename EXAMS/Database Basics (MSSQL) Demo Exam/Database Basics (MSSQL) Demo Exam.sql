
/* 01 */

create table Planets(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL
)

create table Spaceports(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PlanetId INT FOREIGN KEY REFERENCES Planets(Id) NOT NULL
)

create table Spaceships(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT Default(0)
)

create table Colonists(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Ucn VARCHAR(10) UNIQUE NOT NULL,
	BirthDate date not null
)

create table Journeys(
	Id INT PRIMARY KEY IDENTITY,
	JourneyStart DateTime NOT NULL,
	JourneyEnd DateTime NOT NULL,
	Purpose VARCHAR(11) CHECK(Purpose IN('Medical', 'Technical', 'Educational', 'Military')),
	DestinationSpaceportId INT FOREIGN KEY REFERENCES Spaceports(Id) NOT NULL,
	SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id) NOT NULL 
)

create table TravelCards(
	Id INT PRIMARY KEY IDENTITY,
	CardNumber VARCHAR(10) NOT NULL UNIQUE,
	JobDuringJourney VARCHAR(8) CHECK(JobDuringJourney IN('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
	ColonistId INT FOREIGN KEY REFERENCES Colonists(Id) NOT NULL,
	JourneyId INT FOREIGN KEY REFERENCES Journeys(Id) NOT NULL,
)

/* 02 */

INSERT INTO Planets VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

insert into Spaceships values
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX', 1),
('Bed', 'Vidolov', 6)


/* 03 */

UPDATE Spaceships
	SET LightSpeedRate+=1
	WHERE Id BETWEEN 8 AND 12

/* 04 */

delete from TravelCards where JourneyId IN (1,2,3)
delete from Journeys where Id IN (1,2,3)

/* 05 */

select CardNumber, JobDuringJourney from TravelCards
	order by CardNumber

/* 06 */

select Id, FirstName + ' ' + LastName, Ucn from Colonists
	order by FirstName, LastName, Id

/* 07 */

select Id, FORMAT(JourneyStart,'dd/MM/yyyy'), FORMAT(JourneyEnd,'dd/MM/yyyy') from Journeys
	where Purpose = 'Military'
	order by JourneyStart asc

/* 08 */

select c.Id, FirstName + ' ' + LastName from Colonists c
	join TravelCards tc on tc.ColonistId = c.Id
	where JobDuringJourney = 'Pilot'
	order by Id

/* 09 */

select COUNT(*) from Colonists c
	join TravelCards tc on tc.ColonistId = c.Id
	join Journeys j on j.Id = tc.JourneyId
	where Purpose = 'Technical'

/* 10 */

select Top(1) s.Name, sp.Name from Spaceships s
	join Journeys j on j.SpaceshipId = s.Id
	join Spaceports sp on sp.Id = j.DestinationSpaceportId
	order by LightSpeedRate desc

/* 11 */
	
select DISTINCT ss.Name, Manufacturer from Spaceships ss
	join Journeys j on j.SpaceshipId = ss.Id
	join TravelCards tc on tc.JourneyId = j.Id
	join Colonists c on c.Id = tc.ColonistId
	where BirthDate > '01/01/1989' AND tc.JobDuringJourney = 'Pilot'
	order by ss.Name

/* 12 */

select p.Name, sp.Name from Planets p 
	join Spaceports sp on sp.PlanetId = p.Id
	join Journeys j on j.DestinationSpaceportId = sp.Id
	where Purpose = 'Educational'
	order by sp.Name desc

/*  13 */

select p.Name, COUNT(sp.Id) from Spaceports sp
	join Journeys j on j.DestinationSpaceportId = sp.Id
	join Planets p on p.Id = sp.PlanetId
	group by p.Name
	order by COUNT(sp.Id) desc, p.Name

/* 14 */

select K.jId, K.pName, K.spName, K.purpose from
(select Top 1 j.Id as jId, sp.Name as spName, p.Name as pName, Purpose as purpose, MIN(DATEDIFF(MINUTE, JourneyStart, JourneyEnd)) AS duration from Spaceports sp
	join Journeys j on j.DestinationSpaceportId = sp.Id
	join Planets p on p.Id = sp.PlanetId
	GROUP BY sp.Name, p.Name, Purpose, j.Id
	order by duration) AS K

/* 15 */

select Top 1 tc.JourneyId, tc.JobDuringJourney from TravelCards tc
	where tc.JourneyId = (select Top 1 js.Id from Journeys js order by DATEDIFF(MINUTE, js.JourneyStart, js.JourneyEnd) desc)
	group by tc.JourneyId, tc.JobDuringJourney
	order by COUNT(tc.JobDuringJourney)

/* 16 */

/* 17 */

select p.Name, COUNT(sp.Id) from Planets p
	left join Spaceports sp on sp.PlanetId = p.Id
	group by p.Name
	order by COUNT(sp.Id) desc, p.Name asc

-- 19

drop function udf_GetColonistsCount
go

create function udf_GetColonistsCount(@PlanetName VARCHAR (30))
	RETURNS INT
	AS
		begin
			RETURN (select Count(tc.ColonistId) as Count from Planets p
			join Spaceports sp on sp.PlanetId = p.Id
			join Journeys j on j.DestinationSpaceportId = sp.Id
			Join TravelCards tc on tc.JourneyId = j.Id
			where p.Name = @PlanetName)
		end 

-- 19

CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11) )  AS

		IF NOT EXISTS(SELECT Id FROM Journeys WHERE Id = @JourneyId)
			BEGIN
				RAISERROR ('The journey does not exist!', 16,1)
				RETURN
			END

		IF (SELECT Purpose FROM Journeys WHERE Id = @JourneyId) = @NewPurpose
			BEGIN
				RAISERROR ('You cannot change the purpose!', 16, 1)
				RETURN
			END

			BEGIN
				UPDATE Journeys SET Purpose = @NewPurpose WHERE Id = @JourneyId
			END

EXEC usp_ChangeJourneyPurpose 1, 'Technical'
SELECT * FROM Journeys
EXEC usp_ChangeJourneyPurpose 2, 'Educational'
EXEC usp_ChangeJourneyPurpose 196, 'Technical'

-- 20

CREATE TABLE DeletedJourneys (Id INT, JourneyStart date, JourneyEnd date, Purpose varchar(11), DestinationSpaceportId int, SpaceshipId int)

CREATE TRIGGER tr_Deleted ON OrderItems AFTER DELETE AS
	BEGIN
		INSERT INTO DeletedOrders
		SELECT d.OrderId, d.ItemId, d.Quantity FROM deleted d
	END