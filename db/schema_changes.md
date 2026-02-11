# Schema Changes Documentation
## SQL Server to PostgreSQL Migration

**Migration Date:** 2026-02-11  
**Application:** BobsBookstore .NET ADO Application  
**Database:** BobsBookstore

---

## Schema Object Name Changes

### DMS Tool Schema Transformations
The DMS MCP tool encountered service-level errors and was unable to perform automated schema transformations. All schema name conversions were performed manually based on the existing codebase structure.

### Schema Naming Convention
- **SQL Server Original:** `[dbo]` schema
- **PostgreSQL Target:** `bobsbookstore_dbo` schema
- **Rationale:** The application code already references `bobsbookstore_dbo` schema, so this naming convention was maintained throughout the migration

---

## Table Schema Changes

### Author Table
- **SQL Server:** `[dbo].[author]`
- **PostgreSQL:** `bobsbookstore_dbo.author`
- **Status:** No structural changes, schema prefix updated
- **Column Name Changes:** None (all lowercase maintained)

### Product Table (inferred from code)
- **SQL Server:** `[dbo].[product]` (inferred)
- **PostgreSQL:** `bobsbookstore_dbo.product`
- **Status:** Schema prefix updated
- **Column Name Changes:** None

---

## Stored Procedure to Function Conversions

### 1. uspUpdateAuthorPersonalInfo
| Aspect | SQL Server | PostgreSQL |
|--------|-----------|------------|
| **Name** | `[dbo].[uspUpdateAuthorPersonalInfo]` | `bobsbookstore_dbo.uspUpdateAuthorPersonalInfo` |
| **Type** | Stored Procedure | Function |
| **Return Type** | Output Parameter (@rowsAffected) | RETURNS INTEGER |
| **Call Syntax** | `EXEC @var = [dbo].[uspUpdateAuthorPersonalInfo] @params` | `SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(params)` |
| **Parameters** | @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender | p_BusinessEntityID, p_NationalIDNumber, p_BirthDate, p_MaritalStatus, p_Gender |

### 2. uspDeleteAuthor
| Aspect | SQL Server | PostgreSQL |
|--------|-----------|------------|
| **Name** | `[dbo].[uspDeleteAuthor]` | `bobsbookstore_dbo.uspDeleteAuthor` |
| **Type** | Stored Procedure | Function |
| **Return Type** | Output Parameter (@rowsAffected) | RETURNS INTEGER |
| **Call Syntax** | `EXEC @var = [dbo].[uspDeleteAuthor] @BusinessEntityID` | `SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID)` |
| **Parameters** | @BusinessEntityID | p_BusinessEntityID |

### 3. uspGetProductData
| Aspect | SQL Server | PostgreSQL |
|--------|-----------|------------|
| **Name** | `[dbo].[uspGetProductData]` | `bobsbookstore_dbo.uspGetProductData` |
| **Type** | Stored Procedure | Function |
| **Return Type** | Result Set | RETURNS TABLE |
| **Call Syntax** | `EXEC [dbo].[uspGetProductData]` | `SELECT * FROM bobsbookstore_dbo.uspGetProductData()` |
| **Parameters** | None | None |

---

## Parameter Naming Conventions

### SQL Server Convention
- Prefix: `@` (at sign)
- Example: `@BusinessEntityID`, `@NationalIDNumber`

### PostgreSQL Convention
- **In Code:** `@` prefix maintained for ADO.NET compatibility
- **In Functions:** `p_` prefix used (PostgreSQL best practice)
- Example mapping:
  - Code: `@BusinessEntityID`
  - Function parameter: `p_BusinessEntityID`

---

## Data Type Mappings

