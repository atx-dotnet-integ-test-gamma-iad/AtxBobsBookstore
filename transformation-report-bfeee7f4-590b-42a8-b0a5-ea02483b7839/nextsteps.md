# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore and Build the Solution

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure there are no warnings that could indicate deprecated APIs or compatibility issues that may not surface as hard errors.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Verify this is consistent across all three projects to avoid runtime version mismatches.

---

## 3. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET. Review the following areas:

- **`Bookstore.Data`**: Confirm that any Entity Framework usage has been migrated from EF6 to EF Core. Check `DbContext`, migrations, and connection string configuration.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or configuration-related code is compatible with the new runtime.
- **`Bookstore.Web`**: Confirm that middleware, routing, authentication, and any HTTP modules or Global.asax logic have been properly migrated to ASP.NET Core equivalents (e.g., `Program.cs`, `Startup.cs`, or minimal API setup).

---

## 4. Run Existing Tests

If the solution contains a test project, run the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no tests exist, consider writing basic integration or unit tests for the core domain and data layers before proceeding.

---

## 5. Validate the Web Application Locally

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:
- Application starts without runtime exceptions
- Database connectivity works (run any pending EF Core migrations if applicable: `dotnet ef database update`)
- Core user-facing pages and features load correctly
- Any static files, bundling, or front-end assets are served properly

---

## 6. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants like `appsettings.Development.json`) contain the correct configuration values that were previously held in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 7. Check for Platform-Specific Code

If the application is intended to run on Linux or macOS in addition to Windows, review the codebase for:

- Windows-specific file path separators (use `Path.Combine` instead of hardcoded `\`)
- Windows Registry access
- COM interop or Windows-only libraries
- Case-sensitive file system assumptions

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

Review the output in the `./publish` directory and confirm all required files and dependencies are present before deploying to the target environment.