<!-- Badges -->
[![License](https://img.shields.io/github/license/florasteve/hospital-patient-management-system)](LICENSE)
[![Last commit](https://img.shields.io/github/last-commit/florasteve/hospital-patient-management-system)](https://github.com/florasteve/hospital-patient-management-system/commits/main)
[![Open issues](https://img.shields.io/github/issues/florasteve/hospital-patient-management-system)](https://github.com/florasteve/hospital-patient-management-system/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/florasteve/hospital-patient-management-system/pulls)
![DB: SQL Server](https://img.shields.io/badge/DB-Microsoft%20SQL%20Server-CC2927?logo=microsoft-sql-server&logoColor=white)
![Container: Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)

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

## Troubleshooting — Schema drift & CSV seeding

If you see errors like:

- `Invalid column name 'Age'` / `'Contact'`
- `Cannot insert the value NULL into column 'DateOfBirth'`
- `MERGE ... conflicted with FOREIGN KEY constraint 'FK_Appointments_Patients'`

…it means the live DB schema drifted from what the seeds expect.

**Fix (non-destructive):** align the schema, then re-seed.

```bash
# From docker/ (Git Bash)
set +H; printf "SA_PASSWORD=YourStrong!Passw0rd
" > ./.env; set -a; source ./.env; set +a

# Align: add/rename/make columns nullable if needed
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" \
  -i /var/opt/mssql/scripts/ddl/99_align_schema.sql

# Ensure Patients.DateOfBirth is nullable (CSV doesn’t include DOB)
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" -Q "
USE HospitalDB;
IF COL_LENGTH('dbo.Patients','DateOfBirth') IS NULL
  ALTER TABLE dbo.Patients ADD DateOfBirth DATETIME2 NULL;
ELSE IF COLUMNPROPERTY(OBJECT_ID('dbo.Patients'),'DateOfBirth','AllowsNull') = 0
  ALTER TABLE dbo.Patients ALTER COLUMN DateOfBirth DATETIME2 NULL;
"

# Re-seed from CSVs (reads from /var/opt/mssql/imports)
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" \
  -i /var/opt/mssql/scripts/dml/05_seed_from_csv.sql

# Verify
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" -Q "USE HospitalDB;
SELECT COUNT(*) Doctors FROM dbo.Doctors;
SELECT COUNT(*) Patients FROM dbo.Patients;
SELECT COUNT(*) Appointments FROM dbo.Appointments;"

