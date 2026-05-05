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

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespaces
- Windows registry access
- `System.Drawing` (which has platform limitations on non-Windows)

Replace or conditionally compile any such dependencies as needed.

---

## 5. Database Migration Validation (Bookstore.Data)

If the project uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, searching, and any data-driven pages work as expected.

---

## 8. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm:

- Connection strings are correct and point to the intended database.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the new JSON-based configuration system.
- Secrets are not hardcoded; use `dotnet user-secrets` for local development if needed.

---

## 9. Validate Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order.
- Services such as dependency injection registrations, authentication, and authorization are properly configured for the new hosting model.
- Static files, routing, and error handling are functioning as expected.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.