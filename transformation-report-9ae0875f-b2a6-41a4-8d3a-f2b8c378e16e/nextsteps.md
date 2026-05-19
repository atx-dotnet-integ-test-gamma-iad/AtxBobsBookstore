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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net6.0`, `net7.0`, or `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Search the codebase for any APIs that are not supported on cross-platform .NET. Common areas to check include:

- `System.Web` references (not available in .NET Core and later)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side usage
- `HttpContext` usage that relied on `System.Web.HttpContext` rather than `Microsoft.AspNetCore.Http.HttpContext`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to surface any remaining compatibility issues.

---

## 5. Review Entity Framework or Data Access Layer

Since the solution contains a `Bookstore.Data` project, confirm the following:

- If Entity Framework is in use, verify it has been migrated to **Entity Framework Core**.
- Check that the database connection strings in `appsettings.json` are correctly configured.
- Run any existing migrations or create a new initial migration if needed:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and modern .NET.

---

## 7. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page rendering
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and dependencies are present.