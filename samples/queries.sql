/* ============================================================
   Hospital Patient Management System — Sample Queries (T-SQL)
   Adjust table/column names if your schema differs.
   ============================================================ */

-- Optional: target database
-- USE HospitalDB;
-- GO

/* -------------------------------
   Parameters (adjust as needed)
----------------------------------*/
DECLARE @DoctorId INT = 1;
DECLARE @DoctorLastName NVARCHAR(100) = N'Smith';

/* 1) Upcoming appointments for a specific doctor (by DoctorID) */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    a.Status,
    p.PatientID,
    p.FirstName + ' ' + p.LastName AS Patient,
    d.DoctorID,
    d.FirstName + ' ' + d.LastName AS Doctor
FROM dbo.Appointments AS a
JOIN dbo.Patients    AS p ON p.PatientID = a.PatientID
JOIN dbo.Doctors     AS d ON d.DoctorID  = a.DoctorID
WHERE a.DoctorID = @DoctorId
  AND a.Status = 'Scheduled'
  AND a.AppointmentDateTime >= SYSDATETIME()
ORDER BY a.AppointmentDateTime;

/* 1b) Upcoming appointments (by Doctor LastName match) */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    a.Status,
    p.PatientID,
    p.FirstName + ' ' + p.LastName AS Patient,
    d.DoctorID,
    d.FirstName + ' ' + d.LastName AS Doctor
FROM dbo.Appointments AS a
JOIN dbo.Patients    AS p ON p.PatientID = a.PatientID
JOIN dbo.Doctors     AS d ON d.DoctorID  = a.DoctorID
WHERE d.LastName = @DoctorLastName
  AND a.Status = 'Scheduled'
  AND a.AppointmentDateTime >= SYSDATETIME()
ORDER BY a.AppointmentDateTime;

/* 2) Count how many patients have visited in the last 6 months
      (define "visited" = at least one Completed appointment) */
SELECT
    COUNT(DISTINCT a.PatientID) AS PatientsVisitedLast6Months
FROM dbo.Appointments AS a
WHERE a.Status = 'Completed'
  AND a.AppointmentDateTime >= DATEADD(MONTH, -6, CAST(SYSDATETIME() AS DATE));

/* 2b) Optional: month-by-month counts for the last 6 months */
SELECT
    FORMAT(a.AppointmentDateTime, 'yyyy-MM') AS YearMonth,
    COUNT(DISTINCT a.PatientID)              AS UniquePatients
FROM dbo.Appointments AS a
WHERE a.Status = 'Completed'
  AND a.AppointmentDateTime >= DATEADD(MONTH, -6, CAST(SYSDATETIME() AS DATE))
GROUP BY FORMAT(a.AppointmentDateTime, 'yyyy-MM')
ORDER BY YearMonth;

/* Additional handy queries */

/* Doctor's schedule over next 7 days */
SELECT
    d.DoctorID,
    d.FirstName + ' ' + d.LastName AS Doctor,
    a.AppointmentDateTime,
    a.Status,
    p.FirstName + ' ' + p.LastName AS Patient
FROM dbo.Appointments AS a
JOIN dbo.Doctors     AS d ON d.DoctorID  = a.DoctorID
JOIN dbo.Patients    AS p ON p.PatientID = a.PatientID
WHERE a.AppointmentDateTime >= CAST(SYSDATETIME() AS DATE)
  AND a.AppointmentDateTime <  DATEADD(DAY, 7, CAST(SYSDATETIME() AS DATE))
ORDER BY d.LastName, a.AppointmentDateTime;

/* Cancellations in the last 30 days */
SELECT
    COUNT(*) AS CanceledLast30Days
FROM dbo.Appointments
WHERE Status = 'Canceled'
  AND AppointmentDateTime >= DATEADD(DAY, -30, CAST(SYSDATETIME() AS DATE));

/* Basic indexes to consider (run once after schema creation)
CREATE INDEX IX_Appointments_Doctor_Date    ON dbo.Appointments(DoctorID, AppointmentDateTime);
CREATE INDEX IX_Appointments_Patient_Date   ON dbo.Appointments(PatientID, AppointmentDateTime);
CREATE INDEX IX_Doctors_LastName_FirstName  ON dbo.Doctors(LastName, FirstName);
CREATE INDEX IX_Patients_LastName_FirstName ON dbo.Patients(LastName, FirstName);
*/
