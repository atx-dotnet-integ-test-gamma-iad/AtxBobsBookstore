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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are not still referencing `net48` or any other legacy framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, review the following areas for any remaining Windows-specific dependencies that may cause issues on Linux or macOS:

- **`System.Web` references** — these are not available in .NET Core or later. Replace with `Microsoft.AspNetCore` equivalents.
- **Registry access** (`Microsoft.Win32.Registry`) — conditionally compile or remove if not needed cross-platform.
- **`System.Drawing.Common`** — on non-Windows platforms this requires additional native libraries or a replacement such as `SkiaSharp`.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests exist, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is valid for the target environment.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and confirm that the core pages and features load without errors. Check the console output and application logs for any runtime exceptions.

---

## 8. Review `appsettings.json` and Configuration

Legacy projects often relied on `Web.config` or `App.config`. Confirm that all necessary configuration values have been migrated to `appsettings.json` or environment variables, including:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all required assets and dependencies are present before deploying to the target environment.