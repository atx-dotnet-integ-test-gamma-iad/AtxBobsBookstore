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

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)
- `HttpContext` usage patterns
- Any Windows-specific APIs if cross-platform support is required

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm runtime behavior is correct.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection string in your configuration file (e.g., `appsettings.json`) is correct for your environment. Then apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.