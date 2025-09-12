USE HospitalDB;
GO
CREATE OR ALTER VIEW dbo.vwRecentAndUpcomingAppointments AS
SELECT
  a.AppointmentID, a.PatientID, p.FirstName AS PatientFirst, p.LastName AS PatientLast,
  a.DoctorID, d.FirstName AS DoctorFirst, d.LastName AS DoctorLast,
  a.AppointmentDateTime, a.Status
FROM dbo.Appointments a
JOIN dbo.Patients p ON p.PatientID = a.PatientID
JOIN dbo.Doctors  d ON d.DoctorID = a.DoctorID
WHERE a.AppointmentDateTime BETWEEN DATEADD(day, -30, SYSUTCDATETIME())
                              AND DATEADD(day,  30, SYSUTCDATETIME());
GO
