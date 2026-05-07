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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that need further modernization.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed behavior in cross-platform .NET. Review the following areas manually:

- **`Bookstore.Data`**: If Entity Framework is used, confirm it has been migrated to EF Core. EF6 is not fully supported on cross-platform .NET.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Web Forms is not supported on cross-platform .NET.
- **`Bookstore.Domain`**: Check for any usage of `System.Configuration.ConfigurationManager`, `AppDomain`, or other APIs that behave differently or require additional NuGet packages on cross-platform .NET.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and verify that the application loads and functions as expected.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` connects to a database, confirm the connection string in `appsettings.json` is correctly configured for the target environment. On cross-platform .NET, connection strings are typically stored in `appsettings.json` rather than `Web.config` or `App.config`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Your connection string here"
  }
}
```

If EF Core is in use, apply any pending migrations to confirm the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 7. Execute Any Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET that need to be addressed.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm that all required middleware and services are registered correctly. Common items to verify include:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Dependency injection registrations for services defined in `Bookstore.Domain` and `Bookstore.Data`

---

## 9. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.