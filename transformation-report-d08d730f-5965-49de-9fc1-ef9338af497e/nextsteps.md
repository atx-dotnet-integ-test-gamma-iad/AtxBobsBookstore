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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under .NET compared to the legacy .NET Framework.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If there are no existing tests, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate Data Access Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is targeting the correct provider package for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer` instead of the legacy `EntityFramework` package).
- Run any pending migrations or verify the database schema is still compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Test database connectivity against a local or development database instance to confirm queries execute as expected.

---

## 5. Validate the Web Application (`Bookstore.Web`)

- Check that `Bookstore.Web` is targeting the correct ASP.NET Core framework (e.g., `net8.0`).
- Confirm that any configuration previously stored in `Web.config` has been migrated to `appsettings.json` and that `Program.cs` or `Startup.cs` correctly reads those values.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that core functionality such as browsing, searching, and any authentication flows work correctly.

---

## 6. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining Windows-specific API calls that may not behave correctly on Linux or macOS:

```bash
dotnet tool install -g dotnet-compatibility
```

Pay particular attention to:
- File path handling (use `Path.Combine` rather than hardcoded backslashes)
- Registry access (not available cross-platform)
- Any use of `System.Web` types that may have been carried over

---

## 7. Review `Bookstore.Domain`

Since `Bookstore.Domain` is the most independent project, verify that:
- All domain models are plain C# classes with no legacy framework dependencies.
- Any data annotations or validation attributes reference `System.ComponentModel.DataAnnotations` and not a legacy namespace.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.