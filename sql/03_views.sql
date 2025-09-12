USE HospitalDB;
GO

IF OBJECT_ID('dbo.vwDoctorScheduleUpcoming','V') IS NOT NULL DROP VIEW dbo.vwDoctorScheduleUpcoming;
GO
CREATE VIEW dbo.vwDoctorScheduleUpcoming AS
SELECT
  d.DoctorID,
  d.FirstName  AS DoctorFirstName,
  d.LastName   AS DoctorLastName,
  a.AppointmentID,
  a.AppointmentDateTime,
  a.Status,
  p.PatientID,
  p.FirstName  AS PatientFirstName,
  p.LastName   AS PatientLastName,
  a.Reason
FROM dbo.Appointments a
JOIN dbo.Doctors d  ON a.DoctorID = d.DoctorID
JOIN dbo.Patients p ON a.PatientID = p.PatientID
WHERE a.AppointmentDateTime >= SYSUTCDATETIME()
  AND a.AppointmentDateTime < DATEADD(day, 30, SYSUTCDATETIME());

IF OBJECT_ID('dbo.vwPatientVisitHistory','V') IS NOT NULL DROP VIEW dbo.vwPatientVisitHistory;
GO
CREATE VIEW dbo.vwPatientVisitHistory AS
SELECT
  p.PatientID,
  p.FirstName  AS PatientFirstName,
  p.LastName   AS PatientLastName,
  a.AppointmentID,
  a.AppointmentDateTime,
  a.Status,
  d.DoctorID,
  d.FirstName  AS DoctorFirstName,
  d.LastName   AS DoctorLastName,
  a.Reason
FROM dbo.Appointments a
JOIN dbo.Patients p ON a.PatientID = p.PatientID
JOIN dbo.Doctors d  ON a.DoctorID = d.DoctorID;

IF OBJECT_ID('dbo.vwDoctorUtilization30d','V') IS NOT NULL DROP VIEW dbo.vwDoctorUtilization30d;
GO
CREATE VIEW dbo.vwDoctorUtilization30d AS
WITH last30 AS (
  SELECT *
  FROM dbo.Appointments
  WHERE AppointmentDateTime >= DATEADD(day, -30, SYSUTCDATETIME())
)
SELECT
  d.DoctorID,
  d.FirstName AS DoctorFirstName,
  d.LastName  AS DoctorLastName,
  COUNT(*)                                   AS TotalAppointments,
  SUM(CASE WHEN Status='Completed' THEN 1 ELSE 0 END) AS CompletedCount,
  CAST(100.0*SUM(CASE WHEN Status='Completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS CompletionRatePct
FROM last30 a
JOIN dbo.Doctors d ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName;
GO
