# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Confirm that each `.csproj` file is targeting the intended .NET version (e.g., `net8.0`). Open each project file and check for the following:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Do this for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 2. Restore NuGet Packages

Run the following command from the solution root to ensure all dependencies are properly restored:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 3. Build the Solution

Perform a full solution build to confirm there are no issues introduced after restore:

```bash
dotnet build
```

Treat any warnings as potential issues and investigate them, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 4. Run Existing Tests

If the solution contains a test project, run all tests to verify that existing functionality has not regressed:

```bash
dotnet test
```

Review the test output carefully. Any failing tests should be investigated and resolved before proceeding.

---

## 5. Validate Data Layer (`Bookstore.Data`)

- If the project uses Entity Framework Core, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data
```

- Confirm that the connection string in `appsettings.json` or `appsettings.Development.json` points to the correct database instance.

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the main pages and features of the application.
- Check the browser console and application logs for any runtime errors.
- Pay particular attention to areas that interact with the data layer, such as listing, creating, updating, and deleting records.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were specific to .NET Framework and may not behave identically on cross-platform .NET. Common areas to check include:

- `System.Web` references (should have been replaced with ASP.NET Core equivalents)
- Windows Registry access (`Microsoft.Win32.Registry`)
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- Any use of `HttpContext.Current`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if a more thorough audit is needed.

---

## 8. Review Application Configuration

Ensure that configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Verify the following:

- Database connection strings are present and correct.
- Any application-specific settings (e.g., API keys, feature flags) have been transferred.
- Environment-specific overrides are in place using `appsettings.Development.json` or environment variables.

---

## 9. Deploy to a Staging Environment

Once local validation is complete, deploy the application to a staging environment that mirrors production:

```bash
dotnet publish --project Bookstore.Web -c Release -o ./publish
```

- Copy the output from `./publish` to the staging server.
- Confirm the application starts correctly and connects to the staging database.
- Perform a final round of functional testing against the staging environment before promoting to production.