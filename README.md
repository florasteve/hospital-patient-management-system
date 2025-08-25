# Hospital Patient Management System

Relational database for managing **patients, doctors, and appointments** in a hospital or clinic setting.  
Built for **SQL Server** in **SSMS** with a normalized schema, **T-SQL** stored procedures, and reporting views.

---

## ✨ Features
- Patient registry with basic demographics and contact details
- Doctor directory with specialization and contact info
- Appointment scheduling with status workflow (**Scheduled**, **Completed**, **Canceled**)
- Upcoming schedule & utilization views for doctors
- Example analytics: visits in the last 6 months

---

## 🧱 Schema (Core Tables)

- `Patients(PatientID, FirstName, LastName, Age, Gender, Contact, CreatedAt, UpdatedAt)`
- `Doctors(DoctorID, FirstName, LastName, Specialization, Contact, CreatedAt, UpdatedAt)`
- `Appointments(AppointmentID, PatientID, DoctorID, AppointmentDateTime, Status, CreatedAt, UpdatedAt)`

**Status values (Appointments):** `Scheduled | Completed | Canceled`

---

## 🗺️ ER Diagram (Mermaid)

```mermaid
erDiagram
  PATIENTS ||--o{ APPOINTMENTS : books
  DOCTORS  ||--o{ APPOINTMENTS : schedules

  PATIENTS {
    int PatientID PK
    string FirstName
    string LastName
    int Age
    string Gender
    string Contact
  }

  DOCTORS {
    int DoctorID PK
    string FirstName
    string LastName
    string Specialization
    string Contact
  }

  APPOINTMENTS {
    int AppointmentID PK
    int PatientID FK
    int DoctorID FK
    datetime AppointmentDateTime
    string Status
  }
