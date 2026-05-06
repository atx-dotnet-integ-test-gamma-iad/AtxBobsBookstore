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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface at this stage, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Review the project dependencies for any packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Win32` registry access
- Windows Communication Foundation (WCF) server-side components
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)

If any are found, replace them with cross-platform alternatives or add a runtime check where appropriate.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the `Bookstore.Domain` layer to verify business logic behaves as expected after migration.

---

## 6. Run the Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on your local machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions
- All pages or API endpoints load correctly
- Database connectivity functions as expected (if applicable)

---

## 7. Validate Database Migrations (If Using Entity Framework Core)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Then apply the migration to the database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Test on Target Platform

If the goal of the migration is to run on Linux or macOS, run the application on that operating system explicitly to catch any remaining platform-specific issues that would not surface on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target platform and observe any runtime errors.