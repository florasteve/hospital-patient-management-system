USE HospitalDB;
GO
-- ===== Doctors: normalize columns =====
IF COL_LENGTH('dbo.Doctors','Specialization') IS NULL AND COL_LENGTH('dbo.Doctors','Specialty') IS NOT NULL
  EXEC sp_rename 'dbo.Doctors.Specialty','Specialization','COLUMN';
GO
IF COL_LENGTH('dbo.Doctors','Specialization') IS NOT NULL AND COL_LENGTH('dbo.Doctors','Specialty') IS NOT NULL
BEGIN
  UPDATE d SET d.Specialization = COALESCE(d.Specialization, d.Specialty) FROM dbo.Doctors d;
  ALTER TABLE dbo.Doctors ALTER COLUMN Specialization NVARCHAR(80) NULL;
  ALTER TABLE dbo.Doctors DROP COLUMN Specialty;
END;
GO
IF COL_LENGTH('dbo.Doctors','Specialization') IS NULL
  ALTER TABLE dbo.Doctors ADD Specialization NVARCHAR(80) NULL;
GO
IF COL_LENGTH('dbo.Doctors','Contact') IS NULL
  ALTER TABLE dbo.Doctors ADD Contact NVARCHAR(100) NULL;
GO

-- ===== Patients: add any missing columns expected by the seeder =====
IF COL_LENGTH('dbo.Patients','Age') IS NULL
  ALTER TABLE dbo.Patients ADD Age INT NULL;
GO
IF COL_LENGTH('dbo.Patients','Gender') IS NULL
  ALTER TABLE dbo.Patients ADD Gender NVARCHAR(10) NULL;
GO
IF COL_LENGTH('dbo.Patients','Contact') IS NULL
  ALTER TABLE dbo.Patients ADD Contact NVARCHAR(100) NULL;
GO
