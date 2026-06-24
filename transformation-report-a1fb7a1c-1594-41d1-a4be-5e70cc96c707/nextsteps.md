# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 2. Restore Dependencies

Run a full NuGet restore from the solution root to ensure all packages resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings about deprecated packages or packages that do not support the target framework.

---

## 3. Build the Solution

Perform a clean build to confirm there are no hidden warnings or errors that were not surfaced during the initial transformation check.

```bash
dotnet build --configuration Release
```

Address any warnings flagged during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate runtime issues.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing behavior has been preserved.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime, such as differences in globalization, file path handling, or reflection behavior.

---

## 5. Validate Data Layer (`Bookstore.Data`)

- Confirm that your database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Run any pending migrations or verify the database schema is consistent.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Test all data access operations (CRUD) manually or through integration tests to confirm correct behavior.

---

## 6. Validate Domain Layer (`Bookstore.Domain`)

- Review any domain logic that may rely on `System.Configuration.ConfigurationManager` or other APIs that behave differently on cross-platform .NET.
- Confirm that any serialization, date/time handling, or culture-sensitive operations produce the expected results on the new runtime.

---

## 7. Validate Web Layer (`Bookstore.Web`)

- If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify the following:
  - Middleware configuration in `Program.cs` or `Startup.cs` is correct.
  - Authentication and authorization schemes are properly configured.
  - Static files, routing, and model binding behave as expected.
- Run the web application locally and navigate through all major pages and endpoints.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

---

## 8. Check Runtime Configuration

- Ensure `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`.
- Confirm connection strings, logging settings, and any environment-specific values are correctly defined.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 9. Cross-Platform File Path Validation

If the application reads or writes files, verify that all file path constructions use `Path.Combine` rather than hardcoded backslashes, to ensure compatibility across operating systems.

```csharp
// Preferred
var path = Path.Combine("directory", "file.txt");

// Avoid
var path = "directory\\file.txt";
```

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct before deploying to the target environment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to ensure all required files, static assets, and dependencies are present.