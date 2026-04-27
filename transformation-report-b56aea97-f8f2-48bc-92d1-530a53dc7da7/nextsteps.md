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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update the target framework and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no remaining dependencies rely on Windows-only APIs (e.g., the registry, `System.Web`, COM interop, or WCF). You can use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this.

For `Bookstore.Web` specifically, confirm that any middleware, authentication, or session handling has been migrated from `System.Web` to the ASP.NET Core equivalents.

---

## 5. Database and Data Layer Validation

For `Bookstore.Data`, verify the following:

- If Entity Framework is in use, confirm it has been migrated from EF 6 to EF Core.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages or API endpoints that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 8. Review Application Configuration

Compare the old `Web.config` or `App.config` files (if retained) against the new `appsettings.json` to ensure all configuration values have been carried over, including:

- Connection strings
- Application settings
- Logging configuration
- Authentication settings

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory or server.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.