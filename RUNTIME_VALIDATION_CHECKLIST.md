# Runtime Validation Checklist
## Bob's Bookstore - PostgreSQL Migration Validation

**Purpose:** Systematic validation checklist for runtime testing after PostgreSQL migration  
**Date:** December 18, 2025  
**Migration Phase:** Post-Migration Runtime Validation

---

## Overview

This checklist is designed to systematically validate the 3 unmet exit criteria that require runtime environment:

1. **Exit Criterion #12:** Application successfully connects to PostgreSQL database
2. **Exit Criterion #13:** All database operations execute successfully against PostgreSQL
3. **Exit Criterion #15:** Application passes all existing unit tests and integration tests

---

## Pre-Validation Requirements

### Environment Setup
- [ ] PostgreSQL database instance is running
- [ ] Schema `bobsbookstore_dbo` exists
- [ ] Tables `author` and `product` exist with correct structure
- [ ] PostgreSQL functions deployed (uspupdateauthorpersonalinfo, uspdeleteauthor)
- [ ] .NET 8.0 SDK installed
- [ ] Application source code available
- [ ] AWS Secrets Manager connection string configured

### Database Schema Verification
```sql
-- Run these queries to verify environment is ready
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'bobsbookstore_dbo';
SELECT table_name FROM information_schema.tables WHERE table_schema = 'bobsbookstore_dbo' ORDER BY table_name;
SELECT proname FROM pg_proc WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'bobsbookstore_dbo');
```

Expected Results:
- [ ] Schema: bobsbookstore_dbo exists
- [ ] Tables: author, product exist
- [ ] Functions: uspupdateauthorpersonalinfo, uspdeleteauthor exist

---

## Exit Criterion #12: Database Connectivity

### Test 12.1: Basic Connection Test
**Objective:** Verify application can establish connection to PostgreSQL

**Steps:**
1. Start the application:
   ```bash
   cd app/Bookstore.Web
   dotnet run --urls "http://localhost:5000"
   ```
2. Monitor application logs for connection success
3. Check for any connection errors

**Expected Result:**
- [ ] Application starts without errors
- [ ] No connection errors in logs
- [ ] Application ready to serve requests

**Actual Result:**
```
[Record actual result here]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 12.2: Connection String Validation
**Objective:** Verify connection string is correctly configured

**Steps:**
1. Retrieve connection string from AWS Secrets Manager:
   ```bash
   aws secretsmanager get-secret-value \
     --secret-id arn:aws:secretsmanager:us-east-1:812756961751:secret:atx-db-modernization-test-DBConnector-setup-bobsBookStoreDB-source-target-FU71Bm \
     --region us-east-1
   ```
2. Verify format matches PostgreSQL requirements
3. Test connection using psql

**Expected Result:**
- [ ] Connection string in correct PostgreSQL format
- [ ] No SQL Server parameters present
- [ ] Manual psql connection succeeds

**Actual Result:**
```
[Record connection string format and test results]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 12.3: Connection Pool Validation
**Objective:** Verify connection pooling works correctly

**Steps:**
1. Make multiple concurrent requests to the application
2. Monitor database connections
3. Verify connections are pooled and released properly

**Expected Result:**
- [ ] Multiple requests handled successfully
- [ ] Connection pool manages connections efficiently
- [ ] No connection leaks observed

**Actual Result:**
```
[Record connection pool behavior]
```

**Status:** [ ] PASS [ ] FAIL

---

## Exit Criterion #13: Database Operations Validation

### Test 13.1: Statement #2 - Find All Authors (BASELINE)
**Objective:** Validate the ONLY statement that was formally verified as EQUIVALENT

**SQL:** `SELECT * FROM bobsbookstore_dbo.author`  
**Status:** EQUIVALENT (formally verified)  
**Priority:** CRITICAL (Baseline validation)

**Steps:**
1. Navigate to authors list endpoint or page
2. Verify all authors are displayed
3. Count total authors returned
4. Verify all columns are present

**Expected Result:**
- [ ] Query executes without errors
- [ ] All authors returned successfully
- [ ] All columns present in results
- [ ] No data corruption

**Actual Result:**
```
Total Authors: [count]
Columns: [list columns]
Errors: [any errors]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 13.2: Statement #1 - Update Author (HIGH PRIORITY)
**Objective:** Validate uspupdateauthorpersonalinfo function

**SQL:** `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5)`  
**Status:** ERROR (UNKNOWN equivalency)  
**Priority:** HIGH

**Test Case 1: Valid Update**
**Steps:**
1. Select an existing author (record BusinessEntityID)
2. Update personal information:
   ```
   BusinessEntityID: [record value]
   NationalIDNumber: TEST12345
   BirthDate: 1985-06-15
   MaritalStatus: M
   Gender: M
   ```
3. Submit update
4. Verify function returns 1
5. Verify author data updated in database

**Expected Result:**
- [ ] Update executes without errors
- [ ] Function returns 1 (one row affected)
- [ ] Author data updated correctly
- [ ] ModifiedDate updated to current timestamp

**Actual Result:**
```
BusinessEntityID used: [value]
Function return value: [value]
Update successful: [yes/no]
Errors: [any errors]
```

**Status:** [ ] PASS [ ] FAIL

**Test Case 2: Non-Existent Author**
**Steps:**
1. Attempt to update non-existent BusinessEntityID (e.g., 999999)
2. Verify function returns 0

**Expected Result:**
- [ ] Function executes without errors
- [ ] Function returns 0 (no rows affected)
- [ ] No exception raised

**Actual Result:**
```
Function return value: [value]
Behavior: [description]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 13.3: Statement #3 - Delete Author (HIGH PRIORITY)
**Objective:** Validate uspdeleteauthor function

