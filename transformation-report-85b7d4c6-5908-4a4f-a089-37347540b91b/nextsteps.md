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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

- Verify that all previously passing tests continue to pass.
- If tests are failing, compare the test output against the original .NET Framework behavior to identify regressions.
- Pay particular attention to any tests covering data access logic in `Bookstore.Data`, as Entity Framework and database provider behavior can differ between .NET Framework and modern .NET.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that database access is functioning correctly:

- Check that the connection string in `appsettings.json` (or equivalent configuration) is correct for the target environment.
- If Entity Framework Core is being used, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check application logs for any runtime exceptions that would not surface during a build, such as missing configuration values, unresolved services, or middleware issues.
- Confirm that static files, routing, and authentication (if applicable) behave correctly under ASP.NET Core.

---

## 6. Review Configuration Changes

Modern .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any application settings previously in `<appSettings>` have been migrated to the appropriate configuration sections.
- Environment-specific overrides are handled via `appsettings.Development.json` or environment variables.

---

## 7. Check for Windows-Specific API Usage

Since the goal is cross-platform compatibility, scan the codebase for any remaining Windows-specific dependencies:

```bash
dotnet build --configuration Release /p:EnableWindowsTargeting=false
```

Alternatively, use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify platform-specific API calls that may not function on Linux or macOS.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assemblies, and static assets are present before deploying to the target environment.