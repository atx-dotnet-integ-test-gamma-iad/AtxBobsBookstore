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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the EF Core version is compatible with the target framework. Check that database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are up to date.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm that middleware, routing, and configuration patterns have been updated to the ASP.NET Core equivalents. Pay particular attention to `Startup.cs` vs. the minimal hosting model in `Program.cs`.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs used still behave as expected under the new runtime.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing unit tests for critical logic in `Bookstore.Domain` and integration tests for data access in `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Database connections are established successfully (check connection strings in `appsettings.json`).
- Core user-facing functionality such as browsing, searching, and managing books works as expected.
- Any authentication or authorization flows behave correctly.

---

## 7. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Application settings
- Logging configuration

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

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.