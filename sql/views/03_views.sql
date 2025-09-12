USE HospitalDB;
GO

-- Doctor utilization per day
CREATE OR ALTER VIEW dbo.vwDoctorUtilization AS
SELECT
  d.DoctorID,
  d.FirstName AS DoctorFirst,
  d.LastName  AS DoctorLast,
  CAST(a.AppointmentDateTime AS DATE) AS ApptDate,
  SUM(CASE WHEN a.Status='Scheduled' THEN 1 ELSE 0 END) AS SlotsScheduled,
  SUM(CASE WHEN a.Status='Completed' THEN 1 ELSE 0 END) AS SlotsCompleted,
  SUM(CASE WHEN a.Status='Canceled'  THEN 1 ELSE 0 END) AS SlotsCanceled
FROM dbo.Doctors d
LEFT JOIN dbo.Appointments a ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName, CAST(a.AppointmentDateTime AS DATE);
GO

-- Upcoming appointments (next 14 days) — no ORDER BY in view
CREATE OR ALTER VIEW dbo.vwUpcomingAppointments AS
SELECT
  a.AppointmentID,
  a.PatientID,
  p.FirstName AS PatientFirst,
  p.LastName  AS PatientLast,
  a.DoctorID,
  d.FirstName AS DoctorFirst,
  d.LastName  AS DoctorLast,
  a.AppointmentDateTime,
  a.Status
FROM dbo.Appointments a
JOIN dbo.Patients p ON p.PatientID = a.PatientID
JOIN dbo.Doctors  d ON d.DoctorID = a.DoctorID
WHERE a.AppointmentDateTime >= SYSUTCDATETIME()
  AND a.AppointmentDateTime <  DATEADD(day, 14, SYSUTCDATETIME());
GO

-- Patient last-visit summary
CREATE OR ALTER VIEW dbo.vwPatientLastVisit AS
SELECT
  p.PatientID,
  p.FirstName,
  p.LastName,
  MAX(CASE WHEN a.Status='Completed' THEN a.AppointmentDateTime END) AS LastCompletedVisit
FROM dbo.Patients p
LEFT JOIN dbo.Appointments a ON a.PatientID = p.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName;
GO
