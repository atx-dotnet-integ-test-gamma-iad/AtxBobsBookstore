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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still under active or LTS support.

---

## 4. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Check the following areas manually:

- **`System.Web` references**: These are not available in modern .NET. If any remain, they need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`, `HttpRequest`, `HttpResponse`**: Ensure these are using the `Microsoft.AspNetCore.Http` namespace, not `System.Web`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` if still in use.
- **`EntityFramework` (non-Core)**: If `Bookstore.Data` was using classic Entity Framework, confirm it has been migrated to `Microsoft.EntityFrameworkCore`.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release
```

If no test projects exist, consider writing basic tests for the domain and data layers to verify expected behavior has not changed during migration.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection by running any existing migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If no migrations exist, generate an initial migration to confirm the model is being picked up correctly:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- Application starts without exceptions.
- Database queries execute and return expected data.
- All major routes and pages load correctly.
- Static files (CSS, JS, images) are served properly.

---

## 8. Review Application Configuration

Confirm that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously in `Web.config` or `App.config`, including:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Check Logging

Verify that logging is configured correctly in `Program.cs` or `Startup.cs` using `Microsoft.Extensions.Logging`. Confirm that log output appears as expected when running the application.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.