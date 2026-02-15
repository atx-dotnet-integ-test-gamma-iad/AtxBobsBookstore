# PostgreSQL Schema Qualification Transformation Report

## Transformation Summary

**Date:** 2024
**Source Database:** SQL Server/MSSQL
**Target Database:** PostgreSQL
**Target Schema:** bobsbookstore_dbo

---

## Files Processed: 2

### File 1: AuthorsController.cs
**Path:** `/QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs`

#### SQL Queries Transformed: 2

##### 1. FindAllAuthorsEmbeddedSql() Method
**Line:** ~187
**Original SQL:**
```sql
SELECT * FROM Author
```

**Transformed SQL:**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**Tables Qualified:**
- `Author` → `bobsbookstore_dbo.author`

---

##### 2. SelectAuthorsByHireYear() Method
**Line:** ~224
**Original SQL:**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM Author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**Transformed SQL:**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**Tables Qualified:**
- `Author` → `bobsbookstore_dbo.author`

**Note:** T-SQL functions (FORMAT, DATEDIFF, GETDATE, DATEPART) and @Parameter syntax were preserved as-is per transformation guidelines. These will need separate T-SQL to PL/pgSQL conversion.

---

#### Parameter Type Conversions: 5 instances

All `SqlParameter` references have been converted to `NpgsqlParameter`:

1. **EditUsingStoredProcedure() Method** (Lines ~164-169):
   - 5 SqlParameter instances → 5 NpgsqlParameter instances
   - Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

2. **DeleteAuthorEmbeddedSql() Method** (Line ~209):
   - 1 SqlParameter instance → 1 NpgsqlParameter instance
   - Parameter: @BusinessEntityID

3. **SelectAuthorsByHireYear() Method** (Line ~230):
   - 1 SqlParameter instance → 1 NpgsqlParameter instance
   - Parameter: @HireDate

**Total SqlParameter → NpgsqlParameter conversions:** 7

---

#### Stored Procedures Identified (NOT converted - require manual migration):

##### 1. uspUpdateAuthorPersonalInfo
**Location:** EditUsingStoredProcedure() method (Line ~162)
**SQL Statement:**
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] 
     @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
```

**Parameters:**
- @BusinessEntityID (int)
- @NationalIDNumber (string)
- @BirthDate (DateTime)
- @MaritalStatus (string)
- @Gender (string)

**Migration Required:** This stored procedure needs to be converted to a PostgreSQL function. The T-SQL EXEC syntax and DECLARE/SELECT pattern must be replaced with PostgreSQL function call syntax.

**Recommended PostgreSQL Approach:**
```sql
-- Create PostgreSQL function (to be done separately)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.usp_update_author_personal_info(
    p_business_entity_id INT,
    p_national_id_number VARCHAR,
    p_birth_date TIMESTAMP,
    p_marital_status VARCHAR,
    p_gender VARCHAR
) RETURNS INT AS $$
-- Function implementation here
$$ LANGUAGE plpgsql;

-- Call from C# code
SELECT bobsbookstore_dbo.usp_update_author_personal_info(
    @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
);
```

---

##### 2. uspDeleteAuthor
**Location:** DeleteAuthorEmbeddedSql() method (Line ~207)
**SQL Statement:**
```sql
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
```

**Parameters:**
- @BusinessEntityID (int)

**Migration Required:** This stored procedure needs to be converted to a PostgreSQL function. The T-SQL EXEC syntax and DECLARE/SELECT pattern must be replaced with PostgreSQL function call syntax.

**Recommended PostgreSQL Approach:**
```sql
-- Create PostgreSQL function (to be done separately)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.usp_delete_author(
    p_business_entity_id INT
) RETURNS INT AS $$
-- Function implementation here
$$ LANGUAGE plpgsql;

-- Call from C# code
SELECT bobsbookstore_dbo.usp_delete_author(@BusinessEntityID);
```

---

### File 2: ProductsController.cs
**Path:** `/QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs`

#### SQL Queries Transformed: 0
**Note:** This file contains only a stored procedure call, which was not modified per transformation guidelines.

#### Stored Procedures Identified (NOT converted - require manual migration):

##### 1. uspGetProductData
**Location:** FindAllProducts() method (Line ~32)
**SQL Statement:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Parameters:** None

**Migration Required:** This stored procedure needs to be converted to a PostgreSQL function or standard SQL query.

**Recommended PostgreSQL Approach:**
```sql
-- Option 1: Create PostgreSQL function (to be done separately)
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.usp_get_product_data()
RETURNS TABLE (...) AS $$
-- Function implementation here
$$ LANGUAGE plpgsql;

-- Call from C# code
SELECT * FROM bobsbookstore_dbo.usp_get_product_data();

