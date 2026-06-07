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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`) across all three projects.

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

Mismatched target frameworks between projects can cause runtime issues even when the build succeeds.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references — these are not available in cross-platform .NET and should be replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager` — replace with `Microsoft.Extensions.Configuration`.
- `HttpContext` usage — ensure it is accessed via dependency injection rather than statically.
- Entity Framework — confirm the project has migrated from EF 6 to EF Core if applicable, and that database providers are correctly configured.

---

## 5. Run Database Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are present and up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration and apply it to the database.

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate that the core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization behave correctly if present.
- Static files (CSS, JavaScript, images) are served properly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values, including:

- Database connection strings.
- Any application-specific settings that were previously stored in `Web.config` or `App.config`.

`Web.config` is not used for application configuration in cross-platform .NET. All configuration should be managed through `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.