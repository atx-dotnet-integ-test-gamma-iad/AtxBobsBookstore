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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their cross-platform equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Check that configuration files have been properly migrated:

- Ensure `Web.config` or `App.config` values have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Verify that connection strings in `appsettings.json` are correct and point to the intended database.
- Confirm that any environment-specific settings are handled using the `IConfiguration` interface and the appropriate environment variable or file.

---

## 4. Verify Entity Framework or Data Layer

If the `Bookstore.Data` project uses Entity Framework, confirm the following:

- The correct version of EF Core is referenced (not EF 6, unless intentionally retained).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior remain intact after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- Serialization behavior
- Globalization and encoding defaults
- HTTP client usage
- Thread culture settings

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization behave correctly if applicable.

---

## 7. Check for Runtime Compatibility Issues

Even with a clean build, certain issues may only appear at runtime. Pay attention to:

- Any use of `System.Web` APIs that may have been replaced with ASP.NET Core equivalents. Confirm replacements are functioning correctly.
- File path handling, as .NET on Linux/macOS uses forward slashes. Use `Path.Combine` consistently throughout the codebase.
- Any reflection-based code or dynamic loading that may behave differently under modern .NET.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present.