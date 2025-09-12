USE HospitalDB;
GO
-- tables should have rows after seeding
IF (SELECT COUNT(*) FROM dbo.Patients) = 0 THROW 51100, 'Patients empty', 1;
IF (SELECT COUNT(*) FROM dbo.Doctors)  = 0 THROW 51101, 'Doctors empty', 1;
IF (SELECT COUNT(*) FROM dbo.Appointments) = 0 THROW 51102, 'Appointments empty', 1;

-- views should SELECT without error
SELECT TOP 1 * FROM dbo.vwDoctorScheduleUpcoming;
SELECT TOP 1 * FROM dbo.vwPatientVisitHistory;
SELECT TOP 1 * FROM dbo.vwDoctorUtilization30d;

-- procedures basic execution
DECLARE @ApptID INT;
EXEC dbo.sp_ScheduleAppointment @PatientID=1, @DoctorID=101, @DateTime=DATEADD(hour, 2, SYSUTCDATETIME()), @Reason=N'Demo';
SELECT @ApptID = SCOPE_IDENTITY(); -- not set because proc returns SELECT, so just pick latest
SELECT TOP 1 @ApptID = AppointmentID FROM dbo.Appointments ORDER BY AppointmentID DESC;
EXEC dbo.sp_CompleteAppointment @AppointmentID=@ApptID;
EXEC dbo.sp_CancelAppointment   @AppointmentID=@ApptID; -- ok to cancel already completed; real logic could block if desired
GO
