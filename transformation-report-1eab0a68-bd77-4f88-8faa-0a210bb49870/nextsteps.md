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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify this is consistent across all three projects to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas manually:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. Ensure `Bookstore.Web` has been fully migrated to ASP.NET Core equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been updated to Entity Framework Core.
- **Configuration**: Verify that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` system.
- **Authentication/Authorization**: Confirm any membership or identity providers have been migrated to ASP.NET Core Identity if applicable.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test
```

If no test projects exist, consider manually verifying the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` by running the application and exercising key workflows.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify the following:

- Pages load without HTTP 500 errors.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Any static files (CSS, JS, images) are served correctly.
- Authentication and authorization flows work as expected.

---

## 7. Validate the Database Connection

Open `appsettings.json` in `Bookstore.Web` and confirm the connection string is correctly configured for your target database:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=your_server;Database=your_db;User Id=your_user;Password=your_password;"
}
```

If using Entity Framework Core, apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to your target environment.