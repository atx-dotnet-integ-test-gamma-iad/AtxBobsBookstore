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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Ensure the output shows **0 Error(s)** for all three projects before continuing.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid values such as `net48` or `netcoreapp3.1`, as these are either Windows-only or out of support.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still reference Windows-specific APIs that will fail at runtime on Linux or macOS. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay close attention to any warnings prefixed with `CA1416` (platform compatibility).

---

## 5. Review Entity Framework or Data Layer Configuration

In `Bookstore.Data`, confirm that any database provider configuration has been updated for the target platform. For example, if SQL Server is used:

```csharp
options.UseSqlServer(connectionString);
```

Ensure the connection string in `appsettings.json` is valid and accessible in the new environment. If the project previously used `App.config`, verify that configuration has been migrated to `appsettings.json`.

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic integration tests for critical paths such as data retrieval and web routing before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the URL shown in the console output and manually verify core functionality such as page rendering, data loading, and form submissions.

---

## 8. Review `appsettings.json` and Environment Configuration

Confirm that all environment-specific settings (connection strings, API keys, feature flags) are correctly defined in `appsettings.json` or `appsettings.Production.json`. Sensitive values should be stored using environment variables or a secrets manager rather than committed to source control.

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

Review the contents of the `./publish` folder to confirm all expected files are present before deploying to the target environment.