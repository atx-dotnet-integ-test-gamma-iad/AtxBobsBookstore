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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netstandard2.0`, update it to a current target framework and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used without the appropriate platform target or compatibility shim. Look for usages of:

- `System.Web`
- `Microsoft.Win32`
- Windows Registry access
- COM interop

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC project targeting `System.Web`, confirm it has been fully migrated to ASP.NET Core.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify the application loads and behaves as expected.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection string in `appsettings.json` is correct for your environment. Then apply any pending migrations.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 7. Execute Unit Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test output for any failures that may indicate behavioral differences introduced during the migration.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.