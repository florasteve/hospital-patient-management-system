USE HospitalDB;
GO

IF OBJECT_ID('dbo.sp_ScheduleAppointment','P') IS NOT NULL DROP PROCEDURE dbo.sp_ScheduleAppointment;
GO
CREATE PROCEDURE dbo.sp_ScheduleAppointment
  @PatientID INT,
  @DoctorID INT,
  @DateTime DATETIME2(0),
  @Reason NVARCHAR(120) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Patients WHERE PatientID=@PatientID)
    THROW 51010, 'Patient does not exist.', 1;

  IF NOT EXISTS (SELECT 1 FROM dbo.Doctors WHERE DoctorID=@DoctorID)
    THROW 51011, 'Doctor does not exist.', 1;

  IF EXISTS (
    SELECT 1 FROM dbo.Appointments
    WHERE DoctorID=@DoctorID AND AppointmentDateTime=@DateTime AND Status <> 'Cancelled'
  )
    THROW 51012, 'Doctor is already booked at this time.', 1;

  DECLARE @NewID INT = (SELECT ISNULL(MAX(AppointmentID),1000)+1 FROM dbo.Appointments);

  INSERT INTO dbo.Appointments(AppointmentID,PatientID,DoctorID,AppointmentDateTime,Status,Reason,Notes)
  VALUES (@NewID,@PatientID,@DoctorID,@DateTime,'Scheduled',@Reason,NULL);

  SELECT @NewID AS AppointmentID;
END
GO

IF OBJECT_ID('dbo.sp_CancelAppointment','P') IS NOT NULL DROP PROCEDURE dbo.sp_CancelAppointment;
GO
CREATE PROCEDURE dbo.sp_CancelAppointment
  @AppointmentID INT
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE AppointmentID=@AppointmentID)
    THROW 51013, 'Appointment not found.', 1;

  UPDATE dbo.Appointments
    SET Status='Cancelled', UpdatedAt=SYSUTCDATETIME()
    WHERE AppointmentID=@AppointmentID;
END
GO

IF OBJECT_ID('dbo.sp_CompleteAppointment','P') IS NOT NULL DROP PROCEDURE dbo.sp_CompleteAppointment;
GO
CREATE PROCEDURE dbo.sp_CompleteAppointment
  @AppointmentID INT
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE AppointmentID=@AppointmentID)
    THROW 51014, 'Appointment not found.', 1;

  UPDATE dbo.Appointments
    SET Status='Completed', UpdatedAt=SYSUTCDATETIME()
    WHERE AppointmentID=@AppointmentID;
END
GO
