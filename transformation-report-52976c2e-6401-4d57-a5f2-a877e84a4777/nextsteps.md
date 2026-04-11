# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- If the project was previously using Entity Framework 6 (EF6), verify that the migration to EF Core was handled correctly. Check that `DbContext`, entity configurations, and connection strings are functioning as expected.

- Apply pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data
```

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that:
  - Pages render correctly.
  - Data is read from and written to the database as expected.
  - Any authentication or authorization flows work correctly.

- Check `appsettings.json` and `appsettings.Development.json` to ensure connection strings and other configuration values are correct for the target environment.

---

## 7. Check for Windows-Specific API Usage

Since this is a cross-platform migration, scan the codebase for any remaining Windows-specific APIs that may not be available on Linux or macOS. Common areas to check include:

- Use of the `Microsoft.Win32` namespace.
- Registry access.
- Windows-specific file path assumptions (e.g., backslashes).
- `System.Drawing` (GDI+), which has limited cross-platform support and may require replacement with a library such as `SkiaSharp` or `ImageSharp`.

Use the .NET Compatibility Analyzer or the following command to surface platform-specific warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Review Configuration and Environment Settings

- Ensure `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`.
- Confirm that environment-specific overrides are in place using `appsettings.{Environment}.json` files.
- Validate that any secrets (e.g., connection strings, API keys) are managed using the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.