-- Option 2: Replace with direct SQL query if procedure is simple
SELECT * FROM bobsbookstore_dbo.product WHERE ...
```

---

## Schema Mapping Reference

| Source Schema | Source Table | Target Schema | Target Table |
|---------------|--------------|---------------|--------------|
| dbo | Author | bobsbookstore_dbo | author |

---

## Summary Statistics

- **Total Files Processed:** 2
- **Files Modified:** 1 (AuthorsController.cs)
- **Files Unchanged:** 1 (ProductsController.cs - only contains stored procedure call)
- **Table References Qualified:** 2
- **Unique Tables Qualified:** 1 (Author)
- **SqlParameter → NpgsqlParameter Conversions:** 7
- **Stored Procedures Requiring Migration:** 3
  - uspUpdateAuthorPersonalInfo (AuthorsController.cs)
  - uspDeleteAuthor (AuthorsController.cs)
  - uspGetProductData (ProductsController.cs)

---

## Important Notes

### 1. Preserved Elements (Not Modified)

The following elements were intentionally left unchanged per transformation guidelines:

- **Stored Procedure EXEC Statements:** All EXEC/EXECUTE statements were left as-is. These require separate migration to PostgreSQL functions.
- **T-SQL Functions:** FORMAT, DATEDIFF, GETDATE, DATEPART functions were not converted to PostgreSQL equivalents.
- **Parameter Syntax:** @ParameterName syntax was preserved (not converted to $1 positional parameters).
- **DECLARE Statements:** Variable declarations were left unchanged.
- **SQL Logic:** WHERE clauses, column names, aliases, and all other SQL logic remain unchanged.

### 2. Additional Work Required

#### A. Stored Procedure Migration
All three identified stored procedures must be:
1. Reviewed to understand their T-SQL implementation
2. Converted to PostgreSQL functions (PL/pgSQL)
3. Schema-qualified with `bobsbookstore_dbo` schema
4. Called using PostgreSQL function call syntax in C# code

#### B. T-SQL to PostgreSQL Function Conversion
The `SelectAuthorsByHireYear()` method uses T-SQL-specific functions that will fail in PostgreSQL:
- `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → Use `TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')`
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → Use `EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))`
- `GETDATE()` → Use `CURRENT_DATE` or `CURRENT_TIMESTAMP`
- `DATEPART(YEAR, HireDate)` → Use `EXTRACT(YEAR FROM HireDate)`

This query will need a separate T-SQL to PL/pgSQL conversion pass.

#### C. Parameter Type Considerations
While we've updated the C# code to use `NpgsqlParameter`, ensure that:
- DateTime parameters are properly converted to PostgreSQL timestamp format
- The `ToUniversalTime()` call in `EditUsingStoredProcedure()` is appropriate for your timezone requirements

#### D. Return Value Handling
Stored procedures that return output parameters or result sets may need adjustments in how they're called from PostgreSQL.

### 3. Import Statement Verification

Both files already have `using Npgsql;` statements, which is correct. Ensure that:
- The Npgsql NuGet package is installed in the project
- Any references to `Microsoft.Data.SqlClient` or `System.Data.SqlClient` are removed (if they exist elsewhere)

---

## Validation Checklist

✅ All table references in FROM clauses are schema-qualified  
✅ All table references in JOIN clauses are schema-qualified (N/A - no JOINs in raw SQL)  
✅ Table names match target_table from schema mappings (exact case: `author`)  
✅ Schema name matches target_schema (`bobsbookstore_dbo`)  
✅ EXEC/EXECUTE statements left exactly as-is  
✅ T-SQL functions left exactly as-is (will need separate conversion)  
✅ @Parameter syntax left exactly as-is  
✅ DECLARE statements and variable assignments left exactly as-is  
✅ No column names were modified  
✅ SQL query logic and syntax remain unchanged (except table qualification)  
✅ Original formatting and whitespace preserved  
✅ SqlParameter → NpgsqlParameter conversion completed  

---

## Next Steps

1. **Review and Test:** Review the transformed code and test basic queries to ensure schema qualification works correctly.

2. **Migrate Stored Procedures:** Prioritize migration of the three stored procedures:
   - uspUpdateAuthorPersonalInfo (high priority - used in Edit operation)
   - uspDeleteAuthor (high priority - used in Delete operation)
   - uspGetProductData (high priority - used in main Product listing)

3. **T-SQL Function Conversion:** Convert T-SQL-specific functions in `SelectAuthorsByHireYear()` method.

4. **Update Connection Strings:** Ensure application configuration uses PostgreSQL connection strings.

5. **Integration Testing:** Perform comprehensive testing of all affected controller actions.

6. **Error Handling Review:** Review error handling to ensure PostgreSQL-specific exceptions are properly caught.

---

## Contact & Support

If you encounter issues with the transformations or need assistance with stored procedure migration, please review the PostgreSQL migration documentation or consult with your database migration team.

**Transformation Completed Successfully** ✓
