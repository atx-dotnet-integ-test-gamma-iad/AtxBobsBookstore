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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or libraries, particularly in `Bookstore.Data` and `Bookstore.Web`. Common areas to check include:

- Use of `System.Web` (not available in .NET Core/5+)
- Windows registry access
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any P/Invoke calls targeting Windows-only native libraries

---

## 5. Database and Data Layer Validation

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm it has been migrated to **Entity Framework Core**.
- Run any pending migrations against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm connection strings in `appsettings.json` are correctly configured and no longer rely on `Web.config` or `App.config` entries.

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test
```

If no test project currently exists, consider writing tests that cover the primary data access methods in `Bookstore.Data` and the domain logic in `Bookstore.Domain` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) contain all necessary configuration values that were previously stored in `Web.config`. Key areas include:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.