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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Windows-Specific APIs

Even if the build succeeds, the code may still reference Windows-specific APIs that will fail at runtime on Linux or macOS. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Pay particular attention to:
- `Bookstore.Data` for any use of `System.Data` providers that may have Windows-only dependencies (e.g., older SQL Server drivers).
- `Bookstore.Web` for any use of `System.Drawing`, Windows registry access, or NTLM/Windows Authentication configurations.

---

## 5. Run Unit Tests

If the solution contains test projects, run them now to verify that business logic and data access behavior is preserved after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding to deployment.

---

## 6. Validate the Web Application Locally

Run the web application locally to confirm it starts and behaves correctly.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- Database connections in `Bookstore.Data` are established correctly. Update connection strings in `appsettings.json` if they reference legacy formats or Windows-specific authentication modes.
- All pages and API endpoints return expected responses.
- Static assets, routing, and middleware are functioning as expected.

---

## 7. Review `appsettings.json` and Configuration

Legacy projects often rely on `Web.config` or `App.config`. Confirm that all configuration values have been correctly migrated to `appsettings.json` and that environment-specific settings are handled using `appsettings.{Environment}.json` or environment variables.

---

## 8. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework, confirm that migrations are up to date and compatible with the new framework version.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before deploying to production.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present.