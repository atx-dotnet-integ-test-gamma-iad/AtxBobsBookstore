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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify all previously passing tests continue to pass.
- If tests were written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), review them for compatibility with the cross-platform .NET equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the new project.
- If the project previously used **Entity Framework 6**, verify whether it has been migrated to **Entity Framework Core**, as EF6 has limited cross-platform support.
- Run any existing database migrations to ensure the schema is applied correctly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist, verify that the `DbContext` and model configurations are functioning as expected.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any reliance on types or namespaces that were specific to .NET Framework, such as:
  - `System.Web`
  - `System.Configuration.ConfigurationManager` (now in the `System.Configuration.ConfigurationManager` NuGet package)
- Confirm that all referenced assemblies resolve correctly under the target .NET version.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- If the project was migrated from **ASP.NET (System.Web)** to **ASP.NET Core**, verify the following:
  - Middleware configuration in `Program.cs` or `Startup.cs` is correct.
  - Authentication and authorization mechanisms have been updated to use ASP.NET Core equivalents.
  - Any `Web.config` settings have been moved to `appsettings.json` or environment variables.
  - Static files, routing, and view rendering (Razor, etc.) are functioning correctly.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication, etc.) to confirm runtime behavior is correct.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` contains the necessary configuration values previously held in `Web.config` or `App.config`.
- Confirm connection strings are correctly formatted for the target database provider.
- Check that environment-specific configuration (e.g., `appsettings.Development.json`) is in place.

---

## 8. Check for Platform-Specific API Usage

Use the .NET Compatibility Analyzer or review the build warnings to identify any remaining calls to Windows-only APIs if cross-platform execution on Linux or macOS is required. The analyzer can be enabled by setting the following in your `.csproj`:

```xml
<PropertyGroup>
  <EnableNETAnalyzers>true</EnableNETAnalyzers>
  <AnalysisMode>All</AnalysisMode>
</PropertyGroup>
```

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including runtime dependencies and static assets, are present before deploying to the target environment.