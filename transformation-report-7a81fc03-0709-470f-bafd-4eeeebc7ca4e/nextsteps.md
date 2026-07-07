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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still actively supported.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or packages. Common areas to check include:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured with a cross-platform-compatible provider such as `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`.
- **`Bookstore.Web`**: Check that no `System.Web` references remain, as these are not supported outside of .NET Framework.
- **`Bookstore.Domain`**: Verify no platform-specific types or P/Invoke calls are present.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this check.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data layer behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Run the Web Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without runtime exceptions.
- All pages and routes load correctly.
- Database connectivity is functioning (check connection strings in `appsettings.json`).
- Any authentication or authorization flows behave as expected.

---

## 7. Review Configuration Files

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 8. Validate Data Layer Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that any existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to your target environment.