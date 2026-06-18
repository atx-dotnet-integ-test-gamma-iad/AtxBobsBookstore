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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them now:

```bash
dotnet test
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` and `Bookstore.Data` layers at minimum, as these form the core logic of the application.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for the target database.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the displayed local URL in a browser.
- Walk through the core application workflows (e.g., browsing books, managing inventory) to confirm functionality is intact.
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Review Configuration Files

Confirm that the following have been correctly migrated and are appropriate for cross-platform .NET:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`.
- Any file paths used in the application use `Path.Combine` or forward-slash-compatible formats rather than hardcoded Windows-style paths.
- Environment-specific settings are separated into `appsettings.Development.json` and `appsettings.Production.json` as appropriate.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining Windows-specific APIs that may not be available cross-platform, such as:

- `System.Drawing` (use a cross-platform alternative like `SkiaSharp` if image processing is needed)
- Windows Registry access
- COM interop or P/Invoke calls targeting Windows libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.