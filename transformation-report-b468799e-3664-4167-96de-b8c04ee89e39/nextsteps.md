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

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured with a cross-platform-compatible provider such as `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`.
- **`Bookstore.Web`**: Confirm that no Windows-specific authentication or IIS-specific middleware is being used without a cross-platform alternative.
- Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to surface platform-specific API usage.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly in the new environment.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core functionality works, including:

- Page rendering
- Database reads and writes
- Any authentication or authorization flows

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- `HttpContext` and request pipeline behavior
- Entity Framework query translation differences
- Serialization behavior changes (e.g., `System.Text.Json` vs `Newtonsoft.Json`)

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core migrations, verify that existing migrations are compatible and that the database schema can be applied correctly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

If the project previously used EF6, confirm that the migration to EF Core has been handled, as EF Core has differences in LINQ query support, lazy loading configuration, and relationship mapping.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`. Key areas to verify:

- Connection strings
- Application settings
- Logging configuration

The modern .NET configuration system does not use `Web.config` for application settings, so any values remaining there will not be read by the application unless explicitly configured.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required assets, static files, and configuration files are present.