# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Repeat this check for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 2. Restore NuGet Packages

Run the following command from the solution root to ensure all dependencies are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. Replace any packages that target only `.NET Framework` with their cross-platform equivalents where necessary.

---

## 3. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 4. Run the Test Suite

If the solution contains a test project, execute all tests to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider writing unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` before proceeding further.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The database can be reached and updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Review Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains valid configuration, including connection strings and any environment-specific settings that may have previously lived in `Web.config` or `App.config`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

Ensure that any `Web.config` or `App.config` entries that are still required have been migrated to the appropriate `appsettings.json` or middleware configuration.

---

## 7. Run the Application Locally

Start the web application and perform manual verification of core workflows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:
- Pages load without errors.
- Database reads and writes function correctly.
- Authentication and authorization behave as expected, if applicable.

---

## 8. Check for Platform-Specific Code

Search the solution for any APIs that are Windows-specific and may not function correctly on Linux or macOS. Common examples include:

- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access
- COM interop

Use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 9. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider (e.g., Serilog, NLog). Remove any dependencies on `System.Diagnostics.Trace` or legacy logging frameworks that may not behave consistently across platforms.

---

## 10. Deploy to Target Environment

Once all validation steps above pass:

1. Publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

2. Copy the contents of the `./publish` directory to the target server or hosting environment.
3. Ensure the target machine has the correct .NET runtime installed. You can verify the required version with:

```bash
dotnet --list-runtimes
```