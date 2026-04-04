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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netcoreapp3.1`, update it to a current supported version and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- COM interop

These will not function correctly on Linux or macOS. Replace them with cross-platform equivalents where applicable.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- The database provider (e.g., Entity Framework Core) is correctly configured for the target database.
- Connection strings are stored in `appsettings.json` and not hardcoded.
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the terminal output and verify that core functionality, such as browsing, searching, and any data-driven pages, works as expected.

---

## 7. Review Configuration and Middleware

Open `Program.cs` (and `Startup.cs` if it still exists) in `Bookstore.Web` and confirm:

- Middleware is registered using the current `WebApplication` builder pattern introduced in .NET 6+.
- Authentication, authorization, and routing are configured correctly.
- Static files, session, and any custom middleware are functioning as expected.

---

## 8. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are failing due to migration issues or pre-existing defects.

---

## 9. Validate Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider such as Serilog. Check that unhandled exceptions are surfaced appropriately in both development and production environments via the configured error handling middleware.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.