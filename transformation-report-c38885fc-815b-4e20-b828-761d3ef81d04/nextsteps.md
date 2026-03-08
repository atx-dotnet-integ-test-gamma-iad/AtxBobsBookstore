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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still actively supported.

---

## 4. Check for Windows-Specific Dependencies

Since this is a Bookstore web application, verify that no Windows-only APIs or libraries are being used unintentionally. You can use the .NET Compatibility Analyzer or the following command to check for platform-specific issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay particular attention to `Bookstore.Data`, as data access layers commonly reference libraries that may have platform-specific behavior (e.g., certain database drivers or ORM configurations).

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the core functionality of the application, such as browsing, searching, and any data-driven pages.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core or another ORM, confirm the database connection string in `appsettings.json` is correctly configured for your environment. If migrations are used, apply them with:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that all tables and seed data are present and correct after the migration is applied.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Review Logging and Configuration

Confirm that the application's logging and configuration setup has been updated to use the .NET `Microsoft.Extensions.Logging` and `Microsoft.Extensions.Configuration` abstractions, replacing any legacy `System.Configuration` or `log4net` usage that may have been present in the original project.

---

## 9. Publish the Application

Once the application has been validated locally, publish it using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to your target environment.