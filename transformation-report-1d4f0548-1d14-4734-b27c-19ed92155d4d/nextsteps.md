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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET compared to .NET Framework. Pay particular attention to the following areas:

- **`System.Web` references**: These are not available in cross-platform .NET. If any code relied on `System.Web` (e.g., `HttpContext`, `HttpRequest`), confirm it has been replaced with the ASP.NET Core equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that the `DbContext` configuration is correct.
- **Configuration**: Confirm that `Web.config`-based configuration has been replaced with `appsettings.json` and the `IConfiguration` pattern.
- **Authentication/Authorization**: If the legacy project used ASP.NET Membership or Forms Authentication, verify these have been replaced with ASP.NET Core Identity or cookie authentication middleware.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` to establish a baseline before making further changes.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following manually:

- The application starts and the home page loads.
- Database connectivity works (if applicable, run any pending EF Core migrations with `dotnet ef database update`).
- Core user-facing workflows (e.g., browsing books, user authentication) function as expected.
- Review application logs for any runtime warnings or errors.

---

## 7. Review `appsettings.json` and Environment Configuration

Confirm that connection strings, API keys, and other environment-specific settings have been correctly moved from `Web.config` to `appsettings.json` or environment variables.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

Ensure sensitive values are not committed to source control. Use `appsettings.Development.json` for local overrides or the .NET secrets manager:

```bash
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your-connection-string-here"
```

---

## 8. Validate Static Files and Razor Views

If `Bookstore.Web` uses Razor views or serves static files, confirm the following:

- Static files (CSS, JS, images) are located in the `wwwroot` folder.
- Razor views render correctly and do not reference removed HTML helpers that are unavailable in ASP.NET Core.
- Bundling and minification, if used, has been replaced with a supported approach (e.g., LibMan or a build tool).

---

## 9. Deploy to a Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` folder to your target server. Ensure the server has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

Configure the web server (IIS or Nginx/Apache on Linux) to host the application. For IIS, ensure the ASP.NET Core Hosting Bundle is installed and the application pool is set to **No Managed Code**.