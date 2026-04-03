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

The following steps outline how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — These are not available in .NET. If any references remain, they will need to be replaced with ASP.NET Core equivalents.
- **Entity Framework** — If the project uses Entity Framework 6, consider whether migration to Entity Framework Core is needed.
- **Configuration** — `System.Configuration.ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- **Windows-specific APIs** — Any use of the Windows registry, WCF, or Windows-only libraries will not function on non-Windows platforms.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral differences in the new runtime or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas:

- Application startup and routing
- Database connectivity (check connection strings in `appsettings.json`)
- Any authentication or authorization flows
- Data read and write operations through `Bookstore.Data`

---

## 7. Validate Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) are present and correctly configured. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`.

Check that the following are correctly defined:

- Database connection strings
- Logging configuration
- Any application-specific settings previously stored in `Web.config`

---

## 8. Database Migration Check

If the project uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.