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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime, such as changes in:

- Globalization and culture handling
- File path separators
- Reflection behavior
- Entity Framework query translation (if applicable)

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- The connection string in your configuration file (`appsettings.json`) is correct and accessible from the new runtime environment.
- If Entity Framework is used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target .NET version.

---

## 5. Review Configuration Files

The legacy `Web.config` or `App.config` files are not used in cross-platform .NET. Confirm that all necessary configuration values have been moved to `appsettings.json` or environment variables, including:

- Connection strings
- Application settings
- Logging configuration

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas at a minimum:

- Application startup with no unhandled exceptions
- Navigation and page rendering
- Data retrieval and persistence operations
- Authentication and authorization flows, if present

---

## 7. Review Middleware and HTTP Pipeline

In cross-platform .NET, the HTTP pipeline is configured in `Program.cs` (and optionally `Startup.cs`). Confirm that the middleware order is correct, particularly:

- Authentication middleware is registered before authorization middleware
- Static files middleware is present if the application serves static assets
- Error handling middleware is in place

---

## 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or libraries that may not function correctly on Linux or macOS if cross-platform deployment is intended. Common areas include:

- `Microsoft.Win32` namespace usage
- Windows registry access
- COM interop
- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed)

---

## 9. Publish the Application

Once validation is complete, publish the application using the following command:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.