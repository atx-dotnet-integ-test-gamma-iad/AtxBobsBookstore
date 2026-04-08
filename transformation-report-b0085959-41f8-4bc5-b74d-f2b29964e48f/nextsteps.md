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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- `System.Drawing` — replaced by cross-platform alternatives such as `SkiaSharp` or `ImageSharp`
- `Microsoft.Win32` registry access
- Windows-specific authentication or IIS-specific middleware in `Bookstore.Web`

Run the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The database provider package is compatible with the target framework (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider)
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains test projects, run all tests to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by behavioral differences between .NET Framework and modern .NET.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- Application starts without runtime exceptions
- Database connectivity is functional
- Core application workflows (browsing, searching, purchasing books) behave as expected
- Static assets, routing, and middleware are functioning correctly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that may have previously been stored in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

If a `Web.config` file still exists in `Bookstore.Web`, verify that only IIS-specific settings remain in it and that all application configuration has been moved to `appsettings.json`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.