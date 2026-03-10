# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore and Build the Solution

Run the following commands from the root of the solution to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure there are no warnings that could indicate compatibility issues, such as deprecated APIs or target framework mismatches.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks (e.g., `net6.0` in one project and `net8.0` in another) can cause subtle runtime issues.

---

## 3. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the EF Core version is appropriate and that any database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced correctly.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is configured correctly for ASP.NET Core, including authentication, authorization, and static files.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or culture-sensitive operations behave as expected on cross-platform .NET.

---

## 4. Run Existing Tests

If the solution contains a test project, run the tests using:

```bash
dotnet test
```

If no tests currently exist, consider writing basic integration or unit tests for critical paths such as:

- Database read/write operations in `Bookstore.Data`
- Domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected.
- Key pages and features (e.g., browsing books, user authentication if applicable) function correctly.
- Static assets (CSS, JavaScript, images) are served properly.

---

## 6. Verify Configuration Files

Check `appsettings.json` (and `appsettings.Development.json`) to ensure:

- Connection strings are valid and point to the correct database.
- Any configuration keys that were previously in `Web.config` have been migrated to the appropriate `appsettings.json` entries.
- Environment-specific settings are correctly separated.

---

## 7. Validate Database Migrations

If Entity Framework Core is used with migrations, confirm the migration state is consistent:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.