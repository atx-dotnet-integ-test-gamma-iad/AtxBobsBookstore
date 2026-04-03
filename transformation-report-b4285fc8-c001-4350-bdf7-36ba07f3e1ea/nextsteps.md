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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs or libraries remain in use. The .NET Upgrade Assistant or the compatibility analyzer can assist with this.

```bash
dotnet add package Microsoft.DotNet.PlatformAbstractions
```

Alternatively, run the API compatibility analyzer:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Look for analyzer warnings prefixed with `CA1416` which indicate platform-specific API usage.

---

## 5. Run Existing Tests

If a test project exists in the solution, execute the test suite to verify that existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of dependencies.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally to confirm the application starts and core functionality is intact.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity through `Bookstore.Data` is functioning.
- Core domain logic in `Bookstore.Domain` behaves as expected.
- Any static files, views, or Razor pages render correctly.

---

## 7. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to ensure connection strings, API keys, and other settings have been correctly migrated from the legacy `Web.config` or `App.config` files.

Confirm that the configuration is being loaded correctly at startup using the `IConfiguration` interface provided by `Microsoft.Extensions.Configuration`.

---

## 8. Database Migration Validation

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and compatible with the new runtime.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations against a test database before pointing to a production database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target environment.