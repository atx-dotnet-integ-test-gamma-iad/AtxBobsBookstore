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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config`, including connection strings and application settings.
- `appsettings.Development.json` is present and contains environment-specific overrides where appropriate.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated correctly.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with cross-platform .NET.
- If using Entity Framework Core, verify that the `DbContext` configuration uses the new `OnConfiguring` or `AddDbContext` patterns.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions.
- Verify that the application responds correctly on both HTTP and HTTPS endpoints.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to:
- Tests that rely on file paths, as path separators differ between Windows and Linux/macOS.
- Tests that depend on Windows-specific APIs or registry access.
- Tests that reference `HttpContext` or other ASP.NET-specific types, which may require updated mocking approaches in ASP.NET Core.

---

## 7. Validate Middleware and HTTP Pipeline

In ASP.NET Core, the HTTP pipeline is configured explicitly in `Program.cs` or `Startup.cs`. Confirm the following middleware is registered in the correct order:

- Authentication and Authorization middleware (`UseAuthentication`, `UseAuthorization`)
- Static file serving (`UseStaticFiles`)
- Routing (`UseRouting`, `UseEndpoints` or `MapControllers`/`MapRazorPages`)
- Exception handling (`UseExceptionHandler` or `UseDeveloperExceptionPage`)

---

## 8. Check Static Files

Ensure that static assets (CSS, JavaScript, images) have been moved to the `wwwroot` folder, which is the expected location in ASP.NET Core. Files left outside of `wwwroot` will not be served by default.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present, including:
- The compiled assemblies
- `appsettings.json`
- The `wwwroot` folder and its contents

---

## 10. Verify Target Runtime

If the application will be deployed to a specific operating system, consider publishing as a self-contained deployment to avoid runtime dependency issues on the target machine.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Replace `linux-x64` with the appropriate runtime identifier for your target environment (e.g., `win-x64`, `osx-x64`).