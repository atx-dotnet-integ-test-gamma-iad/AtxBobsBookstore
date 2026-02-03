/*******************************************************************************
 * EXTRACTED SQL STATEMENTS CATALOG
 * SQL Server to PostgreSQL Migration
 * Date: 2026-02-03
 * 
 * This file contains all SQL statements extracted from the codebase for
 * conversion to PostgreSQL syntax using the DMS MCP tool.
 ******************************************************************************/

/*******************************************************************************
 * STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: EditUsingStoredProcedure()
 * Line: ~167
 * Type: Stored Procedure Call with DECLARE and EXEC
 * Description: Updates author personal information using a stored procedure
 ******************************************************************************/
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- @NationalIDNumber (string)
-- @BirthDate (DateTime)
-- @MaritalStatus (string)
-- @Gender (string)

/*******************************************************************************
 * STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: FindAllAuthorsEmbeddedSql()
 * Line: ~184
 * Type: Simple SELECT statement
 * Description: Retrieves all authors from the database
 ******************************************************************************/
-- Original SQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Parameters: None

/*******************************************************************************
 * STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: DeleteAuthorEmbeddedSql()
 * Line: ~203
 * Type: Stored Procedure Call with DECLARE and EXEC
 * Description: Deletes an author using a stored procedure
 ******************************************************************************/
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)

/*******************************************************************************
 * STATEMENT 4: SelectAuthorsByHireYear - Select Authors with Age Calculation
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: SelectAuthorsByHireYear()
 * Line: ~222
 * Type: Complex SELECT with SQL Server-specific date functions
 * Description: Selects authors by hire year with formatted date and age calculation
 * SQL Server Functions: FORMAT, DATEDIFF, GETDATE, DATEPART
 ******************************************************************************/
-- Original SQL Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int) - Year value

/*******************************************************************************
 * STATEMENT 5: ProductsController - Get Product Data (ADDITIONAL - NOT IN PLAN SCOPE)
 * Location: app/Bookstore.Web/Controllers/ProductsController.cs
 * Method: FindAllProducts()
 * Line: ~32
 * Type: Stored Procedure Call with EXEC
 * Description: Retrieves product data using a stored procedure
 * Note: This statement was discovered during codebase scan but is not included
 *       in the transformation plan scope which focuses on AuthorsController only.
 *       According to plan, only statements 1-4 from AuthorsController will be
 *       converted. This statement is documented for completeness but will not
 *       be processed through DMS tool or equivalency validation.
 ******************************************************************************/
-- Original SQL Statement:
EXEC [dbo].[uspGetProductData];

-- Parameters: None

/*******************************************************************************
 * SUMMARY
 * Total SQL Statements Extracted: 5 (1 outside plan scope)
 * Statements in Transformation Plan Scope: 4 (Statements 1-4 from AuthorsController)
 * - Stored Procedure Calls: 2 (Statements 1, 3)
 * - Simple SELECT: 1 (Statement 2)
 * - Complex SELECT with Date Functions: 1 (Statement 4)
 * 
 * Additional Statement Found (not in plan): 1 (Statement 5 from ProductsController)
 * 
 * SQL Server Specific Features Requiring Conversion (in scope):
 * - DECLARE variable syntax
 * - EXEC stored procedure syntax with return value capture
 * - [dbo].[procedureName] schema qualification
 * - FORMAT() function
 * - DATEDIFF() function
 * - GETDATE() function
 * - DATEPART() function
 *
 * PLAN ALIGNMENT:
 * The transformation plan explicitly lists 4 SQL statements from AuthorsController:
 * 1. EditUsingStoredProcedure - Stored procedure call with DECLARE and EXEC
 * 2. FindAllAuthorsEmbeddedSql - SELECT statement
 * 3. DeleteAuthorEmbeddedSql - Stored procedure call
 * 4. SelectAuthorsByHireYear - SELECT with date functions
 * 
 * These 4 statements will be processed through DMS conversion (Step 2) and
 * equivalency validation (Step 3) as specified in the plan.
 ******************************************************************************/
