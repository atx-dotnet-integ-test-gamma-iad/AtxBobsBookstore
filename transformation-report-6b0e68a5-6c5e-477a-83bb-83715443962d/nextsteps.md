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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not block the build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET)
- `HttpContext` and related types (replaced by `Microsoft.AspNetCore.Http`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `App.config` or `Web.config` usage (replaced by `appsettings.json`)

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate that core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests for critical domain logic and data access methods before proceeding further.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correctly configured.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database schema matches the current model definitions.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors
- Data is read from and written to the database correctly
- Authentication and authorization (if applicable) function as expected

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review the `Program.cs` (or `Startup.cs` if still present) to confirm that middleware is registered correctly for modern ASP.NET Core. Ensure the following are configured where applicable:

- Routing (`app.UseRouting()`)
- Authentication and Authorization (`app.UseAuthentication()`, `app.UseAuthorization()`)
- Static files (`app.UseStaticFiles()`)
- Exception handling (`app.UseExceptionHandler()` or `app.UseDeveloperExceptionPage()`)

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.