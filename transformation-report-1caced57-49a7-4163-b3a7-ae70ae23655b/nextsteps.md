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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Do this for all three projects:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 4. Check for Removed or Changed APIs

Review the code for any usage of Windows-specific or legacy APIs that may have been present in the original project. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage
- Any configuration that previously relied on `Web.config` (should now use `appsettings.json`)
- `Global.asax` logic (should be moved to `Program.cs` or `Startup.cs`)

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- Confirm the EF Core version is compatible with the target framework.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no test project exists, consider manually exercising the key domain and data layer functionality before proceeding.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

Check the following:
- The application starts without runtime exceptions.
- Key pages and routes load correctly.
- Database connectivity is functioning as expected.
- Authentication and authorization (if applicable) behave as intended.

---

## 8. Review `appsettings.json` Configuration

Ensure that all necessary configuration values have been migrated from `Web.config` to `appsettings.json`, including:

- Connection strings
- Application-specific settings
- Logging configuration

Example structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 9. Cross-Platform Verification

If the intent is to run this application on Linux or macOS, test the application on the target operating system to catch any remaining platform-specific issues such as:

- File path separators (`\` vs `/`)
- Case-sensitive file references
- OS-specific dependencies in NuGet packages