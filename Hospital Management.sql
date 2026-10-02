CREATE TABLE Department (
  dept_Id INT PRIMARY KEY,
  dept_Name VARCHAR(100)
);

CREATE TABLE Room (
  room_No INT PRIMARY KEY,
  dept_Id INT REFERENCES Department(dept_Id),
  room_Type VARCHAR(100)
);

CREATE TABLE Doctor (
  doct_Id INT PRIMARY KEY,
  dept_Id INT REFERENCES Department(dept_Id),
  FName VARCHAR(100), LName VARCHAR(100),
  Gender CHAR(1), contact_No VARCHAR(100),
  surgeon_Type VARCHAR(100),
  office_No INT REFERENCES Room(room_No)
);

CREATE TABLE Nurse (
  nurse_Id INT PRIMARY KEY,
  dept_Id INT REFERENCES Department(dept_Id),
  FName VARCHAR(100), LName VARCHAR(100),
  Gender CHAR(1), contact_No VARCHAR(100)
);

CREATE TABLE Helpers (
  helper_Id INT PRIMARY KEY,
  dept_Id INT REFERENCES Department(dept_Id),
  FName VARCHAR(100), LName VARCHAR(100),
  Gender CHAR(1), contact_No VARCHAR(100)
);

CREATE TABLE Ward (
  ward_No INT PRIMARY KEY,
  ward_Name VARCHAR(100),
  dept_Id INT REFERENCES Department(dept_Id)
);

CREATE TABLE Bed (
  bed_No INT PRIMARY KEY,
  ward_No INT REFERENCES Ward(ward_No)
);

CREATE TABLE Patients (
  patient_Id INT PRIMARY KEY,
  FName VARCHAR(100), LName VARCHAR(100),
  Gender CHAR(1), Date_Of_Birth DATE,
  contact_No VARCHAR(100), pt_Address VARCHAR(100)
);

CREATE TABLE BedRecords (
  admission_Id INT PRIMARY KEY,
  bed_No INT REFERENCES Bed(bed_No),
  patient_Id INT REFERENCES Patients(patient_Id),
  nurse_Id INT REFERENCES Nurse(nurse_Id),
  helper_Id INT REFERENCES Helpers(helper_Id),
  admission_Date DATE, discharge_Date DATE,
  amount INT, mode_of_payment VARCHAR(50)
);

CREATE TABLE RoomRecords (
  admission_Id INT PRIMARY KEY,
  room_No INT REFERENCES Room(room_No),
  patient_Id INT REFERENCES Patients(patient_Id),
  nurse_Id INT REFERENCES Nurse(nurse_Id),
  helper_Id INT REFERENCES Helpers(helper_Id),
  admission_Date DATE, discharge_Date DATE,
  amount INT, mode_of_payment VARCHAR(50)
);

CREATE TABLE Appointment (
  appointment_Id INT PRIMARY KEY,
  patient_Id INT REFERENCES Patients(patient_Id),
  doct_Id INT REFERENCES Doctor(doct_Id),
  reason VARCHAR(100), appointment_Date DATE,
  payment_amount INT, mode_of_payment VARCHAR(100),
  mode_of_appointment VARCHAR(100),
  appointment_status VARCHAR(100)
);

CREATE TABLE MedicalRecord (
  record_Id INT PRIMARY KEY,
  doct_Id INT REFERENCES Doctor(doct_Id),
  patient_Id INT REFERENCES Patients(patient_Id),
  visit_Date DATE,
  curr_Weight DECIMAL(10,2), curr_height DECIMAL(10,2),
  curr_Blood_Pressure VARCHAR(100), curr_Temp_F DECIMAL(10,2),
  diagnosis VARCHAR(500), treatment VARCHAR(100),
  next_Visit DATE
);

CREATE TABLE StaffShift (
  shift_Id INT PRIMARY KEY,
  doct_Id INT REFERENCES Doctor(doct_Id),
  nurse_Id INT REFERENCES Nurse(nurse_Id),
  helper_Id INT REFERENCES Helpers(helper_Id),
  shift_Date DATE, shift_Start TIME, shift_End TIME
);

CREATE TABLE SurgeryRecord (
  surgery_Id INT PRIMARY KEY,
  patient_Id INT REFERENCES Patients(patient_Id),
  surgeon_Id INT REFERENCES Doctor(doct_Id),
  surgery_Type VARCHAR(100), surgery_Date DATE,
  start_Time TIME, end_Time TIME,
  room_No INT REFERENCES Room(room_No),
  notes VARCHAR(1000),
  nurse_Id INT REFERENCES Nurse(nurse_Id),
  helper_Id INT REFERENCES Helpers(helper_Id)
);;;-

