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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their latest stable versions using:

```bash
dotnet list package --outdated
dotnet add package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs or libraries remain in use. Run the compatibility analyzer:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Alternatively, review the code manually for usages of APIs such as:
- `System.Web`
- `System.Windows.Forms`
- `Microsoft.Win32` (where not needed)
- Any P/Invoke calls targeting Windows-only system libraries

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (not EF6) is being used, as EF6 does not fully support cross-platform .NET.
- Verify the database provider package is correct for your target database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify functional correctness after migration:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences introduced by the migration. Pay particular attention to:
- Date and time handling
- String encoding and culture-sensitive operations
- File path separators (use `Path.Combine` rather than hardcoded separators)

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate through the application and verify all pages render correctly.
- Check for any runtime exceptions in the console output.
- Confirm that database connectivity is functioning as expected.
- Review the `appsettings.json` and `appsettings.Production.json` files to ensure connection strings and configuration values are correct for your environment.

---

## 8. Review `Program.cs` and Startup Configuration

If the project was migrated from an older ASP.NET Core version (e.g., using `Startup.cs`), confirm the application has been updated to use the minimal hosting model introduced in .NET 6:

```csharp
var builder = WebApplication.CreateBuilder(args);
// Register services
var app = builder.Build();
// Configure middleware
app.Run();
```

Ensure middleware ordering is correct, particularly for authentication, authorization, routing, and static files.

---

## 9. Verify Static Files and Assets

Confirm that any static files (CSS, JavaScript, images) are located under the `wwwroot` folder and are being served correctly. Check that `app.UseStaticFiles()` is present in the middleware pipeline.

---

## 10. Publish the Application

Once all validation steps have passed, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.