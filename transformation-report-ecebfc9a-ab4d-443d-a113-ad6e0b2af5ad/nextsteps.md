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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify this is consistent across all three projects:
- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, some packages or APIs may only function on Windows. Review the dependencies in each `.csproj` for any packages that:

- Reference `Microsoft.Win32` namespaces
- Use the `net-windows` target framework suffix (e.g., `net8.0-windows`)
- Depend on COM interop or the Windows Registry

Replace or abstract any such dependencies if cross-platform support is required.

---

## 5. Database Migration Validation (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be updated, run:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects to establish a baseline for correctness.

---

## 7. Run the Web Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:
- Application starts without runtime exceptions
- Database connectivity is functional
- Core application routes and pages load correctly
- Any authentication or authorization flows behave as expected

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) have been updated appropriately. Pay particular attention to:

- Connection strings
- Any configuration keys that may have changed between the legacy and new framework versions
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and dependencies are present before deploying to the target environment.