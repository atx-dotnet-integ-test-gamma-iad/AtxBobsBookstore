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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their current stable versions using:

```bash
dotnet list package --outdated
dotnet add package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs or libraries are being used unintentionally. Look for any of the following in your `.csproj` files:

- `<UseWindowsForms>true</UseWindowsForms>`
- `<UseWPF>true</UseWPF>`
- References to `System.Web`

If `System.Web` references exist in `Bookstore.Web` or `Bookstore.Data`, they will need to be replaced with their ASP.NET Core equivalents.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that the application loads and core functionality works as expected, including:

- Browsing or searching for books
- Any data retrieval from `Bookstore.Data` and `Bookstore.Domain`
- Any forms or user interactions

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and the database connection string is correctly configured for the new environment.

Check `appsettings.json` or `appsettings.Development.json` for the connection string:

```json
"ConnectionStrings": {
  "DefaultConnection": "your_connection_string_here"
}
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project was previously using `Database.SetInitializer` or other EF 6 patterns, confirm these have been replaced with EF Core equivalents.

---

## 7. Execute Unit Tests

If the solution contains test projects, run them to validate business logic and data layer behavior.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to your target environment.