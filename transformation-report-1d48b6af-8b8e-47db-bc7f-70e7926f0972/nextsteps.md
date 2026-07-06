# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps focus on validating correctness and preparing for deployment.

---

## 1. Verify Target Framework

Confirm that each `.csproj` file is targeting the intended cross-platform .NET version (e.g., `net8.0`). Open each project file and check for the following:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no legacy `net48` or `netcoreapp` targets remain unless intentional.

---

## 2. Restore Dependencies

Run a full NuGet restore to confirm all packages resolve correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated packages or version conflicts, particularly in `Bookstore.Data` where data access libraries (e.g., Entity Framework) may have been updated.

---

## 3. Build the Solution in Release Mode

Perform a release build to surface any configuration-specific issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, as some may indicate runtime issues even if they do not block compilation.

---

## 4. Run Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Review Configuration Files

Check that `appsettings.json` in `Bookstore.Web` contains valid configuration for the current environment, including:

- Connection strings
- Any API keys or service endpoints previously stored in `Web.config`

Legacy `Web.config` settings are not automatically read in cross-platform .NET. Confirm all necessary values have been migrated to `appsettings.json` or environment variables.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral changes introduced during migration or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application and verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

Manually test the following areas at a minimum:

- Application startup and home page load
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

---

## 8. Check for Runtime Deprecations or Compatibility Warnings

At runtime, monitor the application logs for:

- Warnings about obsolete APIs
- Missing middleware registrations
- Unhandled exceptions related to platform-specific code that compiled but does not behave correctly on the new runtime

---

## 9. Review Static Files and Bundling

If `Bookstore.Web` uses static assets, confirm that static file middleware is correctly configured in `Program.cs` or `Startup.cs`:

```csharp
app.UseStaticFiles();
```

Legacy bundling via `BundleConfig.cs` is not supported in cross-platform .NET. If bundling is needed, consider using a tool such as `libman` or a build-time bundler.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, including `appsettings.json` and static assets, are present before deploying to the target environment.