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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting an older version such as `net6.0` or `net7.0`, consider upgrading to `net8.0` as it is the current Long-Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used that would break cross-platform compatibility. Run the .NET Compatibility Analyzer if it is not already included:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- Windows-specific file path assumptions

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic, verify the following:

- **Entity Framework Core**: If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core. Check that the `DbContext` and entity configurations are compatible.
- **Connection Strings**: Confirm that connection strings in `appsettings.json` are correctly configured for the target environment.
- **Migrations**: If using EF Core migrations, verify existing migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer

Run the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions
- Routing behaves as expected
- Authentication and authorization (if present) function correctly
- Static files are served properly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common items to verify include:

- Database connection strings
- Logging configuration
- Application-specific settings

---

## 9. Manual Smoke Testing

Before deploying to any environment, perform manual smoke testing of the key user-facing features of the bookstore application, such as:

- Browsing and searching for books
- Viewing book details
- Any checkout or ordering workflows
- Administrative functions, if applicable

---

## 10. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target server or hosting environment.