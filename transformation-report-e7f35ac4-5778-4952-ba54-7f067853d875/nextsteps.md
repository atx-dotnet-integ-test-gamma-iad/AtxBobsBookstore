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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Verify Entity Framework or Data Layer

Since the solution contains a `Bookstore.Data` project, confirm the following:

- The correct version of Entity Framework Core is referenced (not the legacy `EntityFramework` package for .NET Framework).
- Any database migrations are still valid. Run the following to list existing migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be updated or recreated, use:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Configuration Files

In .NET, `Web.config` is replaced by `appsettings.json`. Verify the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- The `Startup.cs` or `Program.cs` file correctly reads configuration using `IConfiguration`.

Example connection string format in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=Bookstore;Trusted_Connection=True;"
  }
}
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the main features of the application, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data read and write operations

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review the test results for any failures. If tests were written for .NET Framework-specific APIs, they may require updates to use their .NET equivalents.

---

## 8. Publish the Application

Once validation is complete, publish the application to a folder to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to ensure all required files, static assets, and configuration files are present before deploying to your target environment.