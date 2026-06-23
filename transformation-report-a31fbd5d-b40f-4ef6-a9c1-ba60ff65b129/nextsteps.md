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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (for example, `net8.0`). Mismatched target frameworks between projects can cause subtle runtime issues even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even with a clean build, some APIs that existed in .NET Framework may have changed behavior or have different implementations in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework or any data access library is using the correct cross-platform compatible version (e.g., EF Core instead of EF 6 for .NET Framework).
- **`Bookstore.Web`**: Confirm that any middleware, authentication, or HTTP pipeline configuration has been updated to use ASP.NET Core conventions.
- **`Bookstore.Domain`**: Check for any use of `System.Web`, `AppDomain`, or other namespaces that are not fully supported on cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate functional correctness after the migration.

```bash
dotnet test
```

If no test project currently exists, consider writing tests that cover the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- The application starts without exceptions.
- Key pages and routes load correctly.
- Database connectivity functions as expected (check connection strings in `appsettings.json` for cross-platform path or provider compatibility).

---

## 7. Review Configuration Files

Ensure that configuration has been fully migrated from `Web.config` or `App.config` to `appsettings.json` and the ASP.NET Core configuration system. Specifically check for:

- Database connection strings.
- Application-specific settings previously stored in `<appSettings>`.
- Any environment-specific configuration that may need to be separated into `appsettings.Development.json` or similar files.

---

## 8. Validate Database Migrations

If the project uses Entity Framework Core, confirm that all migrations are up to date and can be applied cleanly against the target database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, generate an initial migration from the current model:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm a clean release output.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files are present, including static assets and configuration files.