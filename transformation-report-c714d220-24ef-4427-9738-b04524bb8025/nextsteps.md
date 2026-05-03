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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Runtime Compatibility Issues

Some APIs that compiled successfully may behave differently or throw exceptions at runtime. Pay particular attention to:

- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core version is referenced and that migrations are up to date. Run:
  ```bash
  dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
  ```
- **Configuration**: Verify that `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings previously held in `Web.config` or `App.config`.
- **Authentication/Authorization**: If any Windows-specific authentication mechanisms were in use, confirm they have been replaced with ASP.NET Core-compatible equivalents.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary features, particularly any database-driven pages, to confirm data access through `Bookstore.Data` and domain logic in `Bookstore.Domain` are functioning correctly.

---

## 6. Execute Existing Tests

If a test project exists in the solution, run all tests to validate correctness:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 7. Validate the Database

If the application uses a database, confirm the following:

- The connection string in `appsettings.json` points to the correct database instance.
- Any pending EF Core migrations are applied:
  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```
- Data reads and writes function correctly through the running application.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including `appsettings.json` and static assets, are present before deploying to the target environment.