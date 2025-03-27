
--Creating the Contract Physicians Table
CREATE TABLE ContractPhysicians(
    PhysicianID  CHAR(15),
    FirstName    VARCHAR(30),
    MiddleName   VARCHAR(30),
    LastName     VARCHAR(30),
    Pager#       CHAR(11),
    DEA#         CHAR(9) CHECK (LEFT(DEA#, 1) = 'A' OR LEFT(DEA#, 1) = 'B'  -- First letter is A or B
                         AND LEN(DEA#) = 9 )
    CONSTRAINT ContractPhysician_PK PRIMARY KEY(PhysicianID)
);


--Creating the Specialty Table 
CREATE TABLE Specialty(
    SpecialtyID     CHAR(15) PRIMARY KEY,
    SpecialtyName   VARCHAR(50)
);


--Creating the Drug Table 
CREATE TABLE Drug(
   NDCNumber             CHAR(11) PRIMARY KEY,
   DrugName              VARCHAR(50),
   TherapeuticUse        VARCHAR(100), 
   DrugStrengthPerDose   INT, 
   PackageQuantity       INT,
   Unit                  VARCHAR(30),
   AverageWholesalePrice MONEY,
   LegalClass            VARCHAR(20) CHECK (LegalClass IN ('Non-Prescription', 'Prescription Only',  
                         'Controlled Substance')) NOT NULL
 );

--Creating the Pharmacy Table 
CREATE TABLE Pharmacy(
   PharmacyID                  INT PRIMARY KEY, 
   HealingHorizonsPharmacyYN   VARCHAR(1) CHECK(HealingHorizonsPharmacyYN IN ('Y','N')),
   PharmacyName                VARCHAR(50)
);

--Creating the Specialty-Acquired Table 
CREATE TABLE SpecialtyAcquired(
    AcquiredSpecialtyID     CHAR(15) PRIMARY KEY,
    DateAcquired            DATE,
    PhysicianID             CHAR(15),
    SpecialtyID             CHAR(15),

    CONSTRAINT SpecialtyAcquiredPhysicianFK FOREIGN KEY (PhysicianID)
        REFERENCES ContractPhysicians (PhysicianID)
        ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT SpecialtyAcquiredSpecialtyFK FOREIGN KEY (SpecialtyID)
        REFERENCES SPECIALTY (SpecialtyID)
        ON UPDATE CASCADE ON DELETE NO ACTION 
);

--Creating the Drug On Hand Table 
CREATE TABLE DrugOnHand(
    PharmacyInventoryLogID  CHAR(15) PRIMARY KEY,
    QuantityOnHand          INT,
    NDCNumber               CHAR(11),
    PharmacyID              INT,

    CONSTRAINT DrugOnHandNDCFK FOREIGN KEY (NDCNumber)
        REFERENCES DRUG (NDCNumber)
        ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT DrugOnHandPharmFK FOREIGN KEY (PharmacyID)
        REFERENCES PHARMACY (PharmacyID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);


--Creating the Non-Prescription Table 
CREATE TABLE NonPrescription(
    NDCNumber       CHAR(11) PRIMARY KEY,
    OTCDrugName     VARCHAR(50),

    CONSTRAINT NonPrescriptionNDCFK FOREIGN KEY (NDCNumber)
        REFERENCES DRUG (NDCNumber)
        ON UPDATE CASCADE ON DELETE NO ACTION,
);

--Creating the Prescription-Only Table 
CREATE TABLE PrescriptionOnly(
   NDCNumber   CHAR(11) PRIMARY KEY,
   RxName      VARCHAR(50)
);
Creating the Controlled Substance Table 
CREATE TABLE ControlledSubstance(
    NDCNumber                 CHAR(11) PRIMARY KEY,
    ControlledSubstanceName   VARCHAR(30),
    Subclass                  VARCHAR(4) CHECK(Subclass IN ('CII','CIII','CIV','CV'))
);

--Creating the Patient Table 
CREATE TABLE Patient(
   PatientID          CHAR(6) PRIMARY KEY, --Changed to 6 digits
   PatientFirstName   VARCHAR(30),
   PatientLastName    VARCHAR(30),
   PatientAddress     VARCHAR(100),
   PhoneNumber        VARCHAR(11),
   InsuranceStatusYN  CHAR(1) NOT NULL CHECK(InsuranceStatusYN IN ('Y','N')),
);


--Creating the Insurance Receipt Table 
CREATE TABLE InsuranceReceipt(
   InsuranceReceipt#    CHAR(15) PRIMARY KEY,
   InsuranceName        VARCHAR(30),
   Cost                 MONEY CHECK (Cost != 0),
   PatientID            CHAR(6)

   CONSTRAINT InsuranceFK FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

--Creating the Clinic Table 
CREATE TABLE Clinic(
    ClinicID            INT PRIMARY KEY CHECK(ClinicID IN (1,2,3,4)),
    ClinicName          VARCHAR(50),
    ClinicAddress       VARCHAR(100),
    ClinicPhoneNumber   VARCHAR(11),
    PharmacyID          INT,

    CONSTRAINT Clinic_FK1 FOREIGN KEY (PharmacyID) 
         REFERENCES Pharmacy(PharmacyID)
            ON UPDATE CASCADE ON DELETE NO ACTION
);



--Creating the Contractor Clinic Assignment Table
CREATE TABLE ContractorClinicAssignment(
    ContractorClinicAssignmentID    CHAR(15) PRIMARY KEY,
    ContractorClinicAssignmentDate  DATE,
    StartTime                       TIME,
    EndTime                         TIME,
    ClinicID                        INT,
    PhysicianID                     CHAR(15),

    CONSTRAINT ContractorClinicAssignment_FK1 FOREIGN KEY (ClinicID) 
         REFERENCES Clinic(ClinicID)
            ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT ContractorClinicAssignment_FK2 FOREIGN KEY (PhysicianID) 
        REFERENCES ContractPhysicians(PhysicianID)
            ON UPDATE CASCADE ON DELETE NO ACTION
);

--Creating the Employee Table 
CREATE TABLE Employee(
EmployeeID          CHAR(15) PRIMARY KEY,
EmpFirstName        VARCHAR(30),
EmpMiddleInitial    CHAR(2),
EmpLastName         VARCHAR(30),
EmpAddress          VARCHAR(100),
PhoneNumber         CHAR(15),
EmployeeCategory    VARCHAR(20),
ClinicID            INT,

CONSTRAINT Employee_FK FOREIGN KEY (CLinicID)
    REFERENCES Clinic (ClinicID)
    ON UPDATE CASCADE ON DELETE NO ACTION
);


--Creating the Pharmacist Table 
CREATE TABLE Pharmacist(
EmployeeID                  CHAR(15) PRIMARY KEY,
PharmacistLicenseNumber     CHAR(9) NOT NULL, 
LicenseExpiry               DATE,
PharmacyID                  INT,

CONSTRAINT PharmacistEmpID FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID)
    ON UPDATE CASCADE ON DELETE NO ACTION,

CONSTRAINT PharmacistPharmacyID FOREIGN KEY (PharmacyID)
    REFERENCES Pharmacy (PharmacyID)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);


--Creating the Nurse Table 

CREATE TABLE Nurse(
EmployeeID          CHAR(15) PRIMARY KEY,
NurseLicenseNumber  CHAR(9) NOT NULL,
LicenseExpiry       DATE,

CONSTRAINT NurseEmpID FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID)
    ON UPDATE CASCADE ON DELETE NO ACTION
);


--Creating the Administrator Table 
CREATE TABLE Administrator(
EmployeeID      CHAR(15) PRIMARY KEY,
JobTitle        VARCHAR(50),

CONSTRAINT AdministratorEmpID FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID)
    ON UPDATE CASCADE ON DELETE NO ACTION
);


