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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and should be replaced with cross-platform alternatives.

---

## 5. Database Migration Validation

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding unit tests for critical logic in `Bookstore.Domain` and `Bookstore.Data` before proceeding.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that may have previously been stored in `Web.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

`Web.config` is not used in cross-platform .NET applications outside of IIS-specific settings.

---

## 9. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Deploy the contents of the `./publish` directory to your target hosting environment, such as IIS, Azure App Service, or a Linux-based server running the .NET runtime.

For IIS deployments, ensure the **ASP.NET Core Hosting Bundle** is installed on the server.