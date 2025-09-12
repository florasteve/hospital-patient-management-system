USE HospitalDB;
GO
DECLARE @cn sysname;

-- Find the existing CHECK constraint on dbo.Appointments(Status)
SELECT @cn = c.name
FROM sys.check_constraints c
JOIN sys.columns col
  ON col.object_id = c.parent_object_id
 AND col.column_id = c.parent_column_id
WHERE c.parent_object_id = OBJECT_ID('dbo.Appointments')
  AND col.name = 'Status';

-- Drop it if present (safe)
IF @cn IS NOT NULL
BEGIN
  DECLARE @sql nvarchar(400) =
    N'ALTER TABLE dbo.Appointments DROP CONSTRAINT ' + QUOTENAME(@cn) + N';';
  EXEC sp_executesql @sql;
END

-- Recreate with a clear name and broader allowed set
ALTER TABLE dbo.Appointments WITH NOCHECK
  ADD CONSTRAINT CK_Appointments_Status
    CHECK (Status IN (N'Scheduled', N'Completed', N'Canceled', N'Cancelled'));
ALTER TABLE dbo.Appointments WITH CHECK CHECK CONSTRAINT CK_Appointments_Status;
GO
