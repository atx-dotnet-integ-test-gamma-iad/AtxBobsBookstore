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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references across the three projects. Packages that were designed for .NET Framework may not be fully compatible with cross-platform .NET. Pay particular attention to:

- Any package referencing `System.Web`
- Windows Communication Foundation (WCF) dependencies
- Any ORM or data access libraries that may require updated versions for .NET 6+

Use the following command to list packages and identify potential issues:

```bash
dotnet list package --outdated
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration tests for the `Bookstore.Domain` and `Bookstore.Data` layers to verify core functionality before proceeding.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core provider being used (e.g., SQL Server, SQLite, PostgreSQL) is compatible with the target .NET version.

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that key pages and features load without errors. Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration and Middleware

Open `Program.cs` (and `Startup.cs` if still present) in `Bookstore.Web` and confirm:

- The middleware pipeline is correctly configured for ASP.NET Core.
- Any legacy `HttpModule` or `HttpHandler` registrations from the .NET Framework version have been replaced with the appropriate ASP.NET Core middleware equivalents.
- Static file serving, routing, and authentication middleware are all registered in the correct order.

---

## 9. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, run the application on a Linux or macOS environment to confirm there are no remaining platform-specific dependencies:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or file path issues (e.g., hardcoded backslashes) that surface during this step.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.