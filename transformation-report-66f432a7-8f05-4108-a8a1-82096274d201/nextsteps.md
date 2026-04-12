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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, it likely uses Entity Framework Core or a similar data access layer. Verify the following:

- The connection string in `appsettings.json` (or equivalent) points to a valid and accessible database.
- If Entity Framework Core is being used, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are pending or missing, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and manually verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Verify the following:

- `web.config` transforms or IIS-specific settings have been replaced or are handled by `appsettings.json` and middleware configuration in `Program.cs` or `Startup.cs`.
- Any file paths in configuration use platform-neutral separators or `Path.Combine()` in code.
- Environment-specific settings are correctly separated using `appsettings.Development.json` and `appsettings.Production.json`.

---

## 7. Check for Removed or Changed APIs

Review the code in all three projects for any use of APIs that are not available in cross-platform .NET. Common areas to check include:

- `System.Web` namespace references — these are not available in .NET Core or .NET 5+.
- Windows-specific APIs such as the registry, certain cryptography providers, or Windows Communication Foundation (WCF) client/server code.
- Any third-party libraries that may still target .NET Framework only.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.