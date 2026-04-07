# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually verify core application functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to verify include:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Validate that business rules in `Bookstore.Domain` behave as expected.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been migrated to `appsettings.json`.
- Any environment-specific settings are handled using `appsettings.{Environment}.json` files.
- Secrets are not stored in source-controlled configuration files. Consider using the [.NET Secret Manager](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development.

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that existed in .NET Framework may behave differently or have reduced functionality on cross-platform .NET. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific authentication mechanisms
- Any P/Invoke calls targeting Windows-only native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 7. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.