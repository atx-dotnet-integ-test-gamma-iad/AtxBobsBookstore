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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Web` references (not available on .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows-specific DLLs
- Any use of `HttpContext` from `System.Web` rather than `Microsoft.AspNetCore.Http`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code paths.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the application in a browser and exercise the primary user flows, such as browsing books, viewing details, and any data entry forms, to confirm end-to-end functionality.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and the database connection string is correctly configured for the new environment.

Check the connection string in `appsettings.json`:

```json
"ConnectionStrings": {
  "DefaultConnection": "your-connection-string-here"
}
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If you were previously using Entity Framework 6 (EF6), confirm the project has been migrated to Entity Framework Core, as EF6 has limited support on non-Windows platforms.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests. Failures may indicate runtime behavioral differences between .NET Framework and modern .NET that were not caught at compile time.

---

## 8. Validate Configuration System

.NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that all configuration has been moved to `appsettings.json` and that the application reads settings using `IConfiguration` rather than `ConfigurationManager`.

If `ConfigurationManager` is still in use, it is available via the `System.Configuration.ConfigurationManager` NuGet package, but migrating to `IConfiguration` is the recommended approach.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present.