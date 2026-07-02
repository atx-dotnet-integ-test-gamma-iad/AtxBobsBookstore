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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime compatibility issues.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify that any Entity Framework usage has been migrated from EF 6 to EF Core. Check that database providers (e.g., SQL Server, SQLite) are correctly configured in `DbContext` and `Program.cs` or `Startup.cs`.
- **`Bookstore.Web`**: Confirm that any ASP.NET Web Forms or MVC-specific code has been replaced with ASP.NET Core equivalents. Features such as `HttpContext`, authentication middleware, and session handling have different APIs in ASP.NET Core.
- **`Bookstore.Domain`**: Ensure no domain logic relies on .NET Framework-specific types such as those from `System.Web`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality.

```bash
dotnet test
```

If no test project exists, consider manually verifying critical paths such as data access, domain logic, and web routing.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify the following:

- Pages load without errors.
- Database connections are established (check connection strings in `appsettings.json`).
- Any authentication or authorization flows work as expected.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` contains all necessary configuration that was previously stored in `Web.config` or `App.config`. Common items to check include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Check Runtime Warnings in Logs

When running the application, review the console output and application logs for any runtime warnings. These may indicate deprecated API usage or misconfigured middleware that did not surface as build errors.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, including static assets and configuration files.