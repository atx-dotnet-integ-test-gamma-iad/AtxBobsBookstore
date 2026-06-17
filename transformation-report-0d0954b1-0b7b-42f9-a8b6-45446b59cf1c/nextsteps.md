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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netframework` target monikers, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining Windows-specific APIs or libraries, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific code.

---

## 5. Review and Update Configuration

Legacy .NET Framework projects used `Web.config` and `App.config`. Cross-platform .NET uses `appsettings.json` and environment variables.

- Confirm that `Web.config` has been replaced or supplemented by `appsettings.json` in `Bookstore.Web`.
- Verify that connection strings, app settings, and environment-specific configuration have been migrated correctly.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 6. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer functions correctly:

- Confirm the database provider (e.g., Entity Framework Core) is properly configured.
- If Entity Framework is used, verify that migrations are present and up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL (e.g., `https://localhost:5001`) and verify that core functionality such as browsing, searching, and any data-driven pages operate as expected.

---

## 8. Execute Any Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results and investigate any failures. Pay particular attention to tests that interact with the database or external services, as connection strings and service registrations may have changed during migration.

---

## 9. Review Middleware and Startup Configuration

In cross-platform .NET, application startup is handled via `Program.cs` and optionally `Startup.cs`. Confirm the following are correctly configured in `Bookstore.Web`:

- Routing (`app.UseRouting()`)
- Authentication and Authorization middleware, if applicable
- Static file serving (`app.UseStaticFiles()`)
- Database context registration via dependency injection

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is clean.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files are present before deploying to your target environment.