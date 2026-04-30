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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they reflect a regression introduced during the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and updated for the new environment.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you were previously using Entity Framework 6 (EF6), confirm the migration to EF Core was handled correctly, as there are API differences that may not surface as build errors but can cause runtime failures.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows, such as browsing, searching, and any data submission forms, to confirm runtime behavior is correct.

---

## 6. Review Configuration Files

Check the following configuration-related items:

- Ensure `appsettings.json` and `appsettings.Development.json` contain all required settings that may have previously existed in `Web.config` or `App.config`.
- Confirm that any settings previously stored in `system.web` or `appSettings` sections of a `Web.config` have been correctly moved to the `appsettings.json` structure.
- Verify that environment-specific configuration (e.g., connection strings, API keys) is handled using the appropriate .NET configuration providers.

---

## 7. Check for Runtime-Only Issues

Some issues from legacy .NET Framework projects do not surface as build errors but can cause runtime failures. Pay particular attention to:

- **Reflection-based code**: Behavior may differ under modern .NET.
- **`HttpContext` usage**: The API surface has changed in ASP.NET Core. Ensure no legacy `System.Web.HttpContext` references remain.
- **Global.asax logic**: Any application startup logic previously in `Global.asax` should have been moved to `Program.cs` or `Startup.cs`. Confirm this was handled.
- **Static file handling and routing**: Verify that routes resolve correctly and static assets are served as expected.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.