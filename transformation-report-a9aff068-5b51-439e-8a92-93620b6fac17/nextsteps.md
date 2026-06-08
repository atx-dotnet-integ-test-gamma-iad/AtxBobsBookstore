# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or any `netstandard` targets unless there is a specific compatibility reason.

---

## 4. Check for Windows-Specific Dependencies

Run the .NET Compatibility Analyzer or inspect the code manually for any APIs that are Windows-only. Common areas to check in a Bookstore-style application include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore`)
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- `System.Drawing` (use `System.Drawing.Common` with caution, or replace with a cross-platform alternative)

You can use the following command to check for platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
cd Bookstore.Web
dotnet run
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Browsing the bookstore catalog
- Any data retrieval from `Bookstore.Data`
- Domain logic behavior from `Bookstore.Domain`

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is correct for your environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If migrating from Entity Framework 6 (non-Core), verify that all `DbContext` configurations, relationships, and queries have been updated to EF Core conventions.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering:

- Domain model validation (`Bookstore.Domain`)
- Repository or data access logic (`Bookstore.Data`)
- Controller actions or middleware behavior (`Bookstore.Web`)

If no test projects exist, consider adding unit tests for critical paths before deploying.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.