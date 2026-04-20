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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the chosen version is under active support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured correctly and that any connection strings are environment-agnostic.
- **`Bookstore.Web`**: Check for any usage of `System.Web`, Windows Authentication, or MSMQ, which do not have direct cross-platform equivalents.
- **`Bookstore.Domain`**: Confirm no platform-specific file path separators or registry access is used.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic integration or smoke tests that cover:

- Database connectivity and basic CRUD operations via `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Validate the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Key pages or API endpoints return expected responses.
- Database migrations (if using Entity Framework Core) have been applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Validate Configuration Files

Review `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) to ensure:

- Connection strings are correct for the target environment.
- Any configuration previously stored in `Web.config` or `App.config` has been migrated to the appropriate `appsettings.json` structure.
- Sensitive values are stored using environment variables or a secrets manager rather than hardcoded in configuration files.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and dependencies are present before deploying to the target environment.