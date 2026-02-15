-- ============================================================================
-- EXTRACTED SQL STATEMENTS FOR MIGRATION FROM SQL SERVER TO POSTGRESQL
-- ============================================================================
-- This file contains all SQL statements extracted from the codebase
-- Each statement is documented with:
--   - Source file and location
--   - Statement type (inline query, stored procedure, etc.)
--   - SQL Server specific functions/syntax used
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info Stored Procedure Call
-- ----------------------------------------------------------------------------
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure (line ~157)
-- Type: Stored Procedure Execution with T-SQL DECLARE/EXEC pattern
-- SQL Server Features: DECLARE, EXEC with return value, stored procedure call
-- Schema: [dbo].[uspUpdateAuthorPersonalInfo]
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Delete Author Stored Procedure Call
-- ----------------------------------------------------------------------------
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql (line ~193)
-- Type: Stored Procedure Execution with T-SQL DECLARE/EXEC pattern
-- SQL Server Features: DECLARE, EXEC with return value, stored procedure call
-- Schema: [dbo].[uspDeleteAuthor]
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Select All Authors
-- ----------------------------------------------------------------------------
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql (line ~178)
-- Type: Inline SELECT query
-- SQL Server Features: Schema-qualified table name
-- Schema: bobsbookstore_dbo.author
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ----------------------------------------------------------------------------
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear (line ~208)
-- Type: Inline SELECT query with SQL Server date functions
-- SQL Server Features: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Schema: bobsbookstore_dbo.author
-- Critical: Multiple SQL Server specific date/time functions requiring conversion
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STORED PROCEDURE DEFINITIONS FROM DATABASE SCRIPTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STORED PROCEDURE 1: uspUpdateAuthorPersonalInfo
-- ----------------------------------------------------------------------------
-- Source: db/adven.sql (lines 932-954)
-- Type: Stored Procedure Definition
-- SQL Server Features: CREATE PROCEDURE, WITH EXECUTE AS CALLER, SET NOCOUNT ON
--                      BEGIN TRY/CATCH, @@ROWCOUNT, EXECUTE for error logging
-- Purpose: Updates author personal information
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [dbo].[Author] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;

-- ----------------------------------------------------------------------------
-- STORED PROCEDURE 2: uspDeleteAuthor
-- ----------------------------------------------------------------------------
-- Source: db/adven.sql (lines 957-979)
-- Type: Stored Procedure Definition
-- SQL Server Features: CREATE PROCEDURE, WITH EXECUTE AS CALLER, SET NOCOUNT ON
--                      BEGIN TRY/CATCH, @@ROWCOUNT, RAISERROR, THROW, EXECUTE
-- Purpose: Deletes an author by BusinessEntityID
-- Parameters: @BusinessEntityID
-- Critical: Uses @@ROWCOUNT, RAISERROR, THROW - all need PostgreSQL equivalents
-- ----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspDeleteAuthor]
    @BusinessEntityID [int]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM [dbo].[Author]
        WHERE [BusinessEntityID] = @BusinessEntityID;

        -- Check if the delete was successful
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No author found with the provided BusinessEntityID.', 16, 1);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Log the error and re-throw
        EXECUTE [dbo].[uspLogError];
        THROW;
    END CATCH;
END;

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 6
--   - Inline Queries: 2
--   - Stored Procedure Calls: 2
--   - Stored Procedure Definitions: 2
--
-- SQL Server Features Requiring Conversion:
--   - DECLARE @variable pattern
--   - EXEC with return value assignment
--   - FORMAT() function
--   - DATEDIFF() function
--   - DATEPART() function
--   - GETDATE() function
--   - [schema].[object] bracket notation
--   - CREATE PROCEDURE syntax
--   - WITH EXECUTE AS CALLER
--   - SET NOCOUNT ON
--   - BEGIN TRY/CATCH/END
--   - @@ROWCOUNT
--   - RAISERROR
--   - THROW
--   - EXECUTE procedure calls
-- ============================================================================