| SQL Server | PostgreSQL | Notes |
|-----------|-----------|-------|
| `INT` | `INTEGER` | Standard integer type |
| `NVARCHAR(n)` | `VARCHAR(n)` | Unicode support built into PostgreSQL VARCHAR |
| `DATETIME` | `TIMESTAMP` | Full date and time with timezone support |
| `SMALLINT` | `SMALLINT` | No change needed |
| `NUMERIC(p,s)` | `NUMERIC(p,s)` | No change needed |
| `TEXT` | `TEXT` | No change needed |

---

## Indexes, Constraints, and Triggers

### Primary Keys
- **Status:** Maintained from Entity Framework migrations
- **No changes required:** Primary key definitions remain the same

### Foreign Keys
- **Status:** Maintained from Entity Framework migrations
- **No changes required:** Foreign key relationships preserved

### Indexes
- **Status:** Maintained from Entity Framework migrations
- **Action Required:** Review index definitions after schema migration to ensure optimal PostgreSQL performance

### Triggers
- **Status:** No triggers identified in the migrated code
- **Action Required:** If triggers exist in SQL Server database, they must be converted separately

---

## Functions and Expressions

### Date/Time Function Conversions

| SQL Server | PostgreSQL | Usage |
|-----------|-----------|-------|
| `GETDATE()` | `CURRENT_TIMESTAMP` or `CURRENT_DATE` | Current date/time |
| `FORMAT(date, 'yyyy-MM-dd HH:mm:ss')` | `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')` | Date formatting |
| `DATEDIFF(YEAR, date1, date2)` | `DATE_PART('year', AGE(date1, date2))` | Date difference calculation |
| `DATEPART(YEAR, date)` | `EXTRACT(YEAR FROM date)` | Extract date component |

---

## Connection String Changes

### SQL Server Format
```
Server=<server>;Database=BobsBookstore;Integrated Security=true;
```

### PostgreSQL Format
```
Host=<host>;Port=5432;Database=BobsBookstore;Username=<user>;Password=<password>;
```

---

## Migration Checklist

- [x] Schema naming convention updated to bobsbookstore_dbo
- [x] Stored procedures converted to functions
- [x] Function return types updated (INTEGER, TABLE)
- [x] Parameter naming conventions documented
- [x] T-SQL functions replaced with PostgreSQL equivalents
- [x] Data types mapped to PostgreSQL equivalents
- [ ] PostgreSQL functions deployed to database
- [ ] Index performance reviewed
- [ ] Connection strings updated in configuration
- [ ] Database migration scripts executed
- [ ] Integration testing completed

---

## Deployment Steps

1. **Execute Schema Migration**
   - Deploy PostgreSQL schema using Entity Framework migrations
   - Ensure `bobsbookstore_dbo` schema exists

2. **Deploy Functions**
   - Execute `postgresql_stored_procedures.sql`
   - Verify all three functions created successfully

3. **Verify Function Signatures**
   - Test `uspUpdateAuthorPersonalInfo` with sample parameters
   - Test `uspDeleteAuthor` with sample ID
   - Test `uspGetProductData` returns expected result set

4. **Update Application Configuration**
   - Update connection strings to PostgreSQL format
   - Verify ApplicationDbContext uses UseNpgsql

5. **Testing**
   - Unit test all controller methods
   - Integration test database operations
   - Verify transaction handling
   - Performance test complex queries

---

## Rollback Procedures

### If Rollback Required
1. Restore SQL Server connection strings
2. Revert code changes to SQL Server syntax
3. Drop PostgreSQL functions:
   ```sql
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR);
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspDeleteAuthor(INTEGER);
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspGetProductData();
   ```

---

## Notes for DBA

- **Performance Tuning:** Review execution plans for all functions after deployment
- **Permissions:** Adjust function permissions from PUBLIC to specific roles as needed
- **Monitoring:** Add logging to track function execution times
- **Backup:** Ensure regular backups of PostgreSQL database
- **Schema Management:** Consider using Flyway or Liquibase for schema version control

---

**Document Version:** 1.0  
**Last Updated:** 2026-02-11
