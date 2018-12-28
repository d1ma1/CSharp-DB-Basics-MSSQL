
CREATE TABLE Users (
	Id INT UNIQUE IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] NVARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(2),
	LastLoginTime DATE,
	IsDeleted BIT NOT NULL 
)

ALTER TABLE Users
	ADD CONSTRAINT PK_Users
	PRIMARY KEY (Id)

INSERT INTO Users (Username,[Password], ProfilePicture, LastLoginTime, IsDeleted) VALUES
	('Klara', 1213141516, NULL, '01/01/2018', 0),
	('Petrov', 1213141516, NULL, '01/01/2018', 0),
	('Goshov', 1213141516, NULL, '01/01/2018', 0),
	('Milev', 1213141516, NULL, '01/01/2018', 0),
	('Ceco', 1213141516, NULL, '01/01/2018', 0)

SELECT * FROM Users