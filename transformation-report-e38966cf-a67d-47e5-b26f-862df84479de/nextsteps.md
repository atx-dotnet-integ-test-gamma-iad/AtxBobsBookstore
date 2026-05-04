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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages referenced in each project. Packages that rely on Windows-only APIs (e.g., `System.Drawing.Common` without the `EnableUnixSupport` flag, or `Microsoft.Win32.*`) may cause runtime failures on non-Windows platforms even if the build succeeds.

Use the compatibility analyzer to assist:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves correctly after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core version in use is compatible with your database provider.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm that pages load and data operations function as expected.

---

## 8. Review Configuration Files

Ensure that the following have been correctly migrated from any legacy `Web.config` or `App.config` files to the modern `appsettings.json` format:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` file in ASP.NET Core is no longer the primary configuration source and should only contain IIS-specific settings if IIS hosting is required.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all required assets, static files, and configuration files are present before deploying to the target environment.