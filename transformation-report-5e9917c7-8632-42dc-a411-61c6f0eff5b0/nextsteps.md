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

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference APIs that only function on Windows. Run the .NET compatibility analyzer to surface any such usages:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay close attention to analyzer warnings prefixed with `CA1416` (platform compatibility). Common problem areas include:
- Registry access
- Windows-specific authentication providers
- `System.Drawing` (GDI+)

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations against a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is valid and appropriate for the target environment.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core workflows, including:
- Browsing and searching for books
- Any authentication or user account flows
- Data read and write operations

Check the console output and application logs for any unhandled exceptions or deprecation warnings.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and the new .NET runtime rather than regressions in the code itself.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) for the following:

- Middleware that was migrated from `System.Web` should now use ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages should reference `Microsoft.AspNetCore.Http` types.
- Any `Global.asax` logic should have been moved into the ASP.NET Core request pipeline.

---

## 9. Validate Static Files and Views

Confirm that static assets (CSS, JavaScript, images) are located under `wwwroot` and are being served correctly. If the project used Razor Views or Razor Pages, verify they render without errors by navigating through the application UI.