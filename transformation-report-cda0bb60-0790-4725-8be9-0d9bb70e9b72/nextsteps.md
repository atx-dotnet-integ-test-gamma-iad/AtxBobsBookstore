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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas:

- **`System.Web`**: This namespace is not available in .NET. Ensure `Bookstore.Web` has been fully migrated to ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, **`HttpResponse`**: Confirm these are sourced from `Microsoft.AspNetCore.Http`, not `System.Web`.
- **Entity Framework**: If the project uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that the `Bookstore.Data` project references the appropriate EF Core packages.
- **Configuration**: Confirm that any use of `ConfigurationManager` has been replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.
- **App.config / Web.config**: These are not used in .NET for application configuration. Migrate any relevant settings to `appsettings.json`.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the main features, including any pages that interact with the data layer, to confirm end-to-end functionality.

---

## 6. Check Database Connectivity

If `Bookstore.Data` uses a database, verify the connection string in `appsettings.json` is correctly configured for your local environment. If using EF Core, apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Existing Tests

If the solution contains test projects, run them to verify that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration-related changes or pre-existing issues.

---

## 8. Perform a Runtime Smoke Test

Manually verify the following areas at runtime:

- Application startup completes without exceptions.
- Data is correctly read from and written to the database.
- All major routes and pages in `Bookstore.Web` load without errors.
- Logging output does not contain unexpected errors or warnings.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.