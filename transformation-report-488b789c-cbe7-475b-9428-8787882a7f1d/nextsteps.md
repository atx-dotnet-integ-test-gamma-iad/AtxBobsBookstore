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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package version conflicts or unsupported target frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while not errors, may indicate deprecated APIs or compatibility concerns that should be addressed before going further.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues between assemblies.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`, such as data access logic and domain model behavior.

---

## 5. Validate Database Connectivity

Since `Bookstore.Data` is present, verify that the data layer connects correctly to the database:

- Check the connection string in `appsettings.json` or `appsettings.Development.json` within `Bookstore.Web`.
- If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas for any runtime issues that would not appear as build errors:

- **`System.Web` dependencies**: These are not available in .NET. Confirm that any HTTP context, session, or caching logic has been replaced with ASP.NET Core equivalents.
- **Configuration**: Ensure `Web.config` settings have been migrated to `appsettings.json` and that the configuration system is wired up correctly in `Program.cs`.
- **Authentication and Authorization**: If the application uses forms authentication or Windows authentication, verify the ASP.NET Core middleware is configured correctly.

---

## 8. Check for Platform-Specific Behavior

Since the goal is cross-platform compatibility, run the application on the target operating system (Linux or macOS if applicable) to surface any remaining platform-specific issues such as:

- File path separators
- Registry access (not available on non-Windows platforms)
- Windows-only NuGet packages

---

## 9. Publish the Application

Once validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and dependencies are present.