--Creating the Appointment Table 
CREATE TABLE Appointment(
    AppointmentID   INT CHECK (AppointmentID >= 1000000 AND AppointmentID < 5000000),
    ApptDate        DATE,
    ApptTime        TIME,
    Reason          VARCHAR(100),
    FeeCharged      MONEY CHECK (FeeCharged > 45),
    PatientID       CHAR(6),
    ClinicID        INT,
    PhysicianID     CHAR(15)

    CONSTRAINT Appointment_PK PRIMARY KEY(AppointmentID),

    CONSTRAINT Appointment_FK1 FOREIGN KEY(PatientID)
        REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT Appointment_FK2 FOREIGN KEY(ClinicID)
        REFERENCES Clinic(ClinicID)
        ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT Appointment_FK3 FOREIGN KEY(PhysicianID) --added
        REFERENCES ContractPhysicians(PhysicianID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);


--Creating the Prescription Table 
CREATE TABLE Prescription (
    Order#                  CHAR(15),
    PrescriptionDate        DATE,
    QuantityToBeDispensed   VARCHAR(30),
    PrescriptionUse         VARCHAR(30),
    PatientID               CHAR(6),
    PhysicianID             CHAR(15),
    NDCNumber               CHAR(11)

    CONSTRAINT Prescription_PK PRIMARY KEY(Order#),

    CONSTRAINT Prescription_FK1 FOREIGN KEY(PatientID)
        REFERENCES Patient(PatientID)
        ON UPDATE CASCADE ON DELETE NO ACTION,

    CONSTRAINT Prescription_FK2 FOREIGN KEY(PhysicianID) 
        REFERENCES ContractPhysicians(PhysicianID)
        ON UPDATE CASCADE ON DELETE NO ACTION,

     CONSTRAINT Prescription_FK3 FOREIGN KEY(NDCNumber)
        REFERENCES Drug(NDCNumber)
        ON UPDATE CASCADE ON DELETE NO ACTION,   
);


--Creating the Prescription Fulfillment Table 
CREATE TABLE PrescriptionFullfillment(
    PrescriptionFullFillment#       CHAR(15),
    Quantity                        INT,
    RefillYN                        CHAR(1) CHECK(RefillYN IN ('Y','N')),
    PrescriptionFullfillmentDate    DATE, 
    Price                           MONEY,
    Order#                          CHAR(15),
    PharmacyID                      INT,
    EmployeeID                      CHAR(15)

    CONSTRAINT PrescriptionFullfillment_PK PRIMARY KEY(PrescriptionFullfillment#),

    CONSTRAINT PrescriptionFullfillment_FK1 FOREIGN KEY (Order#)
        REFERENCES Prescription(Order#)
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT PrescriptionFullfillment_FK2 FOREIGN KEY (PharmacyID)
        REFERENCES Pharmacy(PharmacyID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT PrescriptionFullfillment_FK3 FOREIGN KEY (EmployeeID)
        REFERENCES Pharmacist(EmployeeID)
        ON UPDATE NO ACTION ON DELETE NO ACTION

);
 


--INSERT Statements

--Note: The following INSERT statements are arranged in sequential order

--Inserting Data into the Contract Physicians Table
INSERT INTO ContractPhysicians VALUES (100000000000001, 'John', 'A.', 'Smith', '11234567890', 'A12345678');
INSERT INTO ContractPhysicians VALUES (100000000000002, 'Sarah', 'B.', 'Jones', '19876543210', 'B87654321');
INSERT INTO ContractPhysicians VALUES (100000000000003, 'Michael', 'C.', 'Brown', '14561237890', 'A23456789');
INSERT INTO ContractPhysicians VALUES (100000000000004, 'Emily', 'D.', 'Davis', '13216540987', 'B34567890');
INSERT INTO ContractPhysicians VALUES (100000000000005, 'David', 'E.', 'Wilson', '16543219876', 'A45678901');
INSERT INTO ContractPhysicians VALUES (100000000000006, 'Laura', 'F.', 'Martinez', '17890123456', 'B56789012');
INSERT INTO ContractPhysicians VALUES (100000000000007, 'James', 'G.', 'Garcia', '10987654321', 'A67890123');
INSERT INTO ContractPhysicians VALUES (100000000000008, 'Linda', 'H.', 'Miller', '11230987654', 'B78901234');
INSERT INTO ContractPhysicians VALUES (100000000000009, 'Robert', 'I.', 'Rodriguez', '14567890123', 'A89012345');
INSERT INTO ContractPhysicians VALUES (100000000000010, 'Patricia', 'J.', 'Anderson', '13219876543', 'B90123456');


--Inserting Data into the Specialty Table 
INSERT INTO Specialty VALUES (110000000000001, 'Cardiology');
INSERT INTO Specialty VALUES (110000000000002, 'Neurology');
INSERT INTO Specialty VALUES (110000000000003, 'Orthopedics');
INSERT INTO Specialty VALUES (110000000000004, 'Pediatrics');
INSERT INTO Specialty VALUES (110000000000005, 'Dermatology');
INSERT INTO Specialty VALUES (110000000000006, 'Psychiatry');
INSERT INTO Specialty VALUES (110000000000007, 'Radiology');
INSERT INTO Specialty VALUES (110000000000008, 'Oncology');
INSERT INTO Specialty VALUES (110000000000009, 'Gastroenterology');
INSERT INTO Specialty VALUES (110000000000010, 'Endocrinology');




--Inserting Data into the Drug Table 
INSERT INTO Drug VALUES (40000000001, 'Ibuprofen', 'Pain Relief', 200, 100, 'mg', 15.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000002, 'Acetaminophen', 'Fever Reducer', 500, 50, 'mg', 12.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000003, 'Naproxen', 'Reduce inflammation', 220, 24, 'mg', 18.50, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000004, 'Diphenhydramine', 'Alleviate cold symptoms', 25, 48, 'mg', 9.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000005, 'Loratadine', 'Relieve hay fever and allergy symptoms', 10, 30, 'mg', 10.50, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000006, 'Ranitidine', 'Relieves indigestion' ,75, 60, 'mg', 20.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000007, 'Guaifenesin', 'Alleviate congestion', 400, 20, 'mg', 8.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000008, 'Pseudoephedrine', 'Relieve nasal congestion', 30, 30, 'mg', 11.75, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000009, 'Calcium Carbonate', 'Supplement calcium deficiency', 500, 100, 'mg', 7.50, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000010, 'Famotidine','Treat stomach ulcers', 10, 50, 'mg', 14.00, 'Non-Prescription');

INSERT INTO Drug VALUES (40000000011, 'Amoxicillin', 'Treat bacterial infections', 500, 30, 'mg', 25.00, 'Prescription Only');
INSERT INTO Drug VALUES (40000000012, 'Lisinopril', 'Treat hypertension', 20, 60, 'mg', 30.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000013, 'Atorvastatin', 'Treat cholesterol', 10, 90, 'mg', 45.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000014, 'Metformin', 'Treat type 2 and gestational diabetes', 500, 100, 'mg', 35.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000015, 'Omeprazole', 'Treat indigestion and heartburn', 20, 30, 'mg', 27.50, 'Prescription Only');

INSERT INTO Drug VALUES (40000000016, 'Levothyroxine', 'Treat hypothyroidism', 75, 90, 'mcg', 40.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000017, 'Amlodipine', 'Treat high blood pressure',5, 60, 'mg', 29.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000018, 'Gabapentin', 'Treat epilepsy' ,300, 50, 'mg', 33.75, 'Prescription Only');

INSERT INTO Drug VALUES (40000000019, 'Sertraline', 'Treat depressive disorders', 50, 30, 'mg', 38.00, 'Prescription Only');

INSERT INTO Drug VALUES (40000000020, 'Losartan', 'Treat hypertension', 25, 30, 'mg', 31.50, 'Prescription Only');

INSERT INTO Drug VALUES (40000000021, 'Adderall', 'Treat ADHD', 10, 30, 'mg', 150.00, 'Controlled Substance');
INSERT INTO Drug VALUES (40000000022, 'Oxycodone', 'Relieve severe pain', 5, 20, 'mg', 200.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000023, 'Diazepam', 'Treat anxiety, muscle spasms, and seizures', 2, 60, 'mg', 85.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000024, 'Methadone', 'Used to reduce or quit use of heroin and opiates', 10, 50, 'mg', 120.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000025, 'Lorazepam', 'Relieve anxiety', 1, 90, 'mg', 95.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000026, 'Morphine', 'Treat severe pain', 15, 100, 'mg', 250.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000027, 'Clonazepam', 'Treat seizures', 0.5, 100, 'mg', 70.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000028, 'Hydromorphone', 'Used for short-term relief of severe pain', 2, 30, 'mg', 180.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000029, 'Fentanyl', 'Treat patients with severe pain', 25, 5, 'mcg', 350.00, 'Controlled Substance');

INSERT INTO Drug VALUES (40000000030, 'Buprenorphine', 'Treat pain and opiod addiction', 8, 40, 'mg', 220.00, 'Controlled Substance');



--Inserting Data into the Pharmacy Table 
INSERT INTO Pharmacy VALUES (1, 'Y', 'Healing Horizons Pharmacy');
INSERT INTO Pharmacy VALUES (2, 'Y', 'Wellness Plus Pharmacy');
INSERT INTO Pharmacy VALUES (3, 'Y', 'Horizon Health Center');
INSERT INTO Pharmacy VALUES (4, 'Y', 'Springfield Family Pharmacy');
INSERT INTO Pharmacy VALUES (5, 'N', 'Healing Touch Pharmacy');
INSERT INTO Pharmacy VALUES (6, 'N', 'Green Valley Pharmacy');
INSERT INTO Pharmacy VALUES (7, 'N', 'New Horizons Pharmacy');
INSERT INTO Pharmacy VALUES (8, 'N', 'Lakeview Community Pharmacy');
INSERT INTO Pharmacy VALUES (9, 'N', 'Sunrise Pharmacy');
INSERT INTO Pharmacy VALUES (10, 'N', 'Pine Ridge Pharmacy');



--Inserting Data into the Specialty-Acquired Table 
INSERT INTO SpecialtyAcquired VALUES ('900000000000001', '2024-01-15', '100000000000001', '110000000000001');
INSERT INTO SpecialtyAcquired VALUES ('900000000000002', '2024-02-10', '100000000000002', '110000000000002');
INSERT INTO SpecialtyAcquired VALUES ('900000000000003', '2024-03-05', '100000000000003', '110000000000003');
INSERT INTO SpecialtyAcquired VALUES ('900000000000004', '2024-04-12', '100000000000004', '110000000000004');
INSERT INTO SpecialtyAcquired VALUES ('900000000000005', '2024-05-20', '100000000000005', '110000000000005');
INSERT INTO SpecialtyAcquired VALUES ('900000000000006', '2024-06-18', '100000000000006', '110000000000006');
INSERT INTO SpecialtyAcquired VALUES ('900000000000007', '2024-07-25', '100000000000007', '110000000000007');
INSERT INTO SpecialtyAcquired VALUES ('900000000000008', '2024-08-10', '100000000000008', '110000000000008');
INSERT INTO SpecialtyAcquired VALUES ('900000000000009', '2024-09-05', '100000000000009', '110000000000009');
INSERT INTO SpecialtyAcquired VALUES ('900000000000010', '2024-10-15', '100000000000010', '110000000000010');



--Inserting Data into the Drug On Hand Table 
INSERT INTO DrugOnHand VALUES ('PHARMLOG00001', 100, '40000000001', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00002', 150, '40000000002', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00003', 200, '40000000003', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00004', 50, '40000000004', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00005', 120, '40000000005', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00006', 80, '40000000006', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00007', 90, '40000000007', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00008', 70, '40000000008', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00009', 110, '40000000009', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00010', 130, '40000000010', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00011', 60, '40000000011', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00012', 90, '40000000012', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00013', 150, '40000000013', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00014', 200, '40000000014', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00015', 50, '40000000015', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00016', 60, '40000000016', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00017', 100, '40000000017', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00018', 75, '40000000018', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00019', 90, '40000000019', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00020', 110, '40000000020', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00021', 80, '40000000021', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00022', 150, '40000000022', 1);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00023', 60, '40000000023', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00024', 90, '40000000024', 2);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00025', 100, '40000000025', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00026', 130, '40000000026', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00027', 70, '40000000027', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00028', 60, '40000000028', 4);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00029', 50, '40000000029', 3);
INSERT INTO DrugOnHand VALUES ('PHARMLOG00030', 80, '40000000030', 3);



--Inserting Data into the Non-Prescription Table 
INSERT INTO NonPrescription VALUES ('40000000001', 'Ibuprofen');
INSERT INTO NonPrescription VALUES ('40000000002', 'Acetaminophen');
INSERT INTO NonPrescription VALUES ('40000000003', 'Naproxen');
INSERT INTO NonPrescription VALUES ('40000000004', 'Diphenhydramine');
INSERT INTO NonPrescription VALUES ('40000000005', 'Loratadine');
INSERT INTO NonPrescription VALUES ('40000000006', 'Ranitidine');
INSERT INTO NonPrescription VALUES ('40000000007', 'Guaifenesin');
INSERT INTO NonPrescription VALUES ('40000000008', 'Pseudoephedrine');
INSERT INTO NonPrescription VALUES ('40000000009', 'Calcium Carbonate');
INSERT INTO NonPrescription VALUES ('40000000010', 'Famotidine');



--Inserting Data into the Prescription-Only Table 
INSERT INTO PrescriptionOnly VALUES (40000000011, 'Amoxicillin');
INSERT INTO PrescriptionOnly VALUES (40000000012, 'Lisinopril');
INSERT INTO PrescriptionOnly VALUES (40000000013, 'Atorvastatin');
INSERT INTO PrescriptionOnly VALUES (40000000014, 'Metformin');
INSERT INTO PrescriptionOnly VALUES (40000000015, 'Omeprazole');
INSERT INTO PrescriptionOnly VALUES (40000000016, 'Levothyroxine');
INSERT INTO PrescriptionOnly VALUES (40000000017, 'Amlodipine');
INSERT INTO PrescriptionOnly VALUES (40000000018, 'Gabapentin');
INSERT INTO PrescriptionOnly VALUES (40000000019, 'Sertraline');
INSERT INTO PrescriptionOnly VALUES (40000000020, 'Losartan');



--Inserting Data into the Controlled Substance Table 
INSERT INTO ControlledSubstance VALUES ('40000000021', 'Adderall', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000022', 'Oxycodone', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000023', 'Diazepam', 'CIV');
INSERT INTO ControlledSubstance VALUES ('40000000024', 'Methadone', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000025', 'Lorazepam', 'CIV');
INSERT INTO ControlledSubstance VALUES ('40000000026', 'Morphine', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000027', 'Clonazepam', 'CIV');
INSERT INTO ControlledSubstance VALUES ('40000000028', 'Hydromorphone', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000029', 'Fentanyl', 'CII');
INSERT INTO ControlledSubstance VALUES ('40000000030', 'Buprenorphine', 'CIII');



--Inserting Data into the Patient Table 
INSERT INTO Patient VALUES (123456, 'John', 'Doe', '123 Maple St, Springfield, IL', '15551234567', 'Y'); 
INSERT INTO Patient VALUES (234567, 'Jane', 'Smith', '456 Oak St, Denver, CO', '15552345678', 'Y'); 
INSERT INTO Patient VALUES (345678, 'Michael', 'Johnson', '789 Pine St, Austin, TX', '15553456789', 'Y'); 
INSERT INTO Patient VALUES (456789, 'Emily', 'Davis', '101 Birch Ave, Miami, FL', '15554567890', 'Y');
INSERT INTO Patient VALUES (567890, 'Chris', 'Brown', '202 Cedar Ln, Seattle, WA', '15555678901', 'Y'); 
INSERT INTO Patient VALUES (678901, 'Sarah', 'Wilson', '303 Spruce St, Boston, MA', '15556789012', 'Y'); 
INSERT INTO Patient VALUES (789012, 'David', 'Martinez', '404 Maple St, Chicago, IL', '15557890123', 'Y'); 
INSERT INTO Patient VALUES (890123, 'Anna', 'Lopez', '505 Oak St, Phoenix, AZ', '15558901234', 'Y'); 
INSERT INTO Patient VALUES (901234, 'James', 'Gonzalez', '606 Pine St, New York, NY', '15559012345', 'Y'); 
INSERT INTO Patient VALUES (123450, 'Emma', 'Harris', '707 Birch Ave, San Francisco, CA', '15550123456', 'Y'); 



--Inserting Data into the Insurance Receipt Table 
INSERT INTO InsuranceReceipt VALUES (100000000000001, 'BlueCross BlueShield', 150.00, 123456);
INSERT INTO InsuranceReceipt VALUES (100000000000002, 'Aetna', 200.00, 234567);
INSERT INTO InsuranceReceipt VALUES (100000000000003, 'Cigna', 250.00, 345678);
INSERT INTO InsuranceReceipt VALUES (100000000000004, 'UnitedHealthcare', 180.00, 456789);
INSERT INTO InsuranceReceipt VALUES (100000000000005, 'Kaiser Permanente', 220.00, 567890);
INSERT INTO InsuranceReceipt VALUES (100000000000006, 'Humana', 170.00, 678901);
INSERT INTO InsuranceReceipt VALUES (100000000000007, 'BlueCross BlueShield', 210.00, 789012);
INSERT INTO InsuranceReceipt VALUES (100000000000008, 'Aetna', 195.00, 890123);
INSERT INTO InsuranceReceipt VALUES (100000000000009, 'Cigna', 225.00, 901234);
INSERT INTO InsuranceReceipt VALUES (100000000000010, 'UnitedHealthcare', 185.00, 123450);



--Inserting Data into the Clinic Table 
INSERT INTO Clinic VALUES (1, 'Rosenwald Heights Minute Clinic', '123 Rosenwald Dr, Panama City Beach, FL, 32407 ', '18505550101', 1);
INSERT INTO Clinic VALUES (2, 'Forest Hills Minute Clinic', '456 Forest Ave, Panama City Beach, FL, 32407 ', '18505550102', 2);
INSERT INTO Clinic VALUES (3, 'Seaside Minute Clinic', '789 Seaside Blvd, Panama City Beach, FL, 32407 ', '18505550103', 3);
INSERT INTO Clinic VALUES (4, 'Bayview Minute Clinic', '101 Bayview St, Panama City Beach, FL, 32407', '18505550104', 4);



--Inserting Data into the Contractor Clinic Assignment Table
INSERT INTO ContractorClinicAssignment VALUES ('200000000000001', '2024-11-01', '08:00:00', '12:00:00', 1, 100000000000001);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000002', '2024-11-01', '13:00:00', '17:00:00', 2, 100000000000003);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000003', '2024-11-02', '08:00:00', '12:00:00', 3, 100000000000004);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000004', '2024-11-02', '13:00:00', '17:00:00', 4, 100000000000005);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000005', '2024-11-03', '08:00:00', '12:00:00', 1, 100000000000006);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000006', '2024-11-03', '13:00:00', '17:00:00', 2, 100000000000007);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000007', '2024-11-04', '08:00:00', '12:00:00', 3, 100000000000008);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000008', '2024-11-04', '13:00:00', '17:00:00', 4, 100000000000009);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000009', '2024-11-05', '08:00:00', '12:00:00', 1, 100000000000010);
INSERT INTO ContractorClinicAssignment VALUES ('200000000000010', '2024-11-05', '13:00:00', '17:00:00', 2, 100000000000002);
 


--Inserting Data into the Employee Table 
INSERT INTO Employee VALUES (300000000000001, 'Alice', 'M', 'Walker', '102 River Dr, Springfield', '555-321-6543', 'Administrator',1);
INSERT INTO Employee VALUES (300000000000002, 'David', 'L', 'Garcia', '305 Forest St,Springfield','555-654-7890','Administrator', 2);
INSERT INTO Employee VALUES (300000000000003, 'Sophia', 'B', 'Martinez', '768 Green Ln, Springfield', '555-123-9087', 'Administrator', 3);
INSERT INTO Employee VALUES (300000000000004, 'Liam', 'K', 'Thompson', '456WillowAve,Springfield','555-876-5432','Administrator',4);
INSERT INTO Employee VALUES(300000000000005, 'Olivia', 'T', 'Lee', '910 Redwood Rd, Springfield', '555-213-4567', 'Administrator', 1);
INSERT INTO Employee VALUES(300000000000006, 'Ethan', 'R', 'Harris', '345 Cherry Blvd, Springfield', '555-678-9012', 'Administrator',3);
INSERT INTO Employee VALUES(300000000000007, 'Emma', 'J', 'Nelson', '789 Sunset Ln, Springfield', '555-890-1234', 'Administrator',4);
INSERT INTO Employee VALUES(300000000000008, 'Jackson', 'V', 'Perez','201HighlandDr,Springfield','555-987-6543','Administrator',1);
INSERT INTO Employee VALUES(300000000000009, 'Mia', 'S', 'Carter', '632 Lakeview St, Springfield', '555-456-7890', 'Administrator', 2);
INSERT INTO Employee VALUES(300000000000010, 'Aiden', 'N', 'Robinson', '548 Bay Rd, Springfield', '555-345-6789', 'Administrator', 3);

INSERT INTO Employee VALUES (300000000000101, 'Charlotte', 'A', 'Johnson', '123 Maple St, Springfield', '555-321-6543', 'Pharmacist', 1);
INSERT INTO Employee VALUES (300000000000102, 'Benjamin', 'W', 'Ramirez', '456 Oak Dr, Springfield', '555-234-5678', 'Pharmacist', 2);
INSERT INTO Employee VALUES (300000000000103, 'Amelia', 'H', 'Clark', '789 Pine Ln, Springfield', '555-345-6789', 'Pharmacist', 3);
INSERT INTO Employee VALUES (300000000000104, 'Noah', 'J', 'Gonzalez', '101 Birch Ave, Springfield', '555-456-7890', 'Pharmacist', 4);
INSERT INTO Employee VALUES (300000000000105, 'Harper', 'K', 'Young', '202 Cedar Rd, Springfield', '555-567-8901', 'Pharmacist', 1);
INSERT INTO Employee VALUES (300000000000106, 'Lucas', 'M', 'Hall', '303 Elm Blvd, Springfield', '555-678-9012', 'Pharmacist', 3);
INSERT INTO Employee VALUES (300000000000107, 'Evelyn', 'D', 'Allen', '404 Walnut St, Springfield', '555-789-0123', 'Pharmacist', 4);
INSERT INTO Employee VALUES (300000000000108, 'Henry', 'L', 'Scott', '505 Aspen Dr, Springfield', '555-890-1234', 'Pharmacist', 1);
INSERT INTO Employee VALUES (300000000000109, 'Ella', 'C', 'Adams', '606 Magnolia Ln, Springfield', '555-901-2345', 'Pharmacist', 2);
INSERT INTO Employee VALUES (300000000000110, 'William', 'Q', 'Baker', '707 Cypress Ave, Springfield', '555-012-3456', 'Pharmacist', 3);

INSERT INTO Employee VALUES (300000000000201, 'Lily', 'B', 'Peterson', '111 Birchwood Ave, Springfield', '555-111-2233', 'Nurse', 1);
INSERT INTO Employee VALUES (300000000000202, 'James', 'D', 'Sanchez', '222 Oakwood Dr, Springfield', '555-222-3344', 'Nurse', 2);
INSERT INTO Employee VALUES (300000000000203, 'Grace', 'L', 'Murphy', '333 Pinewood Ln, Springfield', '555-333-4455', 'Nurse', 3);
INSERT INTO Employee VALUES (300000000000204, 'Daniel', 'F', 'Jenkins', '444 Maplewood St, Springfield', '555-444-5566', 'Nurse', 4);
INSERT INTO Employee VALUES (300000000000205, 'Sophia', 'G', 'Perry', '555 Cedar St, Springfield', '555-555-6677', 'Nurse', 1);
INSERT INTO Employee VALUES (300000000000206, 'Mason', 'J', 'Brooks', '666 Willow Dr, Springfield', '555-666-7788', 'Nurse', 3);
INSERT INTO Employee VALUES (300000000000207, 'Aria', 'C', 'Diaz', '777 Elmwood Blvd, Springfield', '555-777-8899', 'Nurse', 4);
INSERT INTO Employee VALUES (300000000000208, 'Oliver', 'P', 'Foster', '888 Redwood Ln, Springfield', '555-888-9900', 'Nurse', 1);
INSERT INTO Employee VALUES (300000000000209, 'Ava', 'R', 'Hayes', '999 Maple Dr, Springfield', '555-999-1010', 'Nurse', 2);
INSERT INTO Employee VALUES (300000000000210, 'Liam', 'S', 'Cruz', '1000 Birch St, Springfield', '555-000-2020', 'Nurse', 3);




--Inserting Data into the Pharmacist Table 
INSERT INTO Pharmacist VALUES
    (300000000000101, 'PS1234567', '2025-05-10', 1),
    (300000000000102, 'PS2345678', '2026-08-14', 2),
    (300000000000103, 'PS3456789', '2024-12-30', 3),
    (300000000000104, 'PS4567890', '2025-11-15', 4),
    (300000000000105, 'PS5678901', '2026-04-20', 1),
    (300000000000106, 'PS6789012', '2025-07-19', 2),
    (300000000000107, 'PS7890123', '2027-03-25', 3),
    (300000000000108, 'PS8901234', '2024-10-05', 4),
    (300000000000109, 'PS9012345', '2025-09-12', 1),
    (300000000000110, 'PS0123456', '2026-06-18', 2);



--Inserting Data into the Nurse Table 
INSERT INTO Nurse VALUES
    (300000000000201, 'RN1234567', '2025-06-15'),
    (300000000000202, 'RN2345678', '2026-07-22'),
    (300000000000203, 'RN3456789', '2024-12-01'),
    (300000000000204, 'RN4567890', '2025-11-30'),
    (300000000000205, 'RN5678901', '2026-01-15'),
    (300000000000206, 'RN6789012', '2025-03-27'),
    (300000000000207, 'RN7890123', '2027-04-05'),
    (300000000000208, 'RN8901234', '2024-09-10'),
    (300000000000209, 'RN9012345', '2025-08-17'),
    (300000000000210, 'RN0123456', '2026-10-22');



--Inserting Data into the Administrator Table 
INSERT INTO Administrator VALUES
    (300000000000001, 'Operations Maestro'),
    (300000000000002, 'Systems Overseer'),
    (300000000000003, 'Data Governance Specialist'),
    (300000000000004, 'Digital Infrastructure Coordinator'),
    (300000000000005, 'Solutions Architect'),
    (300000000000006, 'Compliance Custodian'),
    (300000000000007, 'Process Optimization Lead'),
    (300000000000008, 'Innovation Strategist'),
    (300000000000009, 'Resource Management Expert'),
    (300000000000010, 'Workflow Orchestrator');


--Inserting Data into the Appointment Table 
INSERT INTO Appointment VALUES (1000001, '2024-11-15', '09:00:00', 'Routine Checkup', 50.00, '123456', 1, 100000000000001);
INSERT INTO Appointment VALUES (2000002, '2024-11-16', '10:30:00', 'Follow-up on Test Results', 55.00, '234567', 2, 100000000000002);
INSERT INTO Appointment VALUES (3000003, '2024-11-17', '11:00:00', 'Physical Therapy', 75.00, '345678', 3, 100000000000003);
INSERT INTO Appointment VALUES (4000004, '2024-11-18', '14:30:00', 'Annual Physical Exam', 65.00, '456789', 4, 100000000000004);
INSERT INTO Appointment VALUES (1000005, '2024-11-19', '13:00:00', 'Vaccination', 47.50, '567890', 1, 100000000000005);
INSERT INTO Appointment VALUES (2000006, '2024-11-20', '09:30:00', 'Consultation', 50.00, '678901', 2, 100000000000006);
INSERT INTO Appointment VALUES (3000007, '2024-11-21', '15:00:00', 'Specialist Referral', 85.00, '789012', 3, 100000000000007);
INSERT INTO Appointment VALUES (4000008, '2024-11-22', '16:00:00', 'Pre-Operative Checkup', 90.00, '890123', 4, 100000000000008);
INSERT INTO Appointment VALUES (1000009, '2024-11-23', '10:00:00', 'Routine Follow-Up', 49.00, '901234', 1, 100000000000009);
INSERT INTO Appointment VALUES (2000010, '2024-11-24', '11:15:00', 'Lab Test Review', 52.50, '123450', 2, 100000000000010);


--Inserting Data into the Prescription Table 
INSERT INTO Prescription VALUES ('120000000000001', '2024-01-01', '30 tablets', 'Pain relief', 123456, 100000000000001, 40000000001 );

INSERT INTO Prescription VALUES ('120000000000002', '2024-02-05',  '60 tablets', 'Hypertension management', 234567, 100000000000002, 40000000002);

INSERT INTO Prescription VALUES ('120000000000003', '2024-03-10',  '90 tablets', 'Cholesterol control', 345678, 100000000000003, 40000000003);

INSERT INTO Prescription VALUES ('120000000000004', '2024-04-15', '100 tablets', 'Diabetes management', 456789, 100000000000004, 40000000012);

INSERT INTO Prescription VALUES ('120000000000005', '2024-05-20',  '30 tablets', 'Acid reflux treatment', 567890, 100000000000005, 40000000013);

INSERT INTO Prescription VALUES ('120000000000006', '2024-06-25',  '50 tablets', 'Neuropathic pain management', 678901, 100000000000006, 40000000022);

INSERT INTO Prescription VALUES ('120000000000007', '2024-07-10',  '60 tablets', 'Blood pressure management', 789012, 100000000000007, 40000000021);

INSERT INTO Prescription VALUES ('120000000000008', '2024-08-05',  '30 tablets', 'Depression treatment', 890123, 100000000000008, 40000000023);

INSERT INTO Prescription VALUES ('120000000000009', '2024-09-15',  '90 tablets', 'Edema management', 901234, 100000000000009, 40000000011);

INSERT INTO Prescription VALUES ('120000000000010', '2024-10-20',  '90 tablets', 'Thyroid hormone replacement', 123450, 100000000000010, 40000000016);



--Inserting Data into the Prescription Fulfillment Table 
INSERT INTO PrescriptionFullfillment VALUES ('130000000000001', 30, 'N', '2024-01-02', 15.00, '120000000000001', 1, 300000000000101);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000002', 60, 'Y', '2024-02-06', 30.00, '120000000000002', 2,300000000000102);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000003', 90, 'N', '2024-03-11', 45.00, '120000000000003', 3, 300000000000103);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000004', 100, 'Y', '2024-04-16', 40.00, '120000000000004', 4, 300000000000104);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000005', 30, 'N', '2024-05-21', 22.50, '120000000000005', 1, 300000000000105);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000006', 50, 'Y', '2024-06-26', 33.75, '120000000000006', 2, 300000000000106);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000007', 60, 'N', '2024-07-11', 29.40, '120000000000007', 3, 300000000000107);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000008', 30, 'N', '2024-08-06', 19.00, '120000000000008', 4, 300000000000108);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000009', 90, 'Y', '2024-09-16', 27.00, '120000000000009', 1,300000000000109);
INSERT INTO PrescriptionFullfillment VALUES ('130000000000010', 90, 'N', '2024-10-21', 36.00, '120000000000010', 2, 300000000000110);




 
--Queries 

-- Text Description of Query No. 1 - The purpose of this query is to provide updated data regarding drugs that may be prescribed and the status of said drugs in related clinics. Physicians and pharmacists can use this to determine the inventory status of a drug that needs to be prescribed as well as other information regarding the drug such as strength per dose. Physicians can use this as a reference guide when writing patients' prescriptions. Pharmacists can reference this to determine if a drug needs to be ordered due to low inventory. An inner join was used to gain data on the inventory and use of drugs by their NDC number. 
CREATE VIEW DrugDataReport AS   
    SELECT Drug.NDCNumber, Drug.LegalClass, Drug.DrugName, Drug.TherapeuticUse,  
           Drug.DrugStrengthPerDose, Drug.Unit, DrugonHand.QuantityOnHand, 
           Drug.AverageWholesalePrice, DrugOnHand.PharmacyID
    FROM Drug INNER JOIN DrugOnHand 
    ON Drug.NDCNumber = DrugOnHand.NDCNumber;


SELECT * 
FROM DrugDataReport
WHERE LegalClass = 'Non-Prescription' AND PharmacyID = 1;


--Text Description of Query No. 2 – This query provides valuable information about the clinics the pharmacies that relate to them and the pharmacy’s more information about the drugs and inventory that each has. This table shows going left to right all the info one would need about the clinics including name, ID, address, and phone number. The pharmacy info includes the ID and name. When it comes to displaying the inventory, we have basic information about the drugs like NDC number, drug name, drug strength per dose, and package quantity. But to dig deeper I added in the average wholesale price of each drug and calculated a reorder point for when inventory gets low. This data will help those who oversee the clinics and pharmacies who are interested in double-checking the inventory in each location. As long as they have available information to go with each drug they may need to restock. They can easily see the reorder point to first make them aware if they need to re-order and if they must then all the information on the drug and pharmacy is all detailed right there to make it easy for that order to be completed. 
CREATE VIEW InventoryReport AS
    SELECT cl.clinicID, cl.ClinicName as clinicname, cl.ClinicAddress as clinicaddress, 
           cl.ClinicPhoneNumber as clinicphone, ph.pharmacyid, ph.PharmacyName as pharmacyname, 
           d.ndcnumber, d.drugname, d.drugstrengthperdose, d.packagequantity, d.unit,  
           d.averagewholesaleprice, d.legalclass, doh.quantityonhand, doh.pharmacyinventorylogid,

    (SELECT SUM(pf.Quantity)
     FROM PrescriptionFullfillment pf
     WHERE pf.PharmacyID = ph.pharmacyid) as quantityonorder,
    (SELECT avg(doh.quantityonhand)
     FROM DrugOnHand doh
     WHERE doh.NDCNumber = d.ndcnumber AND doh.PharmacyID = ph.pharmacyID) as reorderpoint
     FROM Clinic cl
     JOIN Pharmacy ph on cl.pharmacyID = ph.PharmacyID
     JOIN DrugOnHand doh on ph.PharmacyID = doh.PharmacyID
     JOIN drug d on doh.NDCNumber = d.NDCNumber;

Select *
FROM InventoryReport;

-- Text Description of Query No. 3 – This query provides the user with patient contact information, including PatientID, their first name, last name, home address, and phone number. Additionally, I added the controlled substance type to provide clarity as to which drug is going to which patient. There is also a count function that shows the number of prescriptions for that patient, as well as the total cost for the fulfillment of the prescription. There is a SUM function to show the wholesale price for the controlled substance, as this information may become useful for tax or accounting purposes. Finally, this query can show the date at which the prescription was filled to track dosages taken by the patient and when they should be prescribed more if needed. By creating this query, Healing Horizons is easily able to monitor which patients have been prescribed controlled substances, which can be dangerous and addictive if mishandled. Patients taking controlled substances within their prescriptions should be monitored for their safety.
CREATE VIEW ControlledSubstanceReport AS
SELECT P.PatientID, P.PatientFirstName, P.PatientLastName, P.PatientAddress, P.PhoneNumber,
    STRING_AGG(CS.ControlledSubstanceName, ', ') AS ControlledSubstances,
    STRING_AGG(CONVERT(VARCHAR, PR.PrescriptionDate, 23), ', ') AS PrescriptionDates, 
    COUNT(PF.PrescriptionFullFillment#) AS TotalPrescriptions,
    SUM(D.AverageWholesalePrice) AS TotalCost, SUM(PF.Price) AS PrescriptionFulfillmentCost 
FROM Patient P INNER JOIN Prescription PR 
ON P.PatientID = PR.PatientID
INNER JOIN ControlledSubstance CS 
ON PR.NDCNumber = CS.NDCNumber
INNER JOIN PrescriptionFullfillment PF 
ON PR.Order# = PF.Order#
INNER JOIN Drug D 
ON PR.NDCNumber = D.NDCNumber
WHERE PF.PrescriptionFullfillmentDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY P.PatientID, P.PatientFirstName, P.PatientLastName, P.PatientAddress, P.PhoneNumber;

SELECT *
FROM ControlledSubstanceReport
WHERE PatientID = 678901 AND (PrescriptionDates>='2024-06-25' AND PrescriptionDates<='2024-06-25');






--Text Description of Query No. 4 – The purpose of this query is to identify the nurses and pharmacists whose licenses will expire in six months, providing their personal information (i.e., Employee ID, First Name, Middle Initial, Last Name, Address, Phone Number, Employee Category, License Expiry) and the number of days remaining until their license expires. For pharmacists, in particular, the query will provide the number of prescriptions they have filled out. Clinic Administrators and HR Managers can benefit from this query because they are responsible for monitoring the status of their nurses' or pharmacists’ licenses and ensuring compliance. For this query, we calculated the days remaining until a nurse’s or pharmacist’s license expires using DATEDIFF. We also used a subquery to count the number of prescriptions filled by pharmacists using GROUP BY. We combined the results using UNION ALL and separated them based on Employee Category. 
CREATE VIEW LicenseReport AS
   SELECT Employee.EmployeeID, Employee.EmpFirstName, Employee.EmpMiddleInitial, 
          Employee.EmpLastName, Employee.EmpAddress, Employee.PhoneNumber, 'Nurse' AS 
          EmployeeCategory, Nurse.LicenseExpiry AS LicenseExpiry, DATEDIFF(DAY, GETDATE(), 
          Nurse.LicenseExpiry) AS DaysUntilExpiry, NULL AS PrescriptionsFilled
FROM Employee INNER JOIN Nurse
ON Employee.EmployeeID = Nurse.EmployeeID
WHERE NURSE.LicenseExpiry BETWEEN GETDATE() AND DATEADD(MONTH, 6, GETDATE())

UNION ALL

SELECT Employee.EmployeeID, Employee.EmpFirstName, Employee.EmpMiddleInitial, Employee.EmpLastName, Employee.EmpAddress, Employee.PhoneNumber, 'Pharmacist' AS EmployeeCategory, Pharmacist.LicenseExpiry AS LicenseExpiry, DATEDIFF(DAY, GETDATE(), Pharmacist.LicenseExpiry) AS DaysUntilExpiry, PFilled.PrescriptionCount AS PrescriptionsFilled
FROM Employee INNER JOIN Pharmacist
ON Employee.EmployeeID = Pharmacist.EmployeeID
LEFT JOIN 
(SELECT PrescriptionFullfillment.EmployeeID,  
        COUNT(PrescriptionFullfillment.PrescriptionFullfillment#) AS PrescriptionCount
 FROM PrescriptionFullfillment
 GROUP BY PrescriptionFullfillment.EmployeeID) PFilled ON Pharmacist.EmployeeID = PFilled.EmployeeID
 WHERE Pharmacist.LicenseExpiry BETWEEN GETDATE() AND DATEADD(MONTH, 6, GETDATE()); 

Select *
FROM LicenseReport;



--Text Description of Query No. 5 – The purpose of this query is to generate labels for each drug, showing information about the Drug (i.e., Name, Strength, and Package Quantity), Patient (i.e., First and Last Name combined, and Address), Contract Physician (i.e., First and Last Name combined, and DEA Number), Quantity Dispensed, Fill Date, Pharmacy Address, and the Total Quantity of each drug Dispensed. Pharmacy Technicians who need a comprehensive record of their patients’ prescriptions can benefit from this query. For this query, we calculated the quantity dispensed for each drug using a subquery and grouped by NDC Number. The results are ordered by the fill date in descending order to prioritize newer prescriptions. 
CREATE VIEW PrescriptionLabelReport AS
 SELECT Prescription.Order# AS PrescriptionOrderNumber, Drug.DrugName, Drug.DrugStrengthPerDose, 
      Drug.PackageQuantity, CONCAT(Patient.PatientFirstName, ' ', Patient.PatientLastName) AS 
      PatientName, Patient.PatientAddress AS PatientAddress, 
      CONCAT(ContractPhysicians.FirstName, ' ', ContractPhysicians.LastName) AS PhysicianName, 
      ContractPhysicians.DEA# AS PhysicianDEA, PrescriptionFullfillment.Quantity AS        
      QuantityDispensed, PrescriptionFullfillment.PrescriptionFullfillmentDate AS DateFilled, 
      Clinic.ClinicAddress AS PharmacyAddress, TotalDispensed.TotalQuantity AS TotalQuantityDispensed
FROM Prescription INNER JOIN PrescriptionFullfillment
ON Prescription.Order# = PrescriptionFullfillment.Order#
INNER JOIN Drug
ON Prescription.NDCNumber = Drug.NDCNumber
INNER JOIN Patient
ON Prescription.PatientID = Patient.PatientID
INNER JOIN ContractPhysicians
ON Prescription.PhysicianID = ContractPhysicians.PhysicianID
INNER JOIN Clinic
ON PrescriptionFullfillment.PharmacyID = Clinic.PharmacyID
LEFT JOIN (SELECT Prescription.NDCNumber, SUM(PrescriptionFullfillment.Quantity) AS TotalQuantity
           FROM   PrescriptionFullfillment INNER JOIN Prescription
           ON PrescriptionFullfillment.Order# = Prescription.Order#
           GROUP BY Prescription.NDCNumber) TotalDispensed ON Prescription.NDCNumber = 
                    TotalDispensed.NDCNumber;


SELECT * 
FROM PrescriptionLabelReport;



--Text Description of Query No. 6 – This query retrieves all relevant information needed for an appointment history report including the patient information, the appointment ID, the reason for the visit, the clinic at which the appointment occurred, the date and time, the physician (name and ID number), and the fee charged for the appointment. The query joins the Appointment, Patient, ContractPhysician, and Clinic tables based on shared identifiers such as PatientID, PhysicianID, and ClinicID. The second version of this query demonstrates how the report can be altered to search for date ranges and particular patients. This report would be useful for nurses and contract physicians wanting to view the patient’s appointment history. This report could also be useful for clinic administrators who need a log of a patient’s appointment history. 
CREATE VIEW AppointmentHistory AS
    Select AppointmentID, Appointment.PatientID, Patient.PatientFirstName, Patient.PatientLastName, 
           Appointment.Reason, Clinic.ClinicName, Appointment.ApptDate, Appointment.ApptTime, 
           Appointment.PhysicianID, ContractPhysicians.FirstName AS PhysicianFirstName, 
           ContractPhysicians.LastName AS PhysicianLastName, FeeCharged
FROM Appointment INNER JOIN Patient
ON Appointment.PatientID = Patient.PatientID
INNER JOIN ContractPhysicians
ON Appointment.PhysicianID = ContractPhysicians.PhysicianID
LEFT OUTER JOIN Clinic
ON Appointment.ClinicID = Clinic.ClinicID;

SELECT *
FROM AppointmentHistory
WHERE (ApptDate >= '2024-11-15' AND ApptDate <= '2024-11-24') AND PatientID = '123456';



--Text Description of Query No. 7 – This query retrieves patient information, including their names and PatientID, along with details about their prescriptions, such as the drug name, prescription date, drug strength, package quantity, and average wholesale price. It also includes the physician's first and last names and their PhysicianID. The data was drawn from the Patient, Prescription, Drug, Appointment, and ContractPhysicians tables, joined by common identifiers like PatientID and PhysicianID. No sorting, grouping, or totaling was applied in this query
CREATE VIEW PatientPrescriptionReport AS
 SELECT PatientFirstName, PatientLastName, patient.PatientID, Prescription.NDCNumber, DrugName,  
        PrescriptionDate, DrugStrengthPerDose, PackageQuantity, AverageWholesalePrice, FirstName AS 
        PhysicianFirst, LastName AS PhysicianLast, ContractPhysicians.PhysicianID
FROM Patient
INNER JOIN Prescription
ON Patient.PatientID = Prescription.PatientID
INNER JOIN Drug
ON Prescription.NDCNumber = drug.NDCNumber
INNER JOIN Appointment
ON Patient.PatientID = Appointment.PatientID
INNER JOIN ContractPhysicians
ON ContractPhysicians.PhysicianID = Appointment.PhysicianID;

SELECT *
FROM PatientPrescriptionReport
WHERE PatientID = 123456 AND PhysicianID = 100000000000001;



