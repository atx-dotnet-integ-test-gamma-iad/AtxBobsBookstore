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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (for example, `net8.0`). Mixing framework versions between projects can cause compatibility issues at runtime even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even with a clean build, certain APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Confirm that `Bookstore.Web` has been fully migrated away from `System.Web` (e.g., `HttpContext`, `HttpRequest`) to their `Microsoft.AspNetCore` equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that the database provider package is correctly referenced.
- **Configuration**: Confirm that `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` system.
- **Windows-only APIs**: If any project uses APIs such as the Windows Registry, WCF, or Windows-specific authentication, those will require additional attention for cross-platform compatibility.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that the business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly after migration.

```bash
dotnet test
```

If no tests currently exist, consider writing basic integration or unit tests for critical paths such as data retrieval and domain logic before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary features, including:

- Page rendering and routing
- Database read and write operations
- Authentication and authorization flows, if applicable
- Any file system operations

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that the connection string in `appsettings.json` is correctly configured for the target environment and that any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target hosting environment, such as IIS, a Linux server with the ASP.NET Core runtime installed, or Azure App Service.

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the server and that the application pool is configured to use **No Managed Code**.