INSERT INTO Department VALUES
(101,'Cardiology'),(102,'Neurology'),(103,'Gastroenterology'),(104,'Nephrology'),
(105,'Pulmonology'),(106,'Endocrinology'),(107,'General Medicine'),(108,'Pediatrics'),
(109,'Orthopedics'),(110,'Gynecology'),(111,'Dentistry'),(112,'Dermatology'),
(113,'Psychiatry'),(114,'Psychology'),(115,'Urology'),(116,'ENT'),(117,'Surgery'),
(118,'Radiology'),(119,'Oncology'),(120,'Anesthesiology'),(121,'Emergency Medicine'),
(122,'Nutrition & Dietetics'),(123,'Rehabilitation'),(124,'Hematology'),
(125,'Immunology'),(126,'Audiology & Speech'),(127,'Homeopathy'),(128,'Sexology'),
(129,'Family Medicine'),(130,'Critical Care'),(131,'Geriatrics');

-- Rooms auto-generate (room_No = dept_Id*100 + number, jaise 10101)
INSERT INTO Room (room_No, dept_Id, room_Type)
SELECT d.dept_Id*100 + ROW_NUMBER() OVER (PARTITION BY d.dept_Id ORDER BY t.ord, g),
       d.dept_Id, t.rtype
FROM Department d
CROSS JOIN (VALUES (1,'Consultation Room',8),(2,'Super Deluxe Room',2),
                   (3,'Deluxe Room',2),(4,'Standard Room',2),
                   (5,'Emergency Room',1)) AS t(ord, rtype, cnt)
CROSS JOIN LATERAL generate_series(1, t.cnt) AS g
WHERE d.dept_Id <> 117;

-- Surgery dept: sirf Operation Theatres
INSERT INTO Room (room_No, dept_Id, room_Type)
SELECT 11700 + g, 117, 'Operation Theatre' FROM generate_series(1,10) g;

-- Sample data
INSERT INTO Doctor VALUES
(1,101,'Amit','Sharma','M','9800000001','Cardiac Surgeon',10101),
(2,102,'Neha','Verma','F','9800000002','Neuro Surgeon',10201),
(3,117,'Rahul','Singh','M','9800000003','General Surgeon',11701),
(4,108,'Priya','Gupta','F','9800000004',NULL,10801);

INSERT INTO Nurse VALUES
(1,101,'Sunita','Rao','F','9811111111'),
(2,117,'Kavita','Joshi','F','9822222222');

INSERT INTO Helpers VALUES
(1,101,'Ramesh','Kumar','M','9833333333'),
(2,117,'Suresh','Yadav','M','9844444444');

INSERT INTO Ward VALUES (1,'Cardiac Ward',101),(2,'General Ward',107);
INSERT INTO Bed VALUES (1,1),(2,1),(3,2),(4,2);

INSERT INTO Patients VALUES
(1,'Rohan','Mehta','M','1990-05-12','9900000001','Delhi'),
(2,'Anjali','Das','F','1985-08-23','9900000002','Mumbai'),
(3,'Vikas','Jain','M','2000-01-15','9900000003','Pune');

INSERT INTO BedRecords VALUES
(1,1,1,1,1,'2026-09-01','2026-09-05',15000,'Card'),
(2,3,2,1,1,'2026-09-10','2026-09-12',8000,'Cash');

INSERT INTO RoomRecords VALUES
(1,10111,3,1,1,'2026-09-15','2026-09-18',12000,'UPI');

NSERT INTO Appointment VALUES
(1,1,1,'Chest pain','2026-09-20',800,'UPI','Online','Completed'),
(2,2,2,'Headache','20I26-09-22',700,'Cash','Offline','Scheduled'),
(3,3,4,'Fever','2026-09-25',500,'Card','Offline','Completed');

INSERT INTO MedicalRecord VALUES
(1,1,1,'2026-09-20',72.5,175,'130/85',98.6,'Angina','Medication','2026-10-20');

INSERT INTO StaffShift VALUES
(1,1,1,1,'2026-09-30','09:00','17:00');

INSERT INTO SurgeryRecord VALUES
(1,1,3,'Appendectomy','2026-09-28','10:00','12:00',11701,'Successful',2,2);



-- 1. Basic
SELECT * FROM Department;
SELECT * FROM Patients WHERE Gender = 'F';

-- 2. Count
SELECT room_Type, COUNT(*) FROM Room GROUP BY room_Type;

-- 3. JOIN: doctor aur unka department
SELECT d.FName, d.LName, dep.dept_Name
FROM Doctor d JOIN Department dep ON d.dept_Id = dep.dept_Id;

-- 4. Appointment with patient + doctor name
SELECT p.FName AS patient, d.FName AS doctor, a.reason, a.appointment_Date
FROM Appointment a
JOIN Patients p ON a.patient_Id = p.patient_Id
JOIN Doctor d ON a.doct_Id = d.doct_Id;

