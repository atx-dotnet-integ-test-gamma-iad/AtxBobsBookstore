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

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are either end-of-life or approaching it.

---

## 4. Check for Windows-Specific APIs

Since this was a legacy project, verify that no Windows-specific APIs are being used that would break cross-platform compatibility. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific configurations
- **File path separators** — ensure `Path.Combine` is used rather than hardcoded backslashes
- **`System.Drawing`** — if used for image processing, replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp`

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, confirm it has been migrated to **Entity Framework Core**.
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If connection strings reference SQL Server with Windows Authentication (`Integrated Security=True`), verify this is still appropriate for the target deployment environment.

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without runtime exceptions
- Database connectivity is functional
- Core user-facing pages load and behave as expected
- Any authentication or authorization flows work correctly

---

## 8. Review `appsettings.json` Configuration

Legacy projects often used `Web.config` for configuration. Confirm that all necessary settings have been moved to `appsettings.json` and that environment-specific overrides are in place using `appsettings.Development.json` or `appsettings.Production.json` as appropriate.

Key items to verify:

- Connection strings
- Logging configuration
- Any custom application settings previously stored in `<appSettings>` blocks

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files, static assets, and configuration files are present before deploying to the target environment.