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

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues even if the build succeeds.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed behavior in modern .NET. Run the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any potential runtime incompatibilities:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

Pay particular attention to:
- `System.Web` usages, which are not available in cross-platform .NET
- Any Windows-specific APIs if cross-platform support is required
- Entity Framework version compatibility in `Bookstore.Data`

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate functional correctness:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences between .NET Framework and the new target framework.

If no tests currently exist, consider writing integration or unit tests covering the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that database connectivity is functioning correctly:

1. Confirm the connection string in your configuration file (`appsettings.json`) is correct for the target environment.
2. If using Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

3. If migrating from Entity Framework 6 to Entity Framework Core, review the [EF Core migration guide](https://learn.microsoft.com/en-us/ef/efcore-and-ef6/porting/) as there are breaking changes between the two.

---

## 7. Run the Web Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify key functionality such as:
- Page rendering
- Data retrieval and display
- Form submissions
- Authentication and authorization, if applicable

---

## 8. Review Configuration Changes

.NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All configuration values have been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms have been replaced with environment-specific `appsettings.{Environment}.json` files.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately for each environment (`Development`, `Staging`, `Production`).

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.

---

## 10. Deploy to Target Environment

Copy the published output to your target server or hosting environment and ensure the correct version of the .NET runtime is installed on that machine:

```bash
dotnet --list-runtimes
```

If the required runtime is not present, download and install it from the [official .NET download page](https://dotnet.microsoft.com/en-us/download).