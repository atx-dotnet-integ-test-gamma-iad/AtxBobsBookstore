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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`System.Web` references** — This namespace is not available in .NET Core or later. Any remaining usage should be replaced with `Microsoft.AspNetCore` equivalents.
- **Entity Framework** — If the project uses Entity Framework 6, consider whether migration to Entity Framework Core is needed, as EF6 has limited support on non-Windows platforms.
- **Configuration** — `System.Configuration.ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to surface any runtime-level compatibility concerns.

---

## 5. Run Unit Tests

If the solution contains test projects, execute the test suite to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET rather than logic errors.

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page rendering
- Database connectivity (if applicable)
- Any authentication or authorization flows
- Core domain operations such as browsing, searching, or managing books

---

## 7. Review `appsettings.json` and Configuration

Ensure that connection strings and application settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

Confirm that environment-specific configuration files (e.g., `appsettings.Development.json`) are in place where needed.

---

## 8. Verify Database Connectivity and Migrations

If the project uses a database, confirm that the connection string is correct and that any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project does not use EF migrations, verify the database schema is compatible with the updated data access layer.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files, static assets, and configuration files are present before deploying to the target environment.