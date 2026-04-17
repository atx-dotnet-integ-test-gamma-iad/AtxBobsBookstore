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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements targeting .NET.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, app settings, etc.) that were previously in `Web.config`.
- Environment-specific configuration files such as `appsettings.Development.json` and `appsettings.Production.json` are present and correctly structured.
- Any configuration previously handled by `System.Configuration.ConfigurationManager` has been migrated to `Microsoft.Extensions.Configuration`.

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- The `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web` (typically in `Program.cs`).
- Any existing migrations are compatible with the current EF Core version. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Page rendering
- Database reads and writes
- Authentication and authorization (if applicable)

---

## 6. Run Automated Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review the results for any failing tests. Failures may indicate behavioral differences introduced by the migration that require code-level fixes.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or patterns that may not behave correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Windows registry access (`Microsoft.Win32.Registry`)
- Windows-only authentication schemes (e.g., Windows Authentication / NTLM)
- `System.Drawing` usage, which may require the `System.Drawing.Common` package and has platform limitations

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.