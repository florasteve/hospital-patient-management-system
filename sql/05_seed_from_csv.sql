USE HospitalDB;
GO

IF OBJECT_ID('tempdb..#Patients') IS NOT NULL DROP TABLE #Patients;
IF OBJECT_ID('tempdb..#Doctors')  IS NOT NULL DROP TABLE #Doctors;
IF OBJECT_ID('tempdb..#Appts')    IS NOT NULL DROP TABLE #Appts;

CREATE TABLE #Patients(
  PatientID INT,
  FirstName NVARCHAR(50),
  LastName  NVARCHAR(50),
  DateOfBirth DATE,
  Gender CHAR(1),
  Phone NVARCHAR(20),
  Email NVARCHAR(100),
  Address NVARCHAR(100),
  City NVARCHAR(60),
  State NVARCHAR(2),
  Zip NVARCHAR(10)
);

CREATE TABLE #Doctors(
  DoctorID INT,
  FirstName NVARCHAR(50),
  LastName  NVARCHAR(50),
  Specialty NVARCHAR(80),
  Phone NVARCHAR(20),
  Email NVARCHAR(100)
);

CREATE TABLE #Appts(
  AppointmentID INT,
  PatientID INT,
  DoctorID INT,
  AppointmentDateTime DATETIME2(0),
  Status NVARCHAR(20),
  Reason NVARCHAR(120),
  Notes NVARCHAR(400)
);

BULK INSERT #Patients FROM 'data\patients.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', FORMAT='CSV');

BULK INSERT #Doctors FROM 'data\doctors.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', FORMAT='CSV');

BULK INSERT #Appts FROM 'data\appointments.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', FORMAT='CSV');

INSERT INTO dbo.Patients(PatientID,FirstName,LastName,DateOfBirth,Gender,Phone,Email,Address,City,State,Zip)
SELECT * FROM #Patients p WHERE NOT EXISTS (SELECT 1 FROM dbo.Patients x WHERE x.PatientID = p.PatientID);

INSERT INTO dbo.Doctors(DoctorID,FirstName,LastName,Specialty,Phone,Email)
SELECT * FROM #Doctors d WHERE NOT EXISTS (SELECT 1 FROM dbo.Doctors x WHERE x.DoctorID = d.DoctorID);

INSERT INTO dbo.Appointments(AppointmentID,PatientID,DoctorID,AppointmentDateTime,Status,Reason,Notes)
SELECT * FROM #Appts a WHERE NOT EXISTS (SELECT 1 FROM dbo.Appointments x WHERE x.AppointmentID = a.AppointmentID);

PRINT 'Patients: ' + CAST((SELECT COUNT(*) FROM dbo.Patients) AS NVARCHAR(20));
PRINT 'Doctors: '  + CAST((SELECT COUNT(*) FROM dbo.Doctors)  AS NVARCHAR(20));
PRINT 'Appts: '    + CAST((SELECT COUNT(*) FROM dbo.Appointments) AS NVARCHAR(20));

IF EXISTS (
  SELECT 1
  FROM dbo.Appointments A
  LEFT JOIN dbo.Patients P ON A.PatientID = P.PatientID
  LEFT JOIN dbo.Doctors  D ON A.DoctorID = D.DoctorID
  WHERE P.PatientID IS NULL OR D.DoctorID IS NULL
)
BEGIN
  THROW 51000, 'Orphaned appointment rows detected.', 1;
END

IF EXISTS (
  SELECT DoctorID, AppointmentDateTime
  FROM dbo.Appointments
  GROUP BY DoctorID, AppointmentDateTime
  HAVING COUNT(*) > 1
)
BEGIN
  THROW 51001, 'Double-booked appointment(s) detected.', 1;
END
GO
