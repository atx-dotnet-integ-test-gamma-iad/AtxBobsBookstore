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

The steps below cover how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` or the current LTS release.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that any Entity Framework or data access configuration has been updated:

- If using **Entity Framework Core**, ensure the correct EF Core NuGet packages are referenced and that migrations are up to date.
- Run the following to verify migrations are in sync with the model:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema has changed, apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify functional correctness:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` references**: These are not available in .NET Core/5+. Ensure `Bookstore.Web` is using ASP.NET Core equivalents.
- **`HttpContext`**: Accessed via dependency injection in ASP.NET Core, not as a static property.
- **`ConfigurationManager`**: Replaced by `Microsoft.Extensions.Configuration`. Verify `appsettings.json` is being used instead of `Web.config` or `App.config`.
- **`Global.asax`**: Should be replaced by `Program.cs` and `Startup.cs` (or the minimal hosting model in .NET 6+).

---

## 8. Review Application Configuration

Confirm that `appsettings.json` contains all necessary configuration values that were previously in `Web.config`, including:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 9. Validate Static Files and Views

If `Bookstore.Web` uses Razor views or static assets:

- Confirm that the `wwwroot` folder contains all required static files (CSS, JavaScript, images).
- Verify that Razor views render correctly by navigating through the application UI.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.