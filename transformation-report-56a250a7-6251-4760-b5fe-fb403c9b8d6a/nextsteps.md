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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against .NET Framework-specific behaviors, some may require updates to align with cross-platform .NET semantics.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- The connection string in your configuration file (e.g., `appsettings.json`) is correct for your target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

---

## 5. Validate Runtime Behavior of Bookstore.Web

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually or through existing integration tests:

- Application startup without exceptions
- Routing and page rendering
- Authentication and authorization flows, if present
- Any file system operations that may have relied on Windows-specific paths

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on cross-platform .NET. Review the codebase for:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET
- Windows Registry access
- Windows-specific file path separators (use `Path.Combine` and `Path.DirectorySeparatorChar` where applicable)
- `ConfigurationManager` usage, which should be replaced with `Microsoft.Extensions.Configuration`

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can help identify remaining platform-specific issues.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a currently supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is within its support window.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to your target environment.