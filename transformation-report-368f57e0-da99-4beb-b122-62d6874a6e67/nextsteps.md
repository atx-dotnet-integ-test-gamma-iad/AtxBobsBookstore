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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for cross-platform compatible versions and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check for Windows-Specific APIs

Even without build errors, certain APIs may compile but fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to identify potential issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings and replace Windows-specific APIs with cross-platform alternatives where necessary.

### 3.2 Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is compatible with the target .NET version.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests to determine whether they indicate regressions introduced during the migration or pre-existing issues.

---

## 5. Manual Smoke Testing

Start the web application locally and perform basic functional verification:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without exceptions.
- Core routes and pages load correctly.
- Data reads and writes function as expected against the database.
- Any authentication or session handling behaves correctly.

---

## 6. Review Configuration Files

Ensure the following configuration concerns are addressed:

- `appsettings.json` and `appsettings.Production.json` contain the correct values for the target environment.
- Any configuration that was previously stored in `Web.config` or `App.config` has been migrated to the appropriate `appsettings.json` structure or environment variables.
- Logging configuration is set up correctly using the `Microsoft.Extensions.Logging` infrastructure.

---

## 7. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.