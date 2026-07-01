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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm you are referencing `Microsoft.EntityFrameworkCore` rather than the legacy `System.Data.Entity`. Verify that database migrations are still valid by running:
  ```bash
  dotnet ef migrations list
  ```
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project (System.Web), confirm it has been migrated to ASP.NET Core. Check that middleware, routing, authentication, and configuration patterns follow ASP.NET Core conventions.
- **`Bookstore.Domain`**: Confirm that any domain model attributes or validation annotations reference `System.ComponentModel.DataAnnotations` and are compatible with the current framework version.

---

## 5. Run the Application Locally

Start the web application locally to perform a basic smoke test.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database connectivity functions as expected (if applicable).

---

## 6. Verify Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json`) contain the correct configuration values. Legacy projects may have relied on `Web.config` or `App.config`, which are not used in the same way in modern .NET.

- Connection strings should be present under the `"ConnectionStrings"` section.
- Any environment-specific settings should be placed in the appropriate `appsettings.{Environment}.json` file.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access and web layer behavior, as these areas are most likely to be affected by the migration.

---

## 8. Manual Functional Testing

Perform manual testing of the core application workflows, such as:

- Browsing and searching for books.
- Adding, editing, and deleting records (if applicable).
- User authentication and authorization flows (if applicable).

This validates runtime behavior that automated tests may not fully cover.

---

## 9. Review Runtime Warnings and Logs

Run the application and monitor the console output and any configured log sinks for runtime warnings. Common post-migration issues include:

- Obsolete middleware or service registrations.
- Missing or misconfigured dependency injection registrations.
- Deprecated configuration patterns.

Address any warnings that could indicate instability or future breaking changes.