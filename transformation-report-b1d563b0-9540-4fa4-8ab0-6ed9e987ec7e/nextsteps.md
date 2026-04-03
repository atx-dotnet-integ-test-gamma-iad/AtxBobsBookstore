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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netframework` or platform-specific targets, consider finding cross-platform alternatives on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `netcoreapp*` or `net4*`, update it to a current long-term support (LTS) release.

---

## 4. Check for Windows-Specific APIs

Even if the project builds successfully, there may be runtime dependencies on Windows-specific APIs (e.g., the registry, Windows authentication, or `System.Drawing`). Run a compatibility analyzer to surface any such issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Address any reported `PC001` or `PC002` warnings, which indicate platform-specific API usage.

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected on your local machine.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads correctly.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is correct for your target environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If you are using a different data access strategy, verify the connection manually by exercising the relevant data access paths through the running application.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to confirm that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that cover data access or HTTP middleware, as these areas are most commonly affected by framework migrations.

---

## 8. Cross-Platform Validation

If the goal is true cross-platform support, run the application on at least one non-Windows operating system (Linux or macOS) to confirm there are no hidden platform dependencies at runtime.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Test the same user flows exercised on Windows to confirm consistent behavior.

---

## 9. Review `appsettings.json` and Configuration

Ensure that configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment variables. Confirm that:

- Connection strings are present and accurate.
- Any custom configuration sections have been re-implemented using the `Microsoft.Extensions.Configuration` API.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment (IIS, Linux host, Azure App Service, etc.) according to that environment's standard deployment procedure.