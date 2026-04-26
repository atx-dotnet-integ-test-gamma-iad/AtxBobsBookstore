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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and valid, apply them to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify the following:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected
- Static assets (CSS, JavaScript, images) are served correctly

---

## 6. Review Framework-Specific Changes

Cross-platform .NET differs from .NET Framework in several areas. Manually review the following:

- **Configuration**: Ensure `Web.config` settings have been migrated to `appsettings.json` and the appropriate `IConfiguration` usage in code.
- **HTTP Pipeline**: Confirm that any custom HTTP modules or handlers from the legacy project have been replaced with ASP.NET Core middleware.
- **Session and Caching**: Verify that session state and caching mechanisms are configured using ASP.NET Core equivalents.
- **Logging**: Confirm that any legacy logging frameworks have been replaced or integrated with `Microsoft.Extensions.Logging`.

---

## 7. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy the contents to your target hosting environment (e.g., IIS, Azure App Service, or a Linux server with the ASP.NET Core runtime installed).

---

## 8. Configure the Hosting Environment

- **IIS**: Install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server and configure the application pool to use "No Managed Code".
- **Linux**: Ensure the correct .NET runtime version is installed and configure a reverse proxy (such as Nginx or Apache) if required.
- **Environment Variables**: Set the `ASPNETCORE_ENVIRONMENT` variable appropriately (e.g., `Production`) on the target server.