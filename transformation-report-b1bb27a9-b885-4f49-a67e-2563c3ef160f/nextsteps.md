# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues that may not have surfaced during the initial transformation check:

```bash
dotnet build --configuration Release
```

Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid cross-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, certain APIs behave differently or have been removed in modern .NET. Review the following areas manually:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the EF Core version is compatible and that any database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are updated.
- **`Bookstore.Web`**: If this is an ASP.NET Core project, verify that `Startup.cs` has been migrated to the minimal hosting model (`Program.cs`) if applicable, and that middleware configuration is correct.
- **`Bookstore.Domain`**: Check for any use of `System.Web` or other namespaces that do not exist in cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate core logic:

```bash
dotnet test
```

If no tests exist, consider writing basic tests for the domain and data layers to verify expected behavior before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify:

- Pages load without errors
- Database connectivity works (if applicable)
- Core application workflows function correctly

---

## 7. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are correct for the target environment
- Any configuration keys previously stored in `Web.config` have been moved to `appsettings.json`
- The `Web.config` file, if still present, is not being relied upon for runtime configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.