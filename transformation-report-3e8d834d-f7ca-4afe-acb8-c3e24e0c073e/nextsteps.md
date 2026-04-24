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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is correctly configured for the target platform.
- Verify that database connection strings in `appsettings.json` are accurate for your environment.
- If Entity Framework Core is used, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic classes for any use of APIs that were available in .NET Framework but behave differently or are absent in cross-platform .NET.
- Pay particular attention to types from namespaces such as `System.Web`, `System.Drawing`, or `System.Security` that may have changed.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (if present) follow the ASP.NET Core conventions appropriate for your target framework version.
- Check that middleware, routing, authentication, and authorization configurations are correct.
- Verify that any static files, Razor views, or Blazor components render without errors.
- Run the application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the locally hosted URL and manually verify core functionality such as browsing, searching, and any account-related features.

---

## 7. Run Automated Tests

If the solution contains a test project, execute the test suite to validate that existing behavior has been preserved after migration.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 8. Check for Platform-Specific Code

Use the .NET Compatibility Analyzer or review the code manually for any remaining platform-specific APIs. The following command can help surface compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay attention to analyzer warnings prefixed with `CA1416`, which indicate platform-specific API usage.

---

## 9. Deploy to the Target Environment

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment and configure the web server (e.g., IIS with the ASP.NET Core Hosting Bundle, or Nginx/Apache on Linux) to serve the application.