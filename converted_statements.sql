-- ============================================================
-- Converted PostgreSQL Statements (via DMS MCP Tool)
-- Source: BobsBookstore Application
-- ============================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Converted by DMS MCP Tool - SUCCESS
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Converted by DMS MCP Tool - SUCCESS
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Converted by DMS MCP Tool - SUCCESS
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Converted by DMS MCP Tool - SUCCESS
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(20)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Converted by DMS MCP Tool - SUCCESS
-- DMS output: CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
-- Used in code as: SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();
-- Note: The DMS converted the EXEC to a CALL with cursor parameter. The existing code uses
-- SELECT * FROM function() pattern which is the correct PostgreSQL way to query table-returning functions.
SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();
