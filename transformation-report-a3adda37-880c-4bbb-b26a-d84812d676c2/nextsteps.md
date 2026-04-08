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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Any environment-specific configuration is handled via `appsettings.Development.json`, `appsettings.Production.json`, or environment variables.
- The `Startup.cs` or `Program.cs` correctly registers services, middleware, and configuration sources.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` handles data access, confirm the following:

- The connection string in `appsettings.json` is correct for your target database.
- If Entity Framework is used, run a check to ensure migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually test the primary workflows such as browsing, searching, and any authentication flows.

---

## 6. Execute Automated Tests

If the solution contains a test project, run all tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

If no test project exists, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data layer in `Bookstore.Data` before deploying to production.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references — these should have been replaced with `Microsoft.AspNetCore` equivalents.
- Windows Registry access (`Microsoft.Win32.Registry`) — not available on Linux/macOS.
- `HttpContext.Current` — replaced by dependency-injected `IHttpContextAccessor`.
- `Thread.Abort()` — throws `PlatformNotSupportedException` in .NET 5+.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to surface any remaining compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before copying them to the target server.