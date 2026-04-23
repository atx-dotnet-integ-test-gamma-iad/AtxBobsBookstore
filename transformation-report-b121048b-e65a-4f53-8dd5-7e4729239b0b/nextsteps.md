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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or earlier, consider updating to `net8.0` (the current LTS release).

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project files for any APIs or packages that are Windows-only. Common areas to check:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any package with a `windows` target framework moniker (e.g., `net8.0-windows`)

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is correct for your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are accurate for the target environment.
- Run any pending migrations to verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows (e.g., browsing books, placing orders) to confirm expected behavior.

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 8. Review Middleware and HTTP Pipeline (Bookstore.Web)

If the web project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify:

- `Program.cs` and/or `Startup.cs` correctly configure services and middleware.
- Authentication, authorization, and session handling are configured using ASP.NET Core equivalents.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with ASP.NET Core middleware.

---

## 9. Publish the Application

Once validation is complete, publish the application to a folder for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.