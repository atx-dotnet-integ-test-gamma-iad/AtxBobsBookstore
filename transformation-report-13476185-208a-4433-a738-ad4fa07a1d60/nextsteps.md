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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net5.0` or `net6.0`, consider updating to `net8.0` as those versions are no longer receiving security updates.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-specific APIs are being used unintentionally. Search the codebase for any of the following:

- `System.Web` references (not supported on .NET Core/5+)
- `Microsoft.Win32` registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- Any P/Invoke calls targeting Windows-only DLLs

If `System.Web` types were previously used in `Bookstore.Web`, confirm they have been replaced with their ASP.NET Core equivalents.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify it has been migrated to **Entity Framework Core**.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project uses a connection string, confirm it is stored in `appsettings.json` and not in a legacy `Web.config` or `App.config` file.

---

## 6. Validate the Domain Layer

In `Bookstore.Domain`, confirm the following:

- All models and business logic compile without warnings.
- Any serialization attributes (e.g., from `Newtonsoft.Json` or `System.Text.Json`) are compatible with the new framework version.

---

## 7. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- The `Program.cs` and `Startup.cs` (if present) follow the ASP.NET Core conventions.
- In .NET 6 and later, the minimal hosting model merges these into a single `Program.cs`. Ensure the application startup is structured correctly.
- Static files, routing, and middleware are configured using ASP.NET Core APIs.
- Authentication and authorization, if used, have been migrated away from legacy `FormsAuthentication` or similar mechanisms.

---

## 8. Run the Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the locally hosted URL and manually test the core features of the bookstore, such as browsing, searching, and any data entry workflows.

---

## 9. Run Automated Tests

If a test project exists in the solution, execute all tests:

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by behavioral changes introduced during migration or pre-existing issues.

---

## 10. Review Configuration Files

Confirm that `Web.config` or `App.config` files from the legacy project have been replaced or supplemented by:

- `appsettings.json` for application settings
- `appsettings.Development.json` for environment-specific overrides
- Environment variables where appropriate

Legacy config transformation files (e.g., `Web.Release.config`) are not used in .NET Core and later and can be removed.