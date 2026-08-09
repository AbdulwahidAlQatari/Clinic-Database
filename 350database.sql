-- ============================================================
-- Smart Clinic Database System 
-- ============================================================

DROP DATABASE IF EXISTS SmartClinicDB;
CREATE DATABASE SmartClinicDB;
USE SmartClinicDB;

-- Create table Department

CREATE TABLE Department (
    DepartmentID     INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName   VARCHAR(50) NOT NULL UNIQUE,
    Location         VARCHAR(100) NOT NULL,
    PhoneExtension   VARCHAR(10) NOT NULL
);


-- Create table Patient 

CREATE TABLE Patient (
    PatientID         INT PRIMARY KEY AUTO_INCREMENT,
    FirstName         VARCHAR(30) NOT NULL,
    LastName          VARCHAR(30) NOT NULL,
    Gender            ENUM('Male','Female') NOT NULL,
    DateOfBirth       DATE NOT NULL,
    Phone             VARCHAR(10) NOT NULL UNIQUE,   
    Email             VARCHAR(50) NOT NULL UNIQUE,
    Address           VARCHAR(100),
    BloodType         VARCHAR(5),
    EmergencyContact  VARCHAR(50)
);

-- Create table Employee 

CREATE TABLE Employee (
    EmployeeID    INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentID  INT NOT NULL,
    FirstName     VARCHAR(30) NOT NULL,
    LastName      VARCHAR(30) NOT NULL,
    Gender        ENUM('Male','Female') NOT NULL,
    DateOfBirth   DATE NOT NULL,
    Phone         VARCHAR(10) NOT NULL UNIQUE,   
    Email         VARCHAR(50) NOT NULL UNIQUE,
    HireDate      DATE NOT NULL,
    Salary        DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Room

CREATE TABLE Room (
    RoomID       INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentID INT NOT NULL,
    RoomNumber   VARCHAR(10) NOT NULL UNIQUE,
    RoomType     VARCHAR(30) NOT NULL,
    Floor        INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Doctor 

CREATE TABLE Doctor (
    EmployeeID      INT PRIMARY KEY,
    RoomID          INT NOT NULL UNIQUE,
    LicenseNumber   VARCHAR(30) NOT NULL UNIQUE,
    Qualification   VARCHAR(50) NOT NULL,
    Specialty       VARCHAR(50) NOT NULL,
    ConsultationFee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Nurse

CREATE TABLE Nurse (
    EmployeeID   INT PRIMARY KEY,
    RoomID       INT NOT NULL UNIQUE,
    Shift        ENUM('Morning','Evening','Night') NOT NULL,
    Qualification VARCHAR(50) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Pharmacist 

CREATE TABLE Pharmacist (
    EmployeeID    INT PRIMARY KEY,
    RoomID        INT NOT NULL UNIQUE,
    LicenseNumber VARCHAR(30) NOT NULL UNIQUE,
    Qualification VARCHAR(50) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Staff 

CREATE TABLE Staff (
    EmployeeID INT PRIMARY KEY,
    RoomID     INT NOT NULL UNIQUE,
    JobTitle   VARCHAR(50) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Appointment

CREATE TABLE Appointment (
    AppointmentID   INT PRIMARY KEY AUTO_INCREMENT,
    PatientID       INT NOT NULL,
    DoctorID        INT NOT NULL,   -- references Doctor(EmployeeID)
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status          ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
    Reason          VARCHAR(150),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Treatment

CREATE TABLE Treatment (
    TreatmentID      INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID    INT NOT NULL,
    TreatmentName    VARCHAR(100) NOT NULL,
    Diagnosis        VARCHAR(100) NOT NULL,
    Notes            TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Create table Medicine

CREATE TABLE Medicine (
    MedicineID    INT PRIMARY KEY AUTO_INCREMENT,
    MedicineName  VARCHAR(50) NOT NULL UNIQUE,
    Category      VARCHAR(50) NOT NULL,
    UnitPrice     DECIMAL(8,2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    ExpiryDate    DATE NOT NULL
);


-- Create table Prescription

CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    TreatmentID    INT NOT NULL,
    MedicineID     INT NOT NULL,
    Dosage         VARCHAR(30) NOT NULL,
    Duration       VARCHAR(30) NOT NULL,
    FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Create table Payment

CREATE TABLE Payment (
    PaymentID      INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID  INT NOT NULL UNIQUE,
    Amount         DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    PaymentDate    DATE NOT NULL,
    PaymentMethod  ENUM('Cash','Card','Insurance') NOT NULL,
    PaymentStatus  ENUM('Paid','Pending','Refunded') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- INSERT sample data


INSERT INTO Department (DepartmentName, Location, PhoneExtension) VALUES
('Cardiology', 'Building A, 2nd Floor', '101'),
('Pediatrics', 'Building A, 1st Floor', '102'),
('Orthopedics', 'Building B, 3rd Floor', '103'),
('Dermatology', 'Building B, 2nd Floor', '104'),
('General Medicine', 'Building A, 1st Floor', '105');


INSERT INTO Patient
(FirstName, LastName, Gender, DateOfBirth, Phone, Email, Address, BloodType, EmergencyContact)
VALUES
('Ahmed', 'alfahid', 'Male', '1990-05-15', '0501110001', 'ahmed.alfahid@gmail.com', 'King Salman, Riyadh', 'O+', '0502220001'),
('Fatima', 'alharbi', 'Female', '1985-08-22', '0501110002', 'fatima.alharbi@gmail.com', 'Almalga, Riyadh', 'A+', '0502220002'),
('Mohammed', 'alotaibi', 'Male', '1978-12-03', '0501110003', 'mohammed.alotaibi@gmail.com', 'Alnaseem, Riyadh', 'B+', '0502220003'),
('Sara', 'alghamdi', 'Female', '1995-07-19', '0501110004', 'sara.alghamdi@gmail.com', 'Alsafart, Riyadh', 'AB+', '0502220004'),
('Noura', 'alsaud', 'Female', '2000-01-30', '0501110005', 'noura.alsaud@gmail.com', 'Alsafart, Riyadh', 'O-', '0502220005');


INSERT INTO Employee
(FirstName, LastName, Gender, DateOfBirth, Phone, Email, HireDate, Salary, DepartmentID)
VALUES

('Saud', 'alghamdi', 'Male',   '1980-03-10', '0551000001', 'saud.alghamdi@Nawafclinic.com', '2015-06-01', 22000.00, 1),
('Maha',   'alqahtani', 'Female','1982-07-25', '0551003002', 'maha.alqahtani@Nawafclinic.com', '2016-09-15', 21000.00, 2),
('Abdullah','alharbi','Male',   '1979-11-02', '0551000003', 'abdullah.alharbi@Nawafclinic.com', '2014-04-10', 23000.00, 3),
('Sara',  'almutairi', 'Female','1985-02-14',  '0551001104', 'sara.almutairi@Nawafclinic.com', '2017-12-01', 20500.00, 4),
('Faisal',  'alzahrani','Male',   '1983-09-09', '0551000005', 'faisal.alzahrani@Nawafclinic.com', '2018-01-20', 24000.00, 5),

('Laila',  'alshammari','Female','1990-04-18', '0551004506', 'laila.alshammari@Nawafclinic.com', '2020-03-01', 12000.00, 1),
('Omar',   'alotaibi', 'Male',   '1988-06-30', '0551000332', 'omar.alotaibi@Nawafclinic.com', '2019-07-15', 11500.00, 2),
('Reem',   'alharbi', 'Female','1992-10-12', '0551000008', 'reem.alharbi@Nawafclinic.com', '2021-02-20', 11800.00, 3),
('Khalid',  'alsubaie','Male',   '1986-12-05', '0551000009', 'khalid.alsubaie@Nawafclinic.com', '2018-08-01', 12200.00, 4),
('Hanan',  'alenezi', 'Female','1991-05-22', '0551000010', 'hanan.alenezi@Nawafclinic.com', '2020-11-10', 12000.00, 5),

('Naser',  'aldosari','Male',   '1984-08-19', '0551000011', 'naser.aldosari@Nawafclinic.com', '2016-05-05', 14000.00, 1),
('Mona',   'alrasheed', 'Female','1987-03-27', '0551000012', 'mona.alrasheed@Nawafclinic.com', '2017-09-12', 13800.00, 2),
('Turki',  'alshammari','Male',   '1982-07-07', '0551000013', 'turki.alshammari@Nawafclinic.com', '2015-11-01', 14500.00, 3),
('Huda',   'aljuhani', 'Female','1993-01-11', '0551000014', 'hoda.aljuhani@Nawafclinic.com', '2019-04-18', 13500.00, 4),
('Salman', 'alkhaldi','Male',   '1989-09-15', '0551000015', 'salman.alkhaldi@Nawafclinic.com', '2020-02-28', 14200.00, 5),

('Amal',   'albalawi', 'Female','1992-06-21', '0551067016', 'amal.albalawi@Nawafclinic.com', '2021-01-10', 9000.00, 1),
('Fahad',   'aldhib',  'Male',   '1988-10-02', '0551080047', 'fahad.aldhib@Nawafclinic.com', '2019-08-14', 9500.00, 2),
('Nawal',  'Alsubaie','Female','1990-04-09', '0551202018', 'nawal.alsubaie@Nawafclinic.com', '2020-05-20', 8800.00, 3),
('Majed',  'alhumaidi','Male',   '1985-12-25', '0541000019', 'majed.alhumaidi@Nawafclinic.com', '2017-07-01', 9700.00, 4),
('Jawhar','Alenezi','Female','1994-02-28', '0557089020', 'jawhar.alenezi@Nawafclinic.com', '2022-03-15', 9200.00, 5);


INSERT INTO Room (DepartmentID, RoomNumber, RoomType, Floor) VALUES
(1, 'R101', 'Examination', 2),
(2, 'R102', 'Consultation', 1),
(3, 'R201', 'Treatment', 3),
(4, 'R202', 'Examination', 2),
(5, 'R103', 'Consultation', 1);


INSERT INTO Doctor (EmployeeID, RoomID, LicenseNumber, Qualification, Specialty, ConsultationFee) VALUES
(1, 1, 'LIC-D001', 'MD, Board Certified', 'Cardiologist', 250.00),
(2, 2, 'LIC-D002', 'MD, Pediatrics', 'Pediatrician', 200.00),
(3, 3, 'LIC-D003', 'MD, Orthopedics', 'Orthopedic Surgeon', 300.00),
(4, 4, 'LIC-D004', 'MD, Dermatology', 'Dermatologist', 220.00),
(5, 5, 'LIC-D005', 'MD, Internal Medicine', 'General Physician', 180.00);


INSERT INTO Nurse (EmployeeID, RoomID, Shift, Qualification) VALUES
(6, 1, 'Morning', 'BSN, Registered Nurse'),
(7, 2, 'Evening', 'BSN, Registered Nurse'),
(8, 3, 'Night', 'Diploma in Nursing'),
(9, 4, 'Morning', 'BSN, Registered Nurse'),
(10, 5, 'Evening', 'RN, Critical Care');


INSERT INTO Pharmacist (EmployeeID, RoomID, LicenseNumber, Qualification) VALUES
(11, 1, 'LIC-P001', 'BPharm, Licensed Pharmacist'),
(12, 2, 'LIC-P002', 'BPharm, Licensed Pharmacist'),
(13, 3, 'LIC-P003', 'PharmD, Clinical Pharmacy'),
(14, 4, 'LIC-P004', 'BPharm, Licensed Pharmacist'),
(15, 5, 'LIC-P005', 'PharmD, Clinical Pharmacy');


INSERT INTO Staff (EmployeeID, RoomID, JobTitle) VALUES
(16, 1, 'Receptionist'),
(17, 2, 'Administrative Assistant'),
(18, 3, 'Medical Records Clerk'),
(19, 4, 'Billing Specialist'),
(20, 5, 'Patient Coordinator');


INSERT INTO Appointment
(PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Reason)
VALUES
(1, 1, '2026-05-01', '09:00:00', 'Completed', 'Chest pain follow-up'),
(2, 2, '2026-06-07', '10:30:00', 'Completed', 'Routine child vaccination'),
(3, 3, '2026-07-08', '11:15:00', 'Completed', 'Knee pain assessment'),
(4, 4, '2026-08-04', '13:00:00', 'Scheduled', 'Skin rash examination'),
(5, 5, '2026-09-01', '14:45:00', 'Scheduled', 'General health checkup');


INSERT INTO Treatment
(AppointmentID, TreatmentName, Diagnosis, Notes)
VALUES
(1, 'Medication Therapy', 'Stable Angina', 'Prescribed cholesterol-lowering medication and lifestyle modifications. Schedule follow-up after two weeks.'),
(2, 'Immunization', 'Routine Immunization', 'MMR vaccine administered successfully. Patient observed for 15 minutes with no adverse reactions.'),
(3, 'Pain Management', 'Knee Osteoarthritis', 'Prescribed pain relief medication and physiotherapy sessions. Daily stretching exercises recommended.'),
(4, 'Topical Treatment', 'Eczema', 'Topical corticosteroid cream prescribed. Avoid skin irritants and moisturize regularly.'),
(5, 'General Checkup', 'General Health Assessment', 'Routine physical examination completed. No abnormal findings.');


INSERT INTO Medicine
(MedicineName, Category, UnitPrice, StockQuantity, ExpiryDate)
VALUES
('Atorvastatin 20mg', 'Cardiovascular', 25.50, 200, '2027-12-31'),
('MMR Vaccine', 'Immunization', 95.00, 80, '2026-11-30'),
('Ibuprofen 400mg', 'Analgesic', 8.75, 500, '2028-06-15'),
('Hydrocortisone Cream', 'Dermatology', 18.00, 150, '2027-08-20'),
('Multivitamin Tablets', 'Nutritional', 15.00, 250, '2028-01-10');


INSERT INTO Prescription
(TreatmentID, MedicineID, Dosage, Duration)
VALUES
(1, 1, '1 tablet', '30 days'),
(2, 2, '0.5 mL injection', 'Single dose'),
(3, 3, '1 tablet', '14 days'),
(4, 4, 'Apply a thin layer', '14 days'),
(5, 5, '1 tablet', '30 days');


INSERT INTO Payment
(AppointmentID, Amount, PaymentDate, PaymentMethod, PaymentStatus)
VALUES
(1, 250.00, '2026-05-02', 'Insurance', 'Paid'),
(2, 120.00, '2026-06-07', 'Cash', 'Paid'),
(3, 300.00, '2026-07-08', 'Card', 'Pending'),
(4, 180.00, '2026-08-04', 'Insurance', 'Paid'),
(5, 100.00, '2026-09-01', 'Card', 'Paid');






-- task 3 SELECT queires 
SELECT * FROM patient; 

SELECT EmployeeID, DepartmentID, Phone * FROM Employee; 

SELECT AppointmentID, AppointmentDate, AppointmentTime, STATUS FROM appointment WHERE STATUS = "Scheduled"; 


-- task JOIN queires

SELECT Patient.FirstName, patient.LastName, appointment.AppointmentDate, appointment.AppointmentTime, appointment.Status FROM patient JOIN appointment ON patient.PatientID = appointment.PatientID;

SELECT employee.FirstName, employee.LastName, staff.JobTitle FROM employee JOIN staff ON employee.EmployeeID = staff.EmployeeID;


-- task 3 Nasted queires

SELECT MedicineName,UnitPrice FROM medicine WHERE UnitPrice = ( SELECT MAX(UnitPrice) FROM medicine );

SELECT FirstName, LastName FROM employee WHERE Salary= ( SELECT MAX(Salary) FROM employee );

-- task 3 Aggregate functions with GROUP BY

SELECT 
     d.DepartmentName,
     COUNT (e.employeeID) AS TotalEmployee,
     AVG(e.salary) AS TheAverageSalary
FROM department d
JOIN employee e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;


-- task 3 UPDATE statment

Update appointment 
SET status = 'Cancelled'
Where appointmentID = 4;


SELECT * 
FROM appointment;

-- task 3 DELETE statment  

DELETE FROM payment 
WHERE PaymentID = 3 ;

SELECT * 
FROM payment;


-- task 3 VIEW
CREATE VIEW patientappointments AS
SELECT 
    p.patientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS patientFullName, 
    a.AppointmentDate,
    a.AppointmentTime,
    a.STATUS
FROM patient p
JOIN appointment a ON p.PatientID = a.PatientID;


-- task 3 TRIGGER
DELIMITER $$

CREATE TRIGGER before_appointment_insert
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF NEW.AppointmentDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The date could not be in the past!';
    END IF;
END $$

DELIMITER ;

INSERT INTO appointment (PatientID, DoctorID, AppointmentDate, AppointmentTime, STATUS) 
VALUES (1, 1, '2024-02-09', '13:00:00', 'Pending'); -- test the TRIGGER  
