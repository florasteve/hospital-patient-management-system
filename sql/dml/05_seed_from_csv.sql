USE HospitalDB;
GO

-- ===== Doctors from CSV =====
IF OBJECT_ID('tempdb..#Doctors') IS NOT NULL DROP TABLE #Doctors;
CREATE TABLE #Doctors(
  DoctorID INT PRIMARY KEY,
  FirstName NVARCHAR(50),
  LastName NVARCHAR(50),
  Specialization NVARCHAR(80),
  Contact NVARCHAR(100),
  CreatedAt DATETIME2,
  UpdatedAt DATETIME2
);
BULK INSERT #Doctors
FROM '/var/opt/mssql/imports/doctors.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0d0a', TABLOCK);
MERGE dbo.Doctors AS tgt
USING #Doctors AS src ON tgt.DoctorID=src.DoctorID
WHEN NOT MATCHED BY TARGET THEN
  INSERT(DoctorID,FirstName,LastName,Specialization,Contact,CreatedAt,UpdatedAt)
  VALUES(src.DoctorID,src.FirstName,src.LastName,src.Specialization,src.Contact,src.CreatedAt,src.UpdatedAt);
GO

-- ===== Patients from CSV =====
IF OBJECT_ID('tempdb..#Patients') IS NOT NULL DROP TABLE #Patients;
CREATE TABLE #Patients(
  PatientID INT PRIMARY KEY,
  FirstName NVARCHAR(50),
  LastName NVARCHAR(50),
  Age INT,
  Gender NVARCHAR(10),
  Contact NVARCHAR(100),
  CreatedAt DATETIME2,
  UpdatedAt DATETIME2
);
BULK INSERT #Patients
FROM '/var/opt/mssql/imports/patients.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0d0a', TABLOCK);
MERGE dbo.Patients AS tgt
USING #Patients AS src ON tgt.PatientID=src.PatientID
WHEN NOT MATCHED BY TARGET THEN
  INSERT(PatientID,FirstName,LastName,Age,Gender,Contact,CreatedAt,UpdatedAt)
  VALUES(src.PatientID,src.FirstName,src.LastName,src.Age,src.Gender,src.Contact,src.CreatedAt,src.UpdatedAt);
GO

-- ===== Appointments from CSV =====
IF OBJECT_ID('tempdb..#Appointments') IS NOT NULL DROP TABLE #Appointments;
CREATE TABLE #Appointments(
  AppointmentID INT PRIMARY KEY,
  PatientID INT,
  DoctorID INT,
  AppointmentDateTime DATETIME2,
  Status NVARCHAR(20),
  CreatedAt DATETIME2,
  UpdatedAt DATETIME2
);
BULK INSERT #Appointments
FROM '/var/opt/mssql/imports/appointments.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0d0a', TABLOCK);
MERGE dbo.Appointments AS tgt
USING #Appointments AS src ON tgt.AppointmentID=src.AppointmentID
WHEN NOT MATCHED BY TARGET THEN
  INSERT(AppointmentID,PatientID,DoctorID,AppointmentDateTime,Status,CreatedAt,UpdatedAt)
  VALUES(src.AppointmentID,src.PatientID,src.DoctorID,src.AppointmentDateTime,src.Status,src.CreatedAt,src.UpdatedAt);
GO
