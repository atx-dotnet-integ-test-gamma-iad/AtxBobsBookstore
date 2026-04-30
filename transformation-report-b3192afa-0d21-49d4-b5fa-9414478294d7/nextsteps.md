# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were previously written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to work correctly under cross-platform .NET.

---

## 4. Verify Runtime Behavior

### 4.1 Database Connectivity (`Bookstore.Data`)

- Confirm that the connection string format in `appsettings.json` is correct for your database provider.
- If Entity Framework Core was introduced during migration, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to your development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 4.2 Domain Logic (`Bookstore.Domain`)

- Manually trace through core domain logic to confirm that any types previously sourced from `System.Web` or other Windows-specific assemblies have been correctly replaced with their cross-platform equivalents.

### 4.3 Web Application (`Bookstore.Web`)

- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that:
  - Pages render correctly.
  - Forms submit and process data as expected.
  - Authentication and authorization flows work if applicable.
  - Static assets (CSS, JavaScript, images) are served correctly.

---

## 5. Review Configuration

- Confirm that `appsettings.json` and `appsettings.Production.json` contain all required configuration values that were previously stored in `Web.config` or `App.config`.
- Verify that any environment-specific settings are correctly separated using the ASP.NET Core configuration system.
- Check that logging configuration is in place and functioning.

---

## 6. Cross-Platform Validation

If the intent is to run this application on Linux or macOS, test the application on the target operating system. Pay particular attention to:

- **File path separators**: Ensure no hardcoded backslashes (`\`) exist in file path logic.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that all file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs**: Confirm that no remaining dependencies exist on Windows-only APIs or libraries.

---

## 7. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to your target environment.