-- ========================================
-- Converted SQL Statements Catalog
-- Bob's Bookstore Migration: MS SQL Server to PostgreSQL
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (All statements)
-- DMS Tool Status: All 5 statements failed with metadata model creation error
-- ========================================

-- ========================================
-- STATEMENT 1 - CONVERTED
-- ========================================
-- Source File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~164
-- Original Type: Stored Procedure Execution with DECLARE
-- PostgreSQL Type: Function Call with SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: PostgreSQL uses functions instead of stored procedures with output parameters. The function should be called directly with SELECT.
-- ========================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ========================================
-- STATEMENT 2 - CONVERTED
-- ========================================
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~192
-- Original Type: SELECT Query
-- PostgreSQL Type: SELECT Query
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: Simple SELECT statement already compatible with PostgreSQL. Schema name preserved.
-- ========================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================
-- STATEMENT 3 - CONVERTED
-- ========================================
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~211
-- Original Type: Stored Procedure Execution with DECLARE
-- PostgreSQL Type: Function Call with SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: PostgreSQL uses functions instead of stored procedures with output parameters. The function should be called directly with SELECT.
-- ========================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ========================================
-- STATEMENT 4 - CONVERTED
-- ========================================
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~231
-- Original Type: SELECT Query with SQL Server Functions
-- PostgreSQL Type: SELECT Query with PostgreSQL Functions
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: SQL Server functions converted to PostgreSQL equivalents:
--   FORMAT → TO_CHAR, DATEDIFF → EXTRACT(YEAR FROM AGE(...)), GETDATE() → CURRENT_TIMESTAMP, DATEPART → EXTRACT
-- ========================================
SELECT "businessentityid", TO_CHAR("modifieddate", 'YYYY-MM-DD HH24:MI:SS') AS "formattedmodifieddate", EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, "birthdate")) AS "age" FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM "hiredate") = @HireDate;

-- ========================================
-- STATEMENT 5 - CONVERTED
-- ========================================
-- Source File: ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Original Type: Stored Procedure Execution
-- PostgreSQL Type: Function Call with SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: PostgreSQL uses functions instead of stored procedures. The function should be called with SELECT * FROM.
-- ========================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ========================================
-- End of Converted Statements Catalog
-- ========================================
