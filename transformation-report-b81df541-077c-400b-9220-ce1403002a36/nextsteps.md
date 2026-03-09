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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Address any warnings that could indicate compatibility issues with the target framework.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `net5.0` or `net6.0`, update it to a supported version and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm whether it has been migrated from EF6 to EF Core. EF Core has different behaviors around lazy loading, migrations, and connection string configuration.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC or Web Forms project, confirm it has been correctly migrated to ASP.NET Core. Web Forms is not supported in cross-platform .NET and would require a full rewrite of affected pages.
- **Configuration**: Verify that `Web.config` or `App.config` settings have been moved to `appsettings.json` and are being read using `IConfiguration`.

---

## 5. Run Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior is preserved.

```bash
dotnet test
```

Review any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

---

## 6. Manual Functional Validation

Start the web application locally and perform manual validation of core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following areas at a minimum:

- Application starts without runtime exceptions
- Database connectivity works as expected
- Core pages and routes load correctly
- Any authentication or authorization flows function correctly
- Form submissions and data writes behave as expected

---

## 7. Review Middleware and Startup Configuration

In ASP.NET Core, application startup is configured in `Program.cs` (and optionally `Startup.cs`). Confirm the following are correctly configured:

- Middleware pipeline order (e.g., `UseAuthentication` before `UseAuthorization`)
- Static file serving via `UseStaticFiles`
- Routing via `UseRouting` and `MapControllerRoute` or `MapRazorPages`
- Database context registration via `AddDbContext`

---

## 8. Validate Database Migrations

If Entity Framework Core is used, confirm that migrations are up to date and can be applied cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

If migrations do not exist yet and the project previously used EF6 or a database-first approach, you may need to scaffold an initial migration.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.