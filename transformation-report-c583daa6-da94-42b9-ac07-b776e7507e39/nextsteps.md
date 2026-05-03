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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some packages or APIs may only function correctly on Windows. Review the following:

- Any use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package where needed.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration tests that cover the core data access paths in `Bookstore.Data` and the primary routes in `Bookstore.Web`.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` handles persistence, verify the following:

- Entity Framework Core (or whichever ORM is in use) migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- Apply any pending migrations against a test database:

```bash
dotnet ef database update --project Bookstore.Data
```

- Confirm connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and confirm that:

- Pages load without errors
- Data is read from and written to the database correctly
- Authentication or authorization flows work as expected, if applicable

---

## 8. Review Middleware and Startup Configuration

If `Bookstore.Web` was previously an ASP.NET MVC project targeting the .NET Framework, confirm that the `Program.cs` and/or `Startup.cs` have been correctly migrated to the ASP.NET Core hosting model. Key areas to check:

- Middleware pipeline order (`app.UseRouting()`, `app.UseAuthentication()`, `app.UseAuthorization()`, etc.)
- Static file serving (`app.UseStaticFiles()`)
- Configuration providers (`appsettings.json`, environment variables)

---

## 9. Test on a Non-Windows Environment (Optional but Recommended)

Since the goal is cross-platform compatibility, if possible, run the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

---

## 10. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets are present before deploying to the target environment.