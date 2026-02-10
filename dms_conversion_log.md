-- ============================================================================
-- DMS Conversion Log
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file documents all DMS MCP tool conversion attempts, outputs, errors,
-- and manual conversions applied after DMS failures.
-- ============================================================================

## DMS Tool Status

All 5 SQL statements were passed through the DMS MCP tool for conversion as required by the transformation definition. However, all conversions encountered the same error.

## Common DMS Error

**Error Type**: Metadata model creation failed
**Error Message**: "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}"
**Error Timestamp**: Multiple attempts between 2026-02-10T02:17:06 and 2026-02-10T02:17:54

This error indicates that the DMS service was unable to create the metadata model required for SQL conversion, likely due to a service-level issue or configuration problem with the migration project.

## DMS Tool Invocation Details

### Statement 1: Update Author Personal Information (Stored Procedure)
**Input SQL**:
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
```

**DMS Parameters**:
- schema_name: bobsbookstore_dbo
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- region: us-east-1

**DMS Output**:
```json
{
  "conversion_timestamp": "2026-02-10T02:17:06.059235",
  "status": "error",
  "error": "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}",
  "error_timestamp": "2026-02-10T02:17:09.346564"
}
```

**Manual Conversion Applied**: YES
**Conversion Method**: MANUAL_AFTER_DMS_FAILURE

**PostgreSQL Conversion**:
```sql
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

**Conversion Rationale**:
- PostgreSQL functions are called using SELECT instead of EXEC
- Removed DECLARE statement (not needed for function calls)
- Removed explicit return value assignment
- Function name converted to lowercase per PostgreSQL schema conventions
- Schema notation preserved as bobsbookstore_dbo
- Function is expected to return the rows affected count directly

---

### Statement 2: Select All Authors
**Input SQL**:
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**DMS Parameters**:
- schema_name: bobsbookstore_dbo
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- region: us-east-1

**DMS Output**:
```json
{
  "conversion_timestamp": "2026-02-10T02:17:17.973296",
  "status": "error",
  "error": "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}",
  "error_timestamp": "2026-02-10T02:17:21.296169"
}
```

**Manual Conversion Applied**: YES
**Conversion Method**: MANUAL_AFTER_DMS_FAILURE

**PostgreSQL Conversion**:
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**Conversion Rationale**:
- This is a simple SELECT statement that is already PostgreSQL compatible
- No SQL Server-specific syntax present
- Schema and table names remain the same per ApplicationDbContext.cs configuration
- No changes required for PostgreSQL

---

### Statement 3: Delete Author (Stored Procedure)
**Input SQL**:
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
```

**DMS Parameters**:
- schema_name: bobsbookstore_dbo
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- region: us-east-1

**DMS Output**:
```json
{
  "conversion_timestamp": "2026-02-10T02:17:29.721426",
  "status": "error",
  "error": "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}",
  "error_timestamp": "2026-02-10T02:17:32.576665"
}
```

**Manual Conversion Applied**: YES
**Conversion Method**: MANUAL_AFTER_DMS_FAILURE

**PostgreSQL Conversion**:
```sql
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

**Conversion Rationale**:
- PostgreSQL functions are called using SELECT instead of EXEC
- Removed DECLARE statement (not needed for function calls)
- Removed explicit return value assignment
- Function name converted to lowercase per PostgreSQL schema conventions
- Schema notation preserved as bobsbookstore_dbo
- Function is expected to return the rows affected count directly

---

### Statement 4: Select Authors by Hire Year with Age Calculation
**Input SQL**:
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate
```

**DMS Parameters**:
- schema_name: bobsbookstore_dbo
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- region: us-east-1

**DMS Output**:
```json
{
  "conversion_timestamp": "2026-02-10T02:17:40.822917",
  "status": "error",
  "error": "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}",
  "error_timestamp": "2026-02-10T02:17:43.826703"
}
```

**Manual Conversion Applied**: YES
**Conversion Method**: MANUAL_AFTER_DMS_FAILURE

**PostgreSQL Conversion**:
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate
```

**Conversion Rationale**:
- FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
  * PostgreSQL uses TO_CHAR for date formatting
  * Format string adjusted: yyyy→YYYY, HH:mm:ss→HH24:MI:SS
- DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))
  * PostgreSQL uses AGE() function for date differences
  * EXTRACT(YEAR FROM ...) gets the year component
  * GETDATE() → CURRENT_DATE
- DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM hiredate)
  * PostgreSQL uses EXTRACT for date part extraction
- Column names converted to lowercase per PostgreSQL schema conventions in ApplicationDbContext.cs
- Table and schema names remain bobsbookstore_dbo.author

---

### Statement 5: Get All Product Data (Stored Procedure)
**Input SQL**:
```sql
EXEC [dbo].[uspGetProductData]
```

**DMS Parameters**:
- schema_name: bobsbookstore_dbo
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- region: us-east-1

**DMS Output**:
```json
{
  "conversion_timestamp": "2026-02-10T02:17:51.591121",
  "status": "error",
  "error": "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}",
  "error_timestamp": "2026-02-10T02:17:54.703030"
}
```

**Manual Conversion Applied**: YES
**Conversion Method**: MANUAL_AFTER_DMS_FAILURE

**PostgreSQL Conversion**:
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata()
```

**Conversion Rationale**:
- PostgreSQL functions that return result sets are called using SELECT * FROM function_name()
- Removed EXEC keyword (not used in PostgreSQL)
- Function name converted to lowercase per PostgreSQL schema conventions
- Schema notation preserved as bobsbookstore_dbo
- Added parentheses () to indicate function call
- This assumes the stored procedure was converted to a PostgreSQL function that returns a table/result set

---

## Summary

**Total Statements Processed**: 5
**DMS Successful Conversions**: 0
**DMS Failed Conversions**: 5
**Manual Conversions Applied**: 5

**Common Issues**:
- All statements failed with the same DMS metadata model creation error
- Error suggests a service-level issue rather than SQL syntax problems
- Manual conversions were necessary for all statements

**Conversion Patterns Applied**:
1. Stored procedure calls: EXEC → SELECT function_name()
2. Date formatting: FORMAT() → TO_CHAR()
3. Date arithmetic: DATEDIFF() → AGE() with EXTRACT()
4. Current date: GETDATE() → CURRENT_DATE
5. Date part extraction: DATEPART() → EXTRACT()
6. Schema/table/column names: Preserved lowercase per ApplicationDbContext.cs mappings

**Manual Review Required**:
- All converted statements require validation through SQL Equivalency tool
- Stored procedures (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData) must exist as PostgreSQL functions in the database
- Function return types must match expected behavior (rows affected counts, result sets)

---

## Compliance Notes

As required by the transformation definition:
✓ ALL 5 statements were passed through DMS MCP tool (no exceptions)
✓ DMS tool output documented for each statement
✓ Manual conversions applied only AFTER DMS failure
✓ Each manual conversion includes detailed rationale
✓ All conversions will be validated through SQL Equivalency tool in next step
