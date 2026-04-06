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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

- Confirm that all previously passing tests continue to pass.
- Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.
- If no tests currently exist, consider writing basic smoke tests for critical paths such as database connectivity and core domain operations before deploying.

---

## 4. Validate Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a development or staging database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the schema is applied correctly and that the application can read and write data as expected.

---

## 5. Run the Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test key user-facing features.
- Check the application logs for any runtime exceptions, particularly around middleware configuration, authentication, or third-party integrations that may behave differently on cross-platform .NET.
- Verify that any static files, configuration files (`appsettings.json`), and environment-specific settings are loading correctly.

---

## 6. Review Configuration and Environment Settings

Cross-platform migrations can surface issues with configuration that were previously masked on Windows:

- Confirm that file paths in configuration do not use hardcoded Windows-style separators (`\`). Use `Path.Combine` or forward slashes where applicable.
- Review `appsettings.json` and any environment-specific overrides (`appsettings.Production.json`, etc.) to ensure connection strings and other settings are correct for the target environment.
- Verify that any Windows-specific APIs or libraries (e.g., Windows Registry access, COM interop) have been replaced or removed.

---

## 7. Deploy to the Target Environment

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed. You can verify the required runtime version in the `Bookstore.Web.csproj` file under the `<TargetFramework>` property.