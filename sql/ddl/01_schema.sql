IF DB_ID('HospitalDB') IS NULL
  CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

IF OBJECT_ID('dbo.Appointments','U') IS NOT NULL DROP TABLE dbo.Appointments;
IF OBJECT_ID('dbo.Patients','U') IS NOT NULL DROP TABLE dbo.Patients;
IF OBJECT_ID('dbo.Doctors','U') IS NOT NULL DROP TABLE dbo.Doctors;
GO

CREATE TABLE dbo.Patients(
  PatientID       INT           NOT NULL PRIMARY KEY,
  FirstName       NVARCHAR(50)  NOT NULL,
  LastName        NVARCHAR(50)  NOT NULL,
  Age             INT           NULL,
  Gender          NVARCHAR(10)  NULL,
  Contact         NVARCHAR(100) NULL,
  CreatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.Doctors(
  DoctorID        INT           NOT NULL PRIMARY KEY,
  FirstName       NVARCHAR(50)  NOT NULL,
  LastName        NVARCHAR(50)  NOT NULL,
  Specialization  NVARCHAR(80)  NULL,
  Contact         NVARCHAR(100) NULL,
  CreatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.Appointments(
  AppointmentID       INT           NOT NULL PRIMARY KEY,
  PatientID           INT           NOT NULL,
  DoctorID            INT           NOT NULL,
  AppointmentDateTime DATETIME2     NOT NULL,
  Status              NVARCHAR(20)  NOT NULL CHECK (Status IN ('Scheduled','Completed','Canceled')),
  CreatedAt           DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt           DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT FK_Appointments_Patients FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID),
  CONSTRAINT FK_Appointments_Doctors  FOREIGN KEY (DoctorID)  REFERENCES dbo.Doctors(DoctorID)
);
GO

CREATE INDEX IX_Appointments_Doctor_Date ON dbo.Appointments(DoctorID, AppointmentDateTime);
CREATE INDEX IX_Appointments_Patient_Date ON dbo.Appointments(PatientID, AppointmentDateTime);
GO

CREATE OR ALTER VIEW dbo.vwDoctorUtilization AS
SELECT
  d.DoctorID,
  d.FirstName AS DoctorFirst,
  d.LastName  AS DoctorLast,
  CAST(a.AppointmentDateTime AS DATE) AS ApptDate,
  SUM(CASE WHEN a.Status='Scheduled' THEN 1 ELSE 0 END) AS SlotsScheduled,
  SUM(CASE WHEN a.Status='Completed' THEN 1 ELSE 0 END) AS SlotsCompleted
FROM dbo.Doctors d
LEFT JOIN dbo.Appointments a ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName, CAST(a.AppointmentDateTime AS DATE);
GO
