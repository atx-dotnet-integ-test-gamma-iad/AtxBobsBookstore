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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`) across all three projects:

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

Mismatched target frameworks between projects can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any remaining dependencies that may be Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- MSMQ or WCF service references
- `HttpContext` usage patterns from classic ASP.NET

Replace or remove any such dependencies with their cross-platform equivalents.

---

## 5. Review Entity Framework or Data Access Configuration

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The connection string in `appsettings.json` is correctly configured for the target environment.

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` before proceeding to deployment.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without exceptions.
- All pages and routes load correctly.
- Database connectivity is functioning as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Application Logs

After running the application locally, review the console output and any log files for runtime warnings or errors that would not surface during a build. Pay particular attention to:

- Middleware configuration issues
- Missing service registrations in `Program.cs` or `Startup.cs`
- Deprecated API usage warnings at runtime

---

## 9. Publish the Application

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.