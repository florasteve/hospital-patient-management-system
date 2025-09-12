USE HospitalDB;
GO

-- Doctors
INSERT INTO dbo.Doctors(DoctorID,FirstName,LastName,Specialization,Contact,CreatedAt,UpdatedAt) VALUES
(1,'Maya','Singh','Cardiology','maya.singh@hospital.local',SYSUTCDATETIME(),SYSUTCDATETIME()),
(2,'Noah','Brooks','Orthopedics','noah.brooks@hospital.local',SYSUTCDATETIME(),SYSUTCDATETIME()),
(3,'Olivia','Diaz','Family Medicine','olivia.diaz@hospital.local',SYSUTCDATETIME(),SYSUTCDATETIME());

-- Patients
INSERT INTO dbo.Patients(PatientID,FirstName,LastName,Age,Gender,Contact,CreatedAt,UpdatedAt) VALUES
(1,'Alex','Martin',34,'M','alex.martin@example.com','2025-08-01T09:15:00','2025-08-01T09:15:00'),
(2,'Brianna','Lopez',28,'F','bri.lopez@example.com','2025-08-02T11:02:00','2025-08-02T11:02:00'),
(3,'Charles','Nguyen',52,'M','charles.nguyen@example.com','2025-08-03T14:30:00','2025-08-07T10:10:00'),
(4,'Diana','Patel',41,'F','diana.patel@example.com','2025-08-04T08:45:00','2025-08-04T08:45:00'),
(5,'Evan','Reed',66,'M','evan.reed@example.com','2025-08-05T10:20:00','2025-08-05T10:20:00'),
(6,'Farah','Hassan',37,'F','farah.hassan@example.com','2025-08-06T15:05:00','2025-08-10T09:00:00'),
(7,'Gabriel','Ramos',22,'M','gabriel.ramos@example.com','2025-08-06T16:40:00','2025-08-06T16:40:00'),
(8,'Hannah','Kim',31,'F','hannah.kim@example.com','2025-08-07T12:00:00','2025-08-07T12:00:00'),
(9,'Ian','Chen',47,'M','ian.chen@example.com','2025-08-08T09:55:00','2025-08-08T09:55:00'),
(10,'Jasmine','Garcia',55,'F','jas.garcia@example.com','2025-08-09T13:25:00','2025-08-11T11:11:00');

-- Appointments
INSERT INTO dbo.Appointments(AppointmentID,PatientID,DoctorID,AppointmentDateTime,Status) VALUES
(1001,1,1,'2025-08-15T09:00:00','Completed'),
(1002,2,2,'2025-08-16T11:30:00','Scheduled'),
(1003,3,3,'2025-08-16T14:00:00','Canceled'),
(1004,4,1,'2025-08-17T10:15:00','Completed'),
(1005,5,2,'2025-08-18T13:45:00','Scheduled'),
(1006,6,3,'2025-08-18T15:00:00','Scheduled'),
(1007,7,1,'2025-08-19T09:30:00','Completed'),
(1008,8,2,'2025-08-19T10:45:00','Scheduled'),
(1009,9,3,'2025-08-20T16:00:00','Scheduled'),
(1010,10,1,'2025-08-21T08:30:00','Scheduled');
GO