**SQL:** `SELECT bobsbookstore_dbo.uspdeleteauthor($1)`  
**Status:** ERROR (UNKNOWN equivalency)  
**Priority:** HIGH

**Test Case 1: Valid Delete**
**Steps:**
1. Insert test author:
   ```sql
   INSERT INTO bobsbookstore_dbo.author 
   (businessentityid, nationalidnumber, birthdate, maritalstatus, gender, hiredate, modifieddate)
   VALUES (99999, '999999999', '1990-01-01', 'S', 'M', '2020-01-01', CURRENT_TIMESTAMP);
   ```
2. Delete using function
3. Verify function returns 1
4. Verify author no longer exists

**Expected Result:**
- [ ] Delete executes without errors
- [ ] Function returns 1 (one row affected)
- [ ] Author removed from database

**Actual Result:**
```
Function return value: [value]
Author exists after delete: [yes/no]
Errors: [any errors]
```

**Status:** [ ] PASS [ ] FAIL

**Test Case 2: Delete Non-Existent Author**
**Steps:**
1. Attempt to delete BusinessEntityID 99999 again (already deleted)
2. Verify exception is raised

**Expected Result:**
- [ ] Exception raised with message: "No author found with the provided BusinessEntityID: 99999"
- [ ] Application handles exception gracefully

**Actual Result:**
```
Exception raised: [yes/no]
Exception message: [message]
Error handling: [description]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 13.4: Statement #4 - Select Authors By Hire Year (MEDIUM PRIORITY)
**Objective:** Validate T-SQL function conversions

**SQL:** Complex query with TO_CHAR, DATE_PART, AGE, CURRENT_DATE  
**Status:** ERROR (UNKNOWN equivalency)  
**Priority:** MEDIUM

**Test Case 1: Date Format Validation**
**Steps:**
1. Execute query for a specific hire year (e.g., 2020)
2. Compare formatted date output
3. Verify format matches: YYYY-MM-DD HH24:MI:SS

**Expected Result:**
- [ ] Query executes without errors
- [ ] Date format matches expected pattern
- [ ] Time component formatted correctly (24-hour format)

**Actual Result:**
```
Sample formatted date: [example output]
Format matches expected: [yes/no]
Errors: [any errors]
```

**Status:** [ ] PASS [ ] FAIL

**Test Case 2: Age Calculation Validation**
**Steps:**
1. Select authors with known birthdates
2. Manually calculate expected ages
3. Compare with query results

**Expected Result:**
- [ ] Age calculation correct for all authors
- [ ] Edge cases handled (birthdays this year, leap years)

**Actual Result:**
```
Sample age calculations:
Author 1: BirthDate=[date], Expected Age=[value], Actual Age=[value]
Author 2: BirthDate=[date], Expected Age=[value], Actual Age=[value]
Calculation accurate: [yes/no]
```

**Status:** [ ] PASS [ ] FAIL

**Test Case 3: Hire Year Filter Validation**
**Steps:**
1. Query for hire year 2020
2. Verify all returned authors hired in 2020
3. Verify no authors from other years included

**Expected Result:**
- [ ] All returned authors hired in specified year
- [ ] No false positives or false negatives
- [ ] Filter works correctly

**Actual Result:**
```
Authors returned: [count]
All hired in 2020: [yes/no]
Filter accuracy: [description]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 13.5: Statement #5 - Get Product Data (MEDIUM PRIORITY)
**Objective:** Validate cursor to SELECT conversion

**SQL:** `SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product`  
**Status:** ERROR (UNKNOWN equivalency)  
**Priority:** MEDIUM

**Test Case 1: Column Validation**
**Steps:**
1. Execute the query
2. Verify exactly 4 columns returned
3. Verify column names and order

**Expected Result:**
- [ ] Exactly 4 columns returned
- [ ] Column order: productid, name, productnumber, safetystocklevel
- [ ] Column names lowercase
- [ ] No extra columns

**Actual Result:**
```
Columns returned: [list columns in order]
Column count: [count]
Matches expected: [yes/no]
```

**Status:** [ ] PASS [ ] FAIL

**Test Case 2: Data Completeness**
**Steps:**
1. Count total products in database directly
2. Count products returned by query
3. Compare counts

**Expected Result:**
- [ ] Row counts match
- [ ] No data loss from cursor conversion
- [ ] All products returned

**Actual Result:**
```
Database count: [value]
Query result count: [value]
Counts match: [yes/no]
```

**Status:** [ ] PASS [ ] FAIL

---

## Exit Criterion #15: Test Suite Validation

