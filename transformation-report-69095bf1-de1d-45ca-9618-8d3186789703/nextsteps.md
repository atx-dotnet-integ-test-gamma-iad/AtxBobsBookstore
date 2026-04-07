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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate deprecated APIs or other compatibility concerns.

---

## 3. Run Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to a database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in your configuration file (`appsettings.json` or equivalent) points to the correct database instance.

---

## 4. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Data reads and writes to the database function as expected.
- Any authentication or authorization flows work correctly.

---

## 6. Review Configuration Files

Cross-platform migrations can surface environment-specific configuration issues. Check the following:

- **`appsettings.json`**: Confirm connection strings, API keys, and other settings are correct for the target environment.
- **File paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\`) remain in configuration or code.
- **Environment variables**: Verify that any environment-specific values are set correctly on the target machine or server.

---

## 7. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file and checking the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid runtime compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target server.