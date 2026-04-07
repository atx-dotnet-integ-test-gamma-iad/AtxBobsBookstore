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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespace usage
- Windows registry access
- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if needed.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the `Bookstore.Domain` layer, as it is the most independent and foundational part of the solution.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 7. Run the Web Application Locally

Start the web application to verify it runs correctly on the new runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify key pages and functionality, including any data-driven views that depend on `Bookstore.Data` and `Bookstore.Domain`.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

Confirm that the ASP.NET Core middleware pipeline in `Program.cs` (or `Startup.cs`) is correctly configured. Key areas to check:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Environment-specific configuration loading (`appsettings.Development.json`, etc.)

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.