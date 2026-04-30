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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- Any usage of `Microsoft.Win32` namespaces
- Registry access
- Windows-only file path assumptions (e.g., backslashes)
- Any NuGet packages that only support `net4x` or `windows` target frameworks

Use the following command to inspect package compatibility:

```bash
dotnet list package --outdated
```

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output and manually verify the following:

- The application loads without errors
- Core pages and routes are accessible
- Data access operations (reads and writes) function correctly against the database

---

## 6. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and that the database connection string is correctly configured for the new environment:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Automated Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review the test results and investigate any failures. If no test projects exist, consider adding unit tests for the domain and data layers as a baseline for future changes.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are correctly set up. Pay particular attention to:

- Connection strings
- Logging configuration
- Any settings that previously resided in `Web.config` or `App.config`, which should now be migrated to `appsettings.json`

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.