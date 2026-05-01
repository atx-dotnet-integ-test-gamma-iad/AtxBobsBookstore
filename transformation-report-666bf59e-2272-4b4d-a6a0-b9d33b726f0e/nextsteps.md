# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently on cross-platform .NET compared to .NET Framework.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that:
- Interact with the database layer (`Bookstore.Data`)
- Rely on file paths, as path separators differ between Windows and Linux/macOS
- Use culture-sensitive string operations, which may behave differently across platforms

---

## 4. Verify Entity Framework or Data Access Layer

Within `Bookstore.Data`, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Any database migrations are present and up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Review Configuration Files

Check `appsettings.json` in `Bookstore.Web` to ensure:

- Connection strings are correct for the target environment
- Any configuration keys that were previously in `Web.config` have been properly migrated to `appsettings.json`
- Environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate

---

## 6. Run the Web Application Locally

Start the application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URLs printed in the console output
- Test the primary application workflows manually, such as browsing, searching, and any CRUD operations related to the bookstore domain
- Check the console and application logs for any runtime exceptions or warnings

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining platform-specific patterns that may cause issues on non-Windows environments:

- Hardcoded Windows-style file paths (e.g., `C:\` or backslash separators) — replace with `Path.Combine` or `Path.DirectorySeparatorChar`
- Use of `System.Web` namespaces, which are not available in cross-platform .NET
- Windows Registry access via `Microsoft.Win32`
- COM interop dependencies

---

## 8. Review Middleware and HTTP Pipeline

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is configured correctly:

- Authentication and authorization middleware is present if the original application required it
- Static file serving is configured via `UseStaticFiles()`
- Routing is set up correctly with `UseRouting()` and `UseEndpoints()` or top-level route registration

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent package:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.