# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, certain APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Confirm `Bookstore.Web` has fully migrated to ASP.NET Core equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been updated to Entity Framework Core and that migrations are compatible.
- **Configuration**: Ensure `Web.config` has been replaced with `appsettings.json` and that configuration is wired up through `IConfiguration`.
- **Authentication/Authorization**: Confirm any membership or identity providers have been migrated to ASP.NET Core Identity if applicable.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior after migration.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application workflows function correctly (e.g., browsing books, user authentication if applicable).

---

## 7. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Logging and Error Handling

Confirm that logging has been configured using the ASP.NET Core logging abstractions (`ILogger<T>`). Legacy logging frameworks (e.g., `log4net`, `NLog`) may need updated configuration files or adapters compatible with .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.