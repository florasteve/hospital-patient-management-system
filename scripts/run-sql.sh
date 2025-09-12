#!/usr/bin/env bash
set -euo pipefail

SERVER="${SERVER:-localhost,1433}"
DB_NAME="${DB_NAME:-HospitalDB}"

# Try SQL auth first if provided; otherwise Windows auth (-E)
if [ -n "${SQLUSER:-}" ]; then
  sqlcmd -S "$SERVER" -d master -Q "IF DB_ID('$DB_NAME') IS NULL CREATE DATABASE [$DB_NAME];" -C -U "$SQLUSER" -P "${SQLPASS:-}"
else
  sqlcmd -S "$SERVER" -d master -Q "IF DB_ID('$DB_NAME') IS NULL CREATE DATABASE [$DB_NAME];" -C -E
fi

for f in $(ls -1 sql/*.sql | sort); do
  echo ">> Running $f"
  if [ -n "${SQLUSER:-}" ]; then
    sqlcmd -S "$SERVER" -d "$DB_NAME" -i "$f" -C -U "$SQLUSER" -P "${SQLPASS:-}"
  else
    sqlcmd -S "$SERVER" -d "$DB_NAME" -i "$f" -C -E
  fi
done

echo "Done."
