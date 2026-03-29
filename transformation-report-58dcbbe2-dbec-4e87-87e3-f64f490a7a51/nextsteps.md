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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were previously written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to align with .NET equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the project file and `DbContext`.
- If the project previously used **Entity Framework 6**, verify whether it has been migrated to **Entity Framework Core**, as the two have API differences.
- Run any existing database migrations or apply a new migration to confirm the schema is intact:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and ensure no types rely on assemblies that were specific to .NET Framework (e.g., `System.Web`, `System.Drawing` without the compatibility package).
- Check that any serialization attributes or data annotations are sourced from the correct cross-platform namespaces.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting) are correctly configured for ASP.NET Core.
- Verify that any configuration previously handled by `Web.config` has been moved to `appsettings.json`.
- Check that authentication, authorization, and middleware components have been updated to use ASP.NET Core equivalents.
- Run the application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any account-related functionality) to confirm expected behavior.

---

## 7. Review `appsettings.json`

- Ensure connection strings, logging configuration, and any application-specific settings have been correctly transferred from `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., `appsettings.Development.json`) are in place where needed.

---

## 8. Check for Remaining .NET Framework Dependencies

Use the .NET Upgrade Assistant compatibility analyzer or the following command to identify any remaining references that may not be fully cross-platform:

```bash
dotnet build --configuration Release /warnaserror
```

Additionally, review each `.csproj` file to confirm the target framework is set to a supported cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assemblies, static assets, and configuration files are present.