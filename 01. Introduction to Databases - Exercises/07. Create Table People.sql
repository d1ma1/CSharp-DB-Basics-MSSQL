CREATE TABLE People (
	Id INT UNIQUE IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(2),
	Height  float(15),
	[Weight] FLOAT(15),
	Gender CHAR(1) NOT NULL CHECK (Gender IN('m', 'f')),
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(max)
)

ALTER TABLE People
ADD CONSTRAINT PK_People
   PRIMARY KEY(Id) 

INSERT INTO People ([Name], Picture, Height, [Weight], Gender, Birthdate, Biography) VALUES 
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')

	
SELECT * FROM People
