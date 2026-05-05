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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, confirm that the correct EF Core version is referenced and that any existing migrations are compatible.
- Run the following to check pending migrations or apply them to a local database:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Verify that connection strings in configuration files (e.g., `appsettings.json`) are correct and accessible in the new environment.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain models, interfaces, or business logic classes for use of APIs that may behave differently under cross-platform .NET (e.g., `System.Drawing`, file path handling, culture-sensitive operations).
- Confirm that no Windows-specific libraries are referenced without a cross-platform alternative.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Start the web application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application in a browser and verify that core functionality works as expected, including:
  - Page rendering
  - Form submissions
  - Database reads and writes
  - Authentication and authorization, if applicable

- Check that static files, views, and configuration files (e.g., `appsettings.json`, `appsettings.Development.json`) are present and correctly structured.

---

## 7. Review Configuration and Environment Settings

- Confirm that any settings previously stored in `Web.config` have been migrated to `appsettings.json`.
- Verify that environment-specific configuration (e.g., development vs. production connection strings) is properly handled using the `ASPNETCORE_ENVIRONMENT` environment variable.

---

## 8. Check for Platform-Specific Code

Use the .NET Compatibility Analyzer or review the code manually for any remaining platform-specific APIs. Common areas to check include:

- File system path separators (`\` vs `/`) — use `Path.Combine` instead of hardcoded separators.
- Registry access (`Microsoft.Win32.Registry`) — not available on Linux/macOS.
- Windows-specific authentication mechanisms.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm it produces a deployable output:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.