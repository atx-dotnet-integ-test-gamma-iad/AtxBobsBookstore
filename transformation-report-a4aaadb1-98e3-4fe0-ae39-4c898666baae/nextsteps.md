# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, the project likely uses Entity Framework Core or a similar ORM. Verify the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) points to a valid and accessible database.
- If Entity Framework Core is used, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Confirm the following:

- `web.config` transforms or IIS-specific settings have been replaced with equivalent `appsettings.json` entries where applicable.
- Environment-specific configuration (e.g., `appsettings.Production.json`) is in place and contains the correct values for the target environment.
- Any file paths hardcoded in configuration use `Path.Combine` or forward-slash notation to ensure cross-platform compatibility.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues caused by APIs that were available in .NET Framework but behave differently or are absent in cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the following command to identify potential issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:

- `System.Web` references that may have been shimmed during transformation
- Windows-specific registry or file system calls
- Any use of `AppDomain` or remoting APIs

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.