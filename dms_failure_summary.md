# DMS Failure Summary

## Overview
This document records any SQL statements where the DMS MCP tool failed and manual conversion was required.

## AuthorsController.cs Statements (Step 1)
All 4 statements in AuthorsController.cs were **successfully converted** by the DMS MCP tool.
No manual conversion was required.

| # | Statement | DMS Status |
|---|-----------|------------|
| 1 | EXEC [dbo].[uspUpdateAuthorPersonalInfo] ... | SUCCESS |
| 2 | SELECT * FROM [dbo].[Author] | SUCCESS |
| 3 | EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID | SUCCESS |
| 4 | SELECT BusinessEntityID, CONVERT(...) FROM [dbo].[Author] ... | SUCCESS |

## Notes
- Initial DMS calls without `database_name` parameter failed with "Metadata model creation failed: No objects were found according to the specified selection rules."
- After specifying `database_name=BobsUsedBookStore`, all conversions succeeded.
- SQL Equivalency tool returned ERROR for all statements with error "'uniqueID'" - this is a tool-level issue, not a conversion issue.

## ProductsController.cs Statements (Step 2)
The 1 statement in ProductsController.cs was **successfully converted** by the DMS MCP tool.

| # | Statement | DMS Status | Notes |
|---|-----------|------------|-------|
| 5 | EXEC [dbo].[uspGetProductData] | SUCCESS | DMS output: CALL with cursor parameter. Code uses SELECT * FROM function() pattern which is correct PostgreSQL. |
