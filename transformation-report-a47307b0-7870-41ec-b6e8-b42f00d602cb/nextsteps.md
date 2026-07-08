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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate compatibility concerns that could surface at runtime.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Runtime Compatibility Issues

Even without build errors, certain APIs or behaviors may differ between .NET Framework and modern .NET. Pay particular attention to the following areas:

- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core and that all migrations are valid.
- **Configuration**: Ensure `Web.config` settings have been moved to `appsettings.json` or environment variables, as `System.Configuration` is not supported in the same way on modern .NET.
- **HTTP Modules and Handlers**: If `Bookstore.Web` previously used any HTTP Modules or Handlers, confirm they have been replaced with ASP.NET Core middleware.
- **Global.asax**: Confirm any startup logic from `Global.asax` has been moved to `Program.cs` or `Startup.cs`.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm core functionality is intact.

---

## 6. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests currently exist, consider writing basic integration tests for the `Bookstore.Domain` and `Bookstore.Data` layers to establish a baseline before making further changes.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses a database, confirm the connection string in `appsettings.json` is correct and that the application can connect to the database at runtime. If using EF Core, apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Deprecated or Obsolete API Usage

Run a build with the `--verbosity detailed` flag and review any `CS0618` (obsolete) warnings. Address these before deploying to production to avoid future breaking changes.

```bash
dotnet build --verbosity detailed
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all necessary assets, configuration files, and binaries are present before deploying to the target environment.