-- 5. Har department ke rooms
SELECT dep.dept_Name, COUNT(r.room_No) AS total_rooms
FROM Department dep LEFT JOIN Room r ON dep.dept_Id = r.dept_Id
GROUP BY dep.dept_Name ORDER BY total_rooms DESC;

-- 6. Total kamai (bed + room)
SELECT SUM(amount) FROM (
  SELECT amount FROM BedRecords
  UNION ALL
  SELECT amount FROM RoomRecords
) x;

-- 7. Kitne din admit raha (PostgreSQL me date subtract = days)
SELECT patient_Id, discharge_Date - admission_Date AS days_stayed
FROM BedRecords;

-- 8. Age nikalna
SELECT FName, DATE_PART('year', AGE(Date_Of_Birth)) AS age FROM Patients;




-- EASY ----------------------------------------
-- Q1. Cardiology department ke doctors dikhao
SELECT d.FName, d.LName
FROM Doctor d JOIN Department dep ON d.dept_Id = dep.dept_Id
WHERE dep.dept_Name = 'Cardiology';

-- Q2. 30 saal se bade patients (naam + age)
SELECT FName, DATE_PART('year', AGE(Date_Of_Birth)) AS age
FROM Patients
WHERE DATE_PART('year', AGE(Date_Of_Birth)) > 30;

-- Q3. Payment mode ke hisab se appointments ginti
SELECT mode_of_payment, COUNT(*) AS total
FROM Appointment GROUP BY mode_of_payment;

-- Q4. Completed appointments ki total payment
SELECT SUM(payment_amount) FROM Appointment
WHERE appointment_status = 'Completed';

-- MEDIUM --------------------------------------
-- Q5. Wo patients jo kabhi bed par admit nahi hue
SELECT p.FName, p.LName
FROM Patients p LEFT JOIN BedRecords b ON p.patient_Id = b.patient_Id
WHERE b.admission_Id IS NULL;

-- Q6. Har doctor ki appointments (0 wale bhi dikhao)
SELECT d.FName, COUNT(a.appointment_Id) AS total_appts
FROM Doctor d LEFT JOIN Appointment a ON d.doct_Id = a.doct_Id
GROUP BY d.doct_Id, d.FName;

-- Q7. Surgery details: patient, surgeon, room
SELECT p.FName AS patient, d.FName AS surgeon,
       s.surgery_Type, s.surgery_Date, s.room_No
FROM SurgeryRecord s
JOIN Patients p ON s.patient_Id = p.patient_Id
JOIN Doctor d ON s.surgeon_Id = d.doct_Id;

-- Q8. Wo admissions jinka amount average se zyada hai (subquery)
SELECT * FROM BedRecords
WHERE amount > (SELECT AVG(amount) FROM BedRecords);

-- Q9. Har patient ka total hospital kharcha (bed + room + appointment)
SELECT p.FName, SUM(t.amt) AS total_spent
FROM Patients p
JOIN (
  SELECT patient_Id, amount AS amt FROM BedRecords
  UNION ALL
  SELECT patient_Id, amount FROM RoomRecords
  UNION ALL
  SELECT patient_Id, payment_amount FROM Appointment
) t ON p.patient_Id = t.patient_Id
GROUP BY p.patient_Id, p.FName
ORDER BY total_spent DESC;

-- HARD ----------------------------------------
-- Q10. Doctors ko appointments ke hisab se RANK karo
SELECT d.FName, COUNT(a.appointment_Id) AS appts,
       RANK() OVER (ORDER BY COUNT(a.appointment_Id) DESC) AS rnk
FROM Doctor d LEFT JOIN Appointment a ON d.doct_Id = a.doct_Id
GROUP BY d.doct_Id, d.FName;

-- Q11. Har department me kitne staff hain (doctor + nurse + helper)
SELECT dep.dept_Name,
  (SELECT COUNT(*) FROM Doctor  WHERE dept_Id = dep.dept_Id) AS doctors,
  (SELECT COUNT(*) FROM Nurse   WHERE dept_Id = dep.dept_Id) AS nurses,
  (SELECT COUNT(*) FROM Helpers WHERE dept_Id = dep.dept_Id) AS helpers
FROM Department dep
ORDER BY doctors DESC;

-- Q12. View banao: appointments with patient + doctor naam
CREATE VIEW appointment_details AS
SELECT a.appointment_Id, p.FName AS patient, d.FName AS doctor,
       a.reason, a.appointment_Date, a.appointment_status
FROM Appointment a
JOIN Patients p ON a.patient_Id = p.patient_Id
JOIN Doctor d ON a.doct_Id = d.doct_Id;

SELECT * FROM appointment_details WHERE appointment_status = 'Scheduled';