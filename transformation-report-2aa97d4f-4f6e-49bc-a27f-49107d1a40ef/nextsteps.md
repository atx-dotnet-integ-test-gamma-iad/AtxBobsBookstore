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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages still target `net4x` or older frameworks, consider updating them to their latest versions that support the current target framework (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with **0 Error(s)**. Warnings should be reviewed, particularly any that relate to obsolete APIs or nullable reference types, as these may indicate areas that need attention.

---

## 3. Review Target Framework Consistency

Open each `.csproj` file and confirm that all three projects are targeting the same framework version. Mismatched target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

Example of a consistent target framework entry:

```xml
<TargetFramework>net8.0</TargetFramework>
```

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the following:

- If using **Entity Framework Core**, verify that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations or verify the database schema is still compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project was previously using **Entity Framework 6 (EF6)**, confirm it has been migrated to **EF Core**, as EF6 is not fully supported on cross-platform .NET.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project (not listed but potentially present), execute the tests:

```bash
dotnet test
```

If no test project exists, consider manually verifying the following key areas:

- Domain model integrity (`Bookstore.Domain`)
- Database read/write operations (`Bookstore.Data`)
- Web application routing, controllers, and views (`Bookstore.Web`)

---

## 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without exceptions in the console output.
- All pages load correctly, including any data-driven pages that rely on `Bookstore.Data`.
- Static assets (CSS, JavaScript, images) are served correctly. In cross-platform .NET web projects, static files should reside in the `wwwroot` folder.

---

## 7. Check for Windows-Specific APIs

Even with a successful build, runtime failures can occur if the code references Windows-specific APIs (e.g., the registry, `System.Drawing`, or Windows Identity). Search the codebase for any such usages:

```bash
grep -rn "System.Drawing" .
grep -rn "Microsoft.Win32" .
grep -rn "Registry" .
```

Replace or remove any Windows-specific dependencies with cross-platform alternatives where applicable.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Key areas to check include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 9. Validate on Target Operating System

If the goal is cross-platform support, run the application on the intended non-Windows operating system (Linux or macOS) to catch any platform-specific runtime issues that would not surface on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target system and verify expected behavior.