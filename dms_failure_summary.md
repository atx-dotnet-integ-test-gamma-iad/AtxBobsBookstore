# DMS Conversion Failure Summary

## Overview
All 5 SQL statements failed DMS conversion due to metadata model creation failure.
Manual conversion was performed using lowercase schema mapping rules as specified in the migration plan.

## Common DMS Error
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```

## Statement Conversion Details

### Statement 1: EditUsingStoredProcedure
- **DMS Status**: FAILED
- **DMS Error**: Metadata model creation failed - No objects found
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Manual PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 2: FindAllAuthorsEmbeddedSql
- **DMS Status**: FAILED
- **DMS Error**: Metadata model creation failed - No objects found
- **Original MS SQL**: `SELECT * FROM [dbo].[Author]`
- **Manual PostgreSQL**: `SELECT * FROM bobsbookstore_dbo."author"`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 3: DeleteAuthorEmbeddedSql
- **DMS Status**: FAILED
- **DMS Error**: Metadata model creation failed - No objects found
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Manual PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 4: SelectAuthorsByHireYear
- **DMS Status**: FAILED
- **DMS Error**: Metadata model creation failed - No objects found
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR(10), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate`
- **Manual PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo."author" WHERE EXTRACT(YEAR FROM hiredate) = @HireDate`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 5: FindAllProducts
- **DMS Status**: FAILED
- **DMS Error**: Metadata model creation failed - No objects found
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Manual PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
