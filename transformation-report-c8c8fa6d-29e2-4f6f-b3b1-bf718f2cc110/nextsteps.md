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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests targeting critical areas such as:

- Domain logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data`
- Controller actions and middleware in `Bookstore.Web`

---

## 4. Verify Data Access Layer

Since `Bookstore.Data` handles persistence, verify the following:

- **Entity Framework Core migrations** are present and up to date. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values, including connection strings that were previously in `Web.config`.
- Environment-specific settings (e.g., `Development`, `Production`) are correctly separated.
- Sensitive values such as connection strings or API keys are managed via **User Secrets** locally:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 6. Run the Application Locally

Start the application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Manually test core user flows such as browsing, searching, and any data submission forms.
- Check the console and application logs for runtime exceptions or warnings.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were valid in .NET Framework but may behave differently or require replacement in cross-platform .NET:

- `System.Web` references should have been removed; confirm none remain.
- Any use of the Windows Registry, COM interop, or Windows-specific APIs should be identified and replaced with cross-platform alternatives if the application is intended to run on non-Windows systems.
- File path handling should use `Path.Combine` and avoid hardcoded backslashes.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target hosting environment, such as IIS, a Linux server with Kestrel, or Azure App Service.