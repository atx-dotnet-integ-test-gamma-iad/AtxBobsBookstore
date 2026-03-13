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

Review the output for any warnings about deprecated or incompatible package versions. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Configuration

Check the following configuration files for correctness in the context of cross-platform .NET:

- **`appsettings.json`** – Ensure connection strings, logging settings, and any environment-specific values are correct.
- **`Program.cs` / `Startup.cs`** – Confirm the application bootstrapping code is using the modern .NET hosting model. If `Startup.cs` still exists, consider consolidating it into `Program.cs` using the minimal hosting API introduced in .NET 6+.
- **`Bookstore.Data` project** – Verify the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is the correct version for the target .NET runtime.

---

## 4. Run Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible and apply them to a test database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)
- Any file I/O or path-dependent code works correctly across operating systems (watch for hardcoded backslashes in file paths)

---

## 6. Execute Automated Tests

If a test project exists in the solution, run the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

If no automated tests exist, consider writing unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` before proceeding to production deployment.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or patterns that may cause issues on non-Windows environments:

- `System.Web` references (should have been replaced during transformation)
- `Registry` access via `Microsoft.Win32`
- Windows-specific file path separators (`\` instead of `Path.Combine`)
- `HttpContext.Current` usage (not available in ASP.NET Core)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Copy the contents of the `./publish` directory to the target server and configure the web server (IIS, Nginx, or Kestrel as a service) to host the application.