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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference older .NET Framework-specific libraries, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Domain Layer (`Bookstore.Domain`)

Since `Bookstore.Domain` is the most independent project, start validation here:

- Confirm that all domain models, interfaces, and business logic compile and behave as expected.
- If unit tests exist for this layer, run them in isolation:

```bash
dotnet test Bookstore.Domain
```

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Verify that the database context and entity configurations are correct.
- If the project uses Entity Framework Core, confirm the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Check that any existing migrations are still valid:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- If migrations are missing or broken, consider creating a new initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify that key pages load correctly.
- Check that any configuration previously stored in `Web.config` has been properly migrated to `appsettings.json`. Pay particular attention to:
  - Connection strings
  - Application settings
  - Authentication configuration

---

## 6. Run All Tests

If the solution contains a test project, execute the full test suite:

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration issues or pre-existing defects.

---

## 7. Review Platform-Specific Code

Search the codebase for any APIs that may not be supported on non-Windows platforms if cross-platform deployment is intended. Common areas to check include:

- Use of `System.Web` namespaces (should have been replaced during transformation)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext.Current` usage, which should be replaced with dependency-injected `IHttpContextAccessor`

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.