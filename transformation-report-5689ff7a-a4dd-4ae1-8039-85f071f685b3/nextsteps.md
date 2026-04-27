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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output for any failures. If tests were written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), those tests may require updates to work correctly under cross-platform .NET.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to specifically validate include:

- **Database connectivity** – Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Configuration** – Confirm that settings previously in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Authentication and Authorization** – If any forms-based authentication or Windows authentication was in use, verify that the equivalent ASP.NET Core middleware is configured correctly.
- **Static files and routing** – Confirm that pages, routes, and static assets resolve as expected in the browser.

---

## 5. Review Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are absent or behave differently in cross-platform .NET:

- `System.Web` references – These are not available in cross-platform .NET and must be replaced with ASP.NET Core equivalents.
- `ConfigurationManager` – Should be replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.
- Registry access, COM interop, or Windows-only APIs – These will not function on non-Windows platforms and should be conditionally compiled or replaced.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another .NET Framework moniker, update it to the appropriate cross-platform target.

---

## 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assemblies, configuration files, and static assets are present before deploying to the target environment.