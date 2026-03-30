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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Entity Framework Core (If Applicable)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Existing migrations are compatible with the new runtime. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be updated, apply them to a development database first:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test core workflows such as browsing, searching, and any data submission forms.
- Check the console output for runtime exceptions or middleware configuration warnings.
- Verify that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Any environment-specific settings (e.g., connection strings, API keys) are handled via environment variables or user secrets for local development:

```bash
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string" --project Bookstore.Web
```

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are unavailable or behave differently in cross-platform .NET, including:

- `System.Web` references (these are not available in modern .NET).
- Windows-specific registry or file path assumptions.
- Any use of `HttpContext` that may require middleware adjustments in ASP.NET Core.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to identify remaining compatibility issues:

```bash
upgrade-assistant analyze Bookstore.sln
```

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.