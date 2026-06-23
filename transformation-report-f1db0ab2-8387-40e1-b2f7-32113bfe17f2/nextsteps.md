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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net472` or similar legacy monikers, update them accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the projects for any APIs or packages that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured correctly and does not rely on Windows-specific connection mechanisms.
- **`Bookstore.Web`**: Confirm that no legacy `System.Web` references remain. These are not supported on cross-platform .NET and must be replaced with ASP.NET Core equivalents.
- **`Bookstore.Domain`**: Check for any use of `System.Configuration.ConfigurationManager`. If present, replace it with `Microsoft.Extensions.Configuration`.

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining platform-specific API usage.

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the core functionality, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data access operations (reads and writes to the database)

---

## 6. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing behavior has been preserved:

```bash
dotnet test
```

Review the test results for any failures. Failures may indicate behavioral differences introduced by the migration that require code-level fixes.

If no tests currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to establish a baseline before making further changes.

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date and can be applied cleanly:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a local or staging database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

The contents of the `./publish` directory can then be deployed to your target hosting environment, such as IIS, Azure App Service, or a Linux server running the .NET runtime.

For IIS hosting, ensure the [ASP.NET Core Hosting Bundle](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/) is installed on the target machine.