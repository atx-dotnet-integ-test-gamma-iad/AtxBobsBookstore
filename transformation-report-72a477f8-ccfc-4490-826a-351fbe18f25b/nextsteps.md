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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, such as obsolete APIs or platform-specific code paths.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no framework mismatch issues at runtime.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the following areas for any remaining Windows-specific dependencies:

- **`Bookstore.Data`**: Check for any usage of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which supports cross-platform scenarios.
- **`Bookstore.Web`**: Confirm that no Windows-only APIs (e.g., registry access, Windows authentication with NTLM) are being used unless explicitly required.
- **`Bookstore.Domain`**: Review any file path handling to ensure `Path.Combine` is used instead of hardcoded backslashes.

---

## 5. Run Existing Tests

If a test project exists in the solution, run it to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic unit tests for the domain and data layers to verify core functionality before deployment.

---

## 6. Run the Web Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If there are pending migrations or the schema has changed, apply them to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Check `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` for the following:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` have been moved to `appsettings.json` or environment variables.
- Sensitive values such as connection strings or API keys are not hardcoded and are instead sourced from environment variables or a secrets manager.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder before deploying to the target server.