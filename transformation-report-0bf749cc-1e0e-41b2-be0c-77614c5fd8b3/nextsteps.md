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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used unintentionally. Run the .NET Compatibility Analyzer if it is not already part of the project:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core+)
- Windows Registry access
- Windows-specific file path assumptions

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate functional correctness:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during migration or a pre-existing issue.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following areas at a minimum:
- Application startup without exceptions
- Database connectivity through `Bookstore.Data`
- Domain logic behaving as expected through `Bookstore.Domain`
- All major routes and pages load correctly

---

## 7. Review Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are correctly configured. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used in the same way in modern .NET.

Ensure the following are accounted for:
- Connection strings
- Logging configuration
- Any custom application settings previously in `Web.config`

---

## 8. Database Migration Validation

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before targeting production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to the target environment.