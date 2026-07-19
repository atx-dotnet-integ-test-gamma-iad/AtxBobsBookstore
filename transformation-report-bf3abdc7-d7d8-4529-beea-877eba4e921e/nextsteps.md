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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the code and NuGet packages in all three projects for any remaining Windows-specific dependencies, such as:

- `Microsoft.Win32` registry access
- Windows-only NuGet packages
- `[SupportedOSPlatform]` warnings in the build output

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific code paths are needed.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the `.csproj` and `DbContext`.
- If Entity Framework Core is in use, verify that any pending migrations are up to date.

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Run a test migration against a development database to confirm schema compatibility.

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` before proceeding to deployment.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Verify that all pages and API endpoints load without errors.
- Check application logs for any runtime exceptions that would not have appeared at build time.
- Confirm that connection strings and configuration values in `appsettings.json` are correct for the target environment.

---

## 8. Review Configuration and Secrets

Ensure that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or environment variables. Pay particular attention to:

- Database connection strings
- Authentication settings
- Any third-party API keys

Sensitive values should not be stored in source control. Use the [.NET Secret Manager](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development secrets.

```bash
dotnet user-secrets init --project app/Bookstore.Web
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.