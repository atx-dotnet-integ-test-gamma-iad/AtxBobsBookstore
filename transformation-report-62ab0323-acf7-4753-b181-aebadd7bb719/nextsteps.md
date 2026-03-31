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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Ensure the output shows zero errors and review any warnings that may indicate compatibility concerns with the new target framework.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (EF6) package. EF6 has limited cross-platform support.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (System.Web) project, verify it has been fully migrated to ASP.NET Core, as `System.Web` is not available on cross-platform .NET.
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `BinaryFormatter`, or other APIs that have been removed or restricted.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the core domain and data layers before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without runtime exceptions.
- Database connections (if applicable) are established correctly.
- Core application routes and pages load as expected.
- Any configuration values in `appsettings.json` are correct and replace any legacy `Web.config` or `App.config` entries.

---

## 7. Validate Configuration Migration

If the project previously used `Web.config` or `App.config`, confirm that all relevant settings have been moved to `appsettings.json` and are being read correctly via `IConfiguration`. Pay attention to:

- Connection strings
- Application-specific settings
- Any environment-specific overrides using `appsettings.Development.json`

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder and deploy them to the target environment.