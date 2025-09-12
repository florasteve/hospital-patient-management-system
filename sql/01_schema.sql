IF DB_ID('HospitalDB') IS NULL
BEGIN
  CREATE DATABASE HospitalDB;
END
GO
USE HospitalDB;
GO

IF OBJECT_ID('dbo.Appointments','U') IS NOT NULL DROP TABLE dbo.Appointments;
IF OBJECT_ID('dbo.Patients','U')     IS NOT NULL DROP TABLE dbo.Patients;
IF OBJECT_ID('dbo.Doctors','U')      IS NOT NULL DROP TABLE dbo.Doctors;
GO

CREATE TABLE dbo.Patients(
  PatientID     INT           NOT NULL PRIMARY KEY,
  FirstName     NVARCHAR(50)  NOT NULL,
  LastName      NVARCHAR(50)  NOT NULL,
  DateOfBirth   DATE          NOT NULL,
  Gender        CHAR(1)       NOT NULL CHECK (Gender IN ('M','F')),
  Phone         NVARCHAR(20)  NULL,
  Email         NVARCHAR(100) NULL,
  Address       NVARCHAR(100) NULL,
  City          NVARCHAR(60)  NULL,
  State         NVARCHAR(2)   NULL,
  Zip           NVARCHAR(10)  NULL,
  CreatedAt     DATETIME2(0)  NOT NULL CONSTRAINT DF_Patients_CreatedAt DEFAULT (SYSUTCDATETIME()),
  UpdatedAt     DATETIME2(0)  NOT NULL CONSTRAINT DF_Patients_UpdatedAt DEFAULT (SYSUTCDATETIME())
);

CREATE TABLE dbo.Doctors(
  DoctorID    INT           NOT NULL PRIMARY KEY,
  FirstName   NVARCHAR(50)  NOT NULL,
  LastName    NVARCHAR(50)  NOT NULL,
  Specialty   NVARCHAR(80)  NOT NULL,
  Phone       NVARCHAR(20)  NULL,
  Email       NVARCHAR(100) NULL,
  CreatedAt   DATETIME2(0)  NOT NULL CONSTRAINT DF_Doctors_CreatedAt DEFAULT (SYSUTCDATETIME()),
  UpdatedAt   DATETIME2(0)  NOT NULL CONSTRAINT DF_Doctors_UpdatedAt DEFAULT (SYSUTCDATETIME())
);

CREATE TABLE dbo.Appointments(
  AppointmentID        INT           NOT NULL PRIMARY KEY,
  PatientID            INT           NOT NULL,
  DoctorID             INT           NOT NULL,
  AppointmentDateTime  DATETIME2(0)  NOT NULL,
  Status               NVARCHAR(20)  NOT NULL CHECK (Status IN ('Scheduled','Completed','Cancelled')),
  Reason               NVARCHAR(120) NULL,
  Notes                NVARCHAR(400) NULL,
  CreatedAt            DATETIME2(0)  NOT NULL CONSTRAINT DF_Appointments_CreatedAt DEFAULT (SYSUTCDATETIME()),
  UpdatedAt            DATETIME2(0)  NOT NULL CONSTRAINT DF_Appointments_UpdatedAt DEFAULT (SYSUTCDATETIME())
);

ALTER TABLE dbo.Appointments
  ADD CONSTRAINT FK_Appointments_Patients
  FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID);

ALTER TABLE dbo.Appointments
  ADD CONSTRAINT FK_Appointments_Doctors
  FOREIGN KEY (DoctorID) REFERENCES dbo.Doctors(DoctorID);

CREATE INDEX IX_Appointments_Doctor_DateTime ON dbo.Appointments(DoctorID, AppointmentDateTime);
CREATE INDEX IX_Appointments_Status ON dbo.Appointments(Status);
GO
