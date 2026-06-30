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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime compatibility issues.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` usages** — this namespace is not available in cross-platform .NET. Any remaining references should be replaced with ASP.NET Core equivalents.
- **Entity Framework** — if the project uses Entity Framework 6, consider whether migration to Entity Framework Core is required or already completed.
- **Configuration** — `System.Configuration.ConfigurationManager` has limited support. Ensure configuration has been migrated to `appsettings.json` and `IConfiguration`.
- **HTTP context and session** — verify that any access to `HttpContext`, `Session`, or `Request` uses the ASP.NET Core patterns.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally and manually verify key functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas:

- Application starts without runtime exceptions
- Database connectivity works as expected (run any pending migrations if using EF Core)
- Key pages and routes load correctly
- Forms submit and persist data correctly

If using EF Core, apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Review Logging and Error Handling

Ensure that logging is configured correctly using the built-in `Microsoft.Extensions.Logging` infrastructure. Check `Program.cs` or `Startup.cs` for logging setup and confirm that errors will be surfaced appropriately in the target environment.

---

## 8. Validate Configuration and Environment Settings

Confirm that all settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and that environment-specific overrides (e.g., `appsettings.Production.json`) are in place for connection strings and other sensitive values.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.