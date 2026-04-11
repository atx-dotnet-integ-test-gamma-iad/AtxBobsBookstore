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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy framework, update it to a supported cross-platform target.

---

## 4. Check for Windows-Specific APIs

Even when a project builds successfully, it may contain calls to Windows-specific APIs that will fail at runtime on Linux or macOS. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Rebuild and review any new analyzer warnings that appear.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review all test results carefully. Failures that did not exist prior to migration indicate behavioral differences introduced by the framework change.

---

## 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The connection string in `appsettings.json` (or equivalent configuration) is valid and accessible from the new runtime environment.
- If Entity Framework is used, run a check to ensure migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are pending, apply them to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary workflows such as browsing, searching, and any data entry forms. Pay close attention to areas that relied on Windows-specific features in the legacy version.

---

## 8. Review Configuration and Secrets

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific values are handled using `appsettings.{Environment}.json` or environment variables.

Sensitive values such as connection strings and API keys should be stored using the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, views, and static files are present before deploying to the target environment.