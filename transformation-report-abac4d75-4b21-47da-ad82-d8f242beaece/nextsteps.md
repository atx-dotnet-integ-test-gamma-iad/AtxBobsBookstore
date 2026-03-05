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

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or libraries, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining platform-specific code.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the displayed local URL in a browser.
- Verify that pages load correctly and that data access through `Bookstore.Data` and `Bookstore.Domain` functions as expected.

---

## 6. Validate Data Access

If `Bookstore.Data` uses Entity Framework Core, verify the database connection and schema:

1. Confirm the connection string in `appsettings.json` is correct for your environment.
2. If migrations are used, apply them:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

3. Test basic CRUD operations through the application to confirm data access is working.

---

## 7. Run Existing Tests

If the solution contains test projects, run them to validate business logic and data layer behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Cross-Platform Validation

If cross-platform support is a requirement, run the application on a non-Windows environment (Linux or macOS) to confirm there are no hidden platform-specific runtime issues. Pay attention to:

- File path separators
- Case-sensitive file system behavior
- Environment variable usage

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.