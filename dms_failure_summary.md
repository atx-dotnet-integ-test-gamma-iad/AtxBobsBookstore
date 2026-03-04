# DMS Failure Summary - BobsBookstore Migration

## Overview
All 5 SQL statements failed during DMS MCP tool conversion. Manual conversion was applied with lowercase schema mapping for PostgreSQL compatibility.

## DMS Configuration Used
- **Migration Project ARN**: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- **Database Name**: `BobsBookstore`
- **Schema Name**: `dbo`
- **Region**: `us-east-1`
- **Server Name** (auto-detected): `172.31.93.178`

## Common Error
All 5 statements returned the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
```

## Statement-by-Statement Details

### Statement 1: EditUsingStoredProcedure
- **Source**: `AuthorsController.cs` → `EditUsingStoredProcedure` method
- **Original MS SQL**: `EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender`
- **DMS Output**: Error - Metadata model creation failed: The selected objects were not found.
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**: 
  - EXEC stored procedure call converted to PostgreSQL function call via SELECT * FROM
  - Schema `dbo` mapped to `bobsbookstore_dbo` (database_schema lowercase convention)
  - Stored procedure name lowercased: `uspUpdateAuthorPersonalInfo` → `uspupdateauthorpersonalinfo`

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source**: `AuthorsController.cs` → `FindAllAuthorsEmbeddedSql` method
- **Original MS SQL**: `SELECT * FROM dbo.Author`
- **DMS Output**: Error - Metadata model creation failed: The selected objects were not found.
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.author`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**:
  - Schema `dbo` mapped to `bobsbookstore_dbo`
  - Table name lowercased: `Author` → `author`

### Statement 3: DeleteAuthorEmbeddedSql
- **Source**: `AuthorsController.cs` → `DeleteAuthorEmbeddedSql` method
- **Original MS SQL**: `EXEC dbo.uspDeleteAuthor @BusinessEntityID`
- **DMS Output**: Error - Metadata model creation failed: The selected objects were not found.
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**:
  - EXEC stored procedure call converted to PostgreSQL function call via SELECT * FROM
  - Schema `dbo` mapped to `bobsbookstore_dbo`
  - Stored procedure name lowercased: `uspDeleteAuthor` → `uspdeleteauthor`

### Statement 4: SelectAuthorsByHireYear
- **Source**: `AuthorsController.cs` → `SelectAuthorsByHireYear` method
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate`
- **DMS Output**: Error - Metadata model creation failed: The selected objects were not found.
- **Manual Conversion**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**:
  - All column names lowercased: `BusinessEntityID` → `businessentityid`, `ModifiedDate` → `modifieddate`, `BirthDate` → `birthdate`, `HireDate` → `hiredate`
  - `CONVERT(VARCHAR, ModifiedDate, 120)` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')` (style 120 = ODBC canonical yyyy-mm-dd hh:mi:ss)
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `NOW()`
  - Schema `dbo` mapped to `bobsbookstore_dbo`
  - Table name lowercased: `Author` → `author`
  - Alias names lowercased: `FormattedModifiedDate` → `formattedmodifieddate`, `Age` → `age`

### Statement 5: FindAllProducts
- **Source**: `ProductsController.cs` → `FindAllProducts` method
- **Original MS SQL**: `EXEC dbo.uspGetProductData`
- **DMS Output**: Error - Metadata model creation failed: The selected objects were not found.
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Conversion Notes**:
  - EXEC stored procedure call converted to PostgreSQL function call via SELECT * FROM
  - Schema `dbo` mapped to `bobsbookstore_dbo`
  - Stored procedure name lowercased: `uspGetProductData` → `uspgetproductdata`

## SQL Equivalency Validation Results
All 5 statement pairs were validated through the SQL Equivalency MCP tool.
All 5 returned ERROR status with error message: `'uniqueID'`

| # | Statement | Equivalency Status |
|---|-----------|-------------------|
| 1 | EditUsingStoredProcedure | ERROR |
| 2 | FindAllAuthorsEmbeddedSql | ERROR |
| 3 | DeleteAuthorEmbeddedSql | ERROR |
| 4 | SelectAuthorsByHireYear | ERROR |
| 5 | FindAllProducts | ERROR |
