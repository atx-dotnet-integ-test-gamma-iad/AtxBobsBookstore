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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, logging settings, and any environment-specific values have been correctly migrated.
- If `Web.config` transforms were used previously, ensure the equivalent configuration is handled via `appsettings.{Environment}.json` or environment variables.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are present and valid. Run the following to list migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests:

```bash
dotnet test
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application and exercise the primary workflows (browsing books, data retrieval, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.
- Verify that static assets (CSS, JavaScript, images) are served correctly.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or dependencies that may cause issues on non-Windows platforms:

- `System.Web` references (should have been replaced by `Microsoft.AspNetCore` equivalents)
- Windows Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- COM interop or P/Invoke calls

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

---

## 8. Review Middleware and HTTP Pipeline

In `Bookstore.Web`, verify that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured:

- Authentication and authorization middleware is registered and ordered correctly.
- Custom HTTP modules or handlers from the legacy project have been converted to ASP.NET Core middleware.
- Error handling middleware is in place.

---

## 9. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.