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

Review the output for any warnings about deprecated packages or version conflicts. If any packages reference old `net4x` target frameworks, consider finding their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions are approaching or have reached end-of-life.

---

## 4. Verify Database Configuration

Since `Bookstore.Data` is present, confirm the following:

- The connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for the target database.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and manually verify that core functionality, such as browsing, searching, and any data-driven pages, behaves correctly.

---

## 6. Run Automated Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

Review the results for any failing tests. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime that need to be addressed.

---

## 7. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present in cross-platform .NET. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage patterns, which may need to be updated for ASP.NET Core.
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (use `System.Drawing.Common` with awareness of its platform limitations).

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can help identify remaining compatibility issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.