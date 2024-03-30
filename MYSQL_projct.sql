CREATE TABLE Student
(
Student_id int PRIMARY KEY,
Student_name varchar(20) Not NULL,
Major varchar(20) UNIQUE,
);

ALTER TABLE Student
ADD GPA decimal(3,2) DEFAULT 'unknown';

DROP TABLE Student

ALTER TABLE Student
DROP COLUMN GPA;

SELECT * 
FROM Student;

UPDATE Student
SET Major= 'Bio'
WHERE Major= 'Biology';

UPDATE Student
SET Major= 'Bio-Agro'
WHERE Major= 'Bio' OR Major='Agric Science';

DELETE FROM Student
WHERE Student_id=5

SELECT * 
FROM Student;

SELECT Student_name 
FROM Student;

SELECT Student_name,Major 
FROM Student;

SELECT Student.Student_name,Student.Major 
FROM Student
ORDER BY Student_name;

SELECT Student.Student_name,Student.Major 
FROM Student
ORDER BY Student_name;

SELECT * 
FROM Student
WHERE Major= 'Bio' OR Major='Civil Eng';

SELECT * 
FROM Student
WHERE Student_id<=3;

SELECT * 
FROM Student
WHERE Student_id<=3 AND Student_name<> 'Wale';

SELECT * 
FROM Student
WHERE Student_name IN ('Yanky','Sade');

SELECT * 
FROM Student
WHERE Major IN ('Bio','Civil Eng');

SELECT * 
FROM Student
WHERE Major IN ('Bio','Civil Eng') AND Student_id>2;

CREATE TABLE Employee
(
Emp_id int ,
First_name varchar(10),
Last_name varchar(10),
Birth_date date,
Sex varchar(5),
Salary int,
Super_id int,
Branch_id int,
);

ALTER TABLE Employee
ADD PRIMARY KEY(Emp_id) 
ON DELETE SET NULL;

ALTER TABLE Employee
ADD FOREIGN KEY(Branch_id)
REFERENCES Branch(Branch_id)
ON DELETE SET NULL;


SELECT * 
FROM Employee;

CREATE TABLE Branch
(
Branch_id int,
Branch_name varchar(10),
Mgr_id int,
Mgr_Start_date date,
);
Drop TABLE Branch;
SELECT * 
FROM  Branch Supplier;
SELECT * 
FROM  Branch;

CREATE TABLE Works_With
(
Emp_id int,
Client_id int,
Total_Sale int,
Mgr_Start_date date,
);
ALTER TABLE Works_With
DROP COLUMN Mgr_Start_date;

SELECT * 
FROM  Works_With;

UPDATE Employee
SET Emp_id='PRIMARY KEY';