### Test 15.1: Unit Tests
**Objective:** Run all unit tests

**Steps:**
1. Execute unit tests:
   ```bash
   dotnet test BobsBookstore.sln -c Release --filter "Category=Unit"
   ```
2. Review results

**Expected Result:**
- [ ] All unit tests pass
- [ ] No new failures introduced
- [ ] Test execution completes successfully

**Actual Result:**
```
Total Tests: [count]
Passed: [count]
Failed: [count]
Skipped: [count]

Failed Tests (if any):
[List failed tests with reasons]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 15.2: Integration Tests
**Objective:** Run all integration tests

**Steps:**
1. Execute integration tests:
   ```bash
   dotnet test BobsBookstore.sln -c Release --filter "Category=Integration"
   ```
2. Review results

**Expected Result:**
- [ ] All integration tests pass
- [ ] Database operations work correctly
- [ ] No migration-related failures

**Actual Result:**
```
Total Tests: [count]
Passed: [count]
Failed: [count]
Skipped: [count]

Failed Tests (if any):
[List failed tests with reasons]
```

**Status:** [ ] PASS [ ] FAIL

---

### Test 15.3: Full Test Suite
**Objective:** Run complete test suite

**Steps:**
1. Execute all tests:
   ```bash
   dotnet test BobsBookstore.sln -c Release --logger "console;verbosity=detailed"
   ```
2. Generate coverage report if available
3. Review all results

**Expected Result:**
- [ ] All tests pass (100% pass rate)
- [ ] No regressions from migration
- [ ] Test coverage maintained

**Actual Result:**
```
Total Tests: [count]
Passed: [count]
Failed: [count]
Skipped: [count]
Success Rate: [percentage]

Test Summary:
[Detailed summary]
```

**Status:** [ ] PASS [ ] FAIL

---

## Comprehensive Validation Summary

### Exit Criteria Status

**Exit Criterion #12: Database Connectivity**
- [ ] Test 12.1: PASS
- [ ] Test 12.2: PASS
- [ ] Test 12.3: PASS
- **Overall Status:** [ ] PASS [ ] FAIL

**Exit Criterion #13: Database Operations**
- [ ] Test 13.1 (Statement #2): PASS
- [ ] Test 13.2 (Statement #1): PASS
- [ ] Test 13.3 (Statement #3): PASS
- [ ] Test 13.4 (Statement #4): PASS
- [ ] Test 13.5 (Statement #5): PASS
- **Overall Status:** [ ] PASS [ ] FAIL

**Exit Criterion #15: Test Suite**
- [ ] Test 15.1 (Unit Tests): PASS
- [ ] Test 15.2 (Integration Tests): PASS
- [ ] Test 15.3 (Full Suite): PASS
- **Overall Status:** [ ] PASS [ ] FAIL

---

## Final Validation Result

**Total Exit Criteria:** 16  
**Previously Passed:** 11  
**Not Applicable:** 2  
**Validated in This Session:**
- Criterion #12: [ ] PASS [ ] FAIL
- Criterion #13: [ ] PASS [ ] FAIL
- Criterion #15: [ ] PASS [ ] FAIL

**Final Status:** [ ] ALL CRITERIA MET [ ] CRITERIA NOT MET

---

## Issues and Remediation

### Issues Encountered

**Issue 1:**
```
Description: [describe issue]
Test: [test number]
Severity: [Critical/High/Medium/Low]
Status: [Open/Resolved]
Resolution: [describe resolution if resolved]
```

**Issue 2:**
```
Description: [describe issue]
Test: [test number]
Severity: [Critical/High/Medium/Low]
Status: [Open/Resolved]
Resolution: [describe resolution if resolved]
```

### Remediation Actions Required

1. [ ] Action 1: [description]
2. [ ] Action 2: [description]
3. [ ] Action 3: [description]

---

## Performance Observations

### Query Performance

**Statement #2 (Find All Authors):**
- Execution Time: [ms]
- Rows Returned: [count]
- Performance: [acceptable/needs optimization]

**Statement #1 (Update Author):**
- Execution Time: [ms]
- Performance: [acceptable/needs optimization]

**Statement #3 (Delete Author):**
- Execution Time: [ms]
- Performance: [acceptable/needs optimization]

**Statement #4 (Select By Hire Year):**
- Execution Time: [ms]
- Rows Returned: [count]
- Performance: [acceptable/needs optimization]

**Statement #5 (Get Products):**
- Execution Time: [ms]
- Rows Returned: [count]
- Performance: [acceptable/needs optimization]

### Performance Summary
- [ ] All queries perform within acceptable range
- [ ] No performance degradation >20% from SQL Server baseline
- [ ] Performance optimization needed: [yes/no]

---

## Sign-Off

**Validation Completed By:** ___________________________  
**Date:** ___________________________  
**Role:** ___________________________

**Approval (if applicable):**
- Database Administrator: ___________________________ Date: ___________
- QA Lead: ___________________________ Date: ___________
- Application Owner: ___________________________ Date: ___________

---

**Document Version:** 1.0  
**Last Updated:** December 18, 2025  
**Status:** Ready for Runtime Validation
