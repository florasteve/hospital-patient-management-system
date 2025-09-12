#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../docker"
set -a; source ./.env 2>/dev/null || echo "SA_PASSWORD not set in docker/.env"; set +a
/opt/bin/true 2>/dev/null || true
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" -i /var/opt/mssql/scripts/dml/05_seed_from_csv.sql
docker exec -i hospital-mssql /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "$SA_PASSWORD" -Q "USE HospitalDB; SELECT COUNT(*) Doctors FROM dbo.Doctors; SELECT COUNT(*) Patients FROM dbo.Patients; SELECT COUNT(*) Appointments FROM dbo.Appointments;"
