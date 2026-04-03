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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows **0 Error(s)** for all three projects before proceeding.

---

## 3. Run Database Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay particular attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP endpoints and middleware in `Bookstore.Web`

---

## 5. Validate Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas:

- Application startup completes without exceptions
- Database connectivity is established
- Core pages and API endpoints return expected responses
- Authentication and authorization flows work correctly (if applicable)
- Static assets (CSS, JavaScript, images) are served correctly

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for runtime configuration. Confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary connection strings and application settings that were previously in `Web.config` or `App.config`
- Environment-specific settings are correctly separated
- Sensitive values such as connection strings are not hardcoded and are managed via environment variables or a secrets manager (e.g., `dotnet user-secrets` for local development)

---

## 7. Check for Platform-Specific API Usage

Even when a build succeeds, some APIs that existed in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Review the code in all three projects for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows-specific APIs such as the registry, WMI, or Windows identity impersonation
- Any third-party libraries that have not been updated for cross-platform .NET

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to identify any remaining compatibility concerns:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze Bookstore.Web
```

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to your target environment.