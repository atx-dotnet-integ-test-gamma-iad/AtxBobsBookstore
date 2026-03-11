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

Verify that no warnings or errors appear related to missing or incompatible packages. Pay particular attention to any packages that may have been replaced with compatibility shims during transformation, as these may need to be updated to their modern cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, especially:
- Obsolete API usage warnings
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

While warnings do not prevent a build, they may indicate areas of the code that could fail at runtime on non-Windows platforms.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, it is worth creating tests that cover:
- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data`, including database connectivity and query correctness
- Web layer behavior in `Bookstore.Web`, such as controller actions and middleware

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the target database provider:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions
- All routes and pages load correctly
- Database read and write operations function as expected
- Any authentication or authorization flows behave correctly

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) to confirm:
- Connection strings are correct for the target environment
- Any legacy `Web.config` or `App.config` values have been properly migrated to the new configuration system
- Secrets are not stored in plain text; consider using `dotnet user-secrets` for local development

---

## 7. Cross-Platform Validation

If one of the goals of this migration is to run on non-Windows operating systems, test the application on the target platform (Linux or macOS) by repeating steps 1 through 5 in that environment. Pay attention to:
- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Case-sensitive file systems on Linux
- Any remaining Windows-specific API calls flagged by `CA1416` warnings