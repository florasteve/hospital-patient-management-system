USE HospitalDB;
GO

-- Book a new appointment (fails if overlapping same doctor/time)
CREATE OR ALTER PROCEDURE dbo.spBookAppointment
  @AppointmentID INT,
  @PatientID INT,
  @DoctorID INT,
  @AppointmentDateTime DATETIME2
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Patients WHERE PatientID=@PatientID)
    THROW 50001, 'Patient does not exist.', 1;

  IF NOT EXISTS (SELECT 1 FROM dbo.Doctors WHERE DoctorID=@DoctorID)
    THROW 50002, 'Doctor does not exist.', 1;

  IF EXISTS (
    SELECT 1
    FROM dbo.Appointments
    WHERE DoctorID=@DoctorID
      AND AppointmentDateTime=@AppointmentDateTime
      AND Status IN ('Scheduled','Completed') -- treat completed as occupied slot historically
  )
    THROW 50003, 'Time slot already taken for this doctor.', 1;

  INSERT INTO dbo.Appointments(AppointmentID,PatientID,DoctorID,AppointmentDateTime,Status)
  VALUES(@AppointmentID,@PatientID,@DoctorID,@AppointmentDateTime,'Scheduled');
END;
GO

-- Cancel an appointment
CREATE OR ALTER PROCEDURE dbo.spCancelAppointment
  @AppointmentID INT
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE AppointmentID=@AppointmentID)
    THROW 50004, 'Appointment not found.', 1;

  UPDATE dbo.Appointments
    SET Status='Canceled', UpdatedAt=SYSUTCDATETIME()
  WHERE AppointmentID=@AppointmentID;
END;
GO

-- Mark appointment completed
CREATE OR ALTER PROCEDURE dbo.spCompleteAppointment
  @AppointmentID INT
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE AppointmentID=@AppointmentID)
    THROW 50005, 'Appointment not found.', 1;

  UPDATE dbo.Appointments
    SET Status='Completed', UpdatedAt=SYSUTCDATETIME()
  WHERE AppointmentID=@AppointmentID;
END;
GO
