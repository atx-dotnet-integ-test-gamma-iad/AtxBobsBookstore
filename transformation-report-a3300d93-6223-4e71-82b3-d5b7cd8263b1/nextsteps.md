# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating correctness and ensuring the application runs as expected on the new cross-platform .NET target.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Repeat this check for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 2. Restore and Build the Solution

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure there are no warnings that could indicate deprecated APIs or packages that may cause runtime issues.

---

## 3. Review NuGet Package Versions

Check that all NuGet dependencies reference versions compatible with your target framework. Pay particular attention to:

- **Entity Framework Core** (if used in `Bookstore.Data`) — ensure it is not referencing the legacy `EntityFramework` (non-Core) package.
- **ASP.NET Core** packages in `Bookstore.Web` — confirm there are no references to `Microsoft.AspNet.*` packages, which are not compatible with cross-platform .NET.

```bash
dotnet list package --outdated
```

Update any outdated or incompatible packages as needed.

---

## 4. Check for Windows-Specific APIs

Search the codebase for APIs that are not supported cross-platform, such as:

- `System.Web` references (not available in .NET Core/.NET 5+)
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` for file path handling to ensure cross-platform compatibility.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly:

```bash
dotnet test
```

Review any failing tests and address regressions introduced during the transformation.

---

## 6. Run the Application Locally

Start the web application and perform manual validation of core functionality:

```bash
dotnet run --project Bookstore.Web/Bookstore.Web.csproj
```

Verify the following areas at a minimum:
- Application starts without runtime exceptions
- Database connectivity works (check connection strings in `appsettings.json`)
- Core pages and routes load correctly
- CRUD operations function as expected

---

## 7. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) are present and correctly configured. Legacy projects may have relied on `Web.config` or `App.config`, which are replaced by `appsettings.json` in modern .NET.

- Connection strings should be moved to `appsettings.json`
- Any environment-specific settings should use the appropriate environment-specific config file

---

## 8. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data/Bookstore.Data.csproj --startup-project Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, generate a new migration and apply it to the database:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data/Bookstore.Data.csproj --startup-project Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project Bookstore.Data/Bookstore.Data.csproj --startup-project Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

Review the contents of the `./publish` output folder to confirm all required files are present before deploying to the target environment.