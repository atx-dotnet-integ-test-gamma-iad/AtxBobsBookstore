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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet package references and code for any Windows-specific APIs or packages that may not function correctly on Linux or macOS. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)**
- **System.Drawing** (GDI+ based) — replace with a cross-platform alternative such as `SkiaSharp` if needed
- **Windows Authentication** — verify the configuration is appropriate for the target hosting environment

---

## 5. Validate Entity Framework or Data Access Layer

Within `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is correctly referenced and compatible with the target framework.
- Any connection strings in `appsettings.json` or `web.config` have been migrated to the appropriate configuration system (`appsettings.json` / `appsettings.{Environment}.json`).
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify functional correctness after the migration.

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral differences introduced by the framework migration.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database reads and writes function as expected.
- Authentication and authorization behave correctly if applicable.

---

## 8. Review Configuration Migration

Confirm that any settings previously held in `web.config` or `app.config` have been properly moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Custom configuration sections

The `web.config` file in a cross-platform .NET web application should only contain IIS-specific hosting configuration if deploying to IIS, and should not be used for application settings.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 10. Deploy to Target Environment

Copy the published output to the target server or hosting environment. Depending on the hosting model, ensure the following are configured:

- **IIS**: Install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download) on the server and configure the application pool to use "No Managed Code".
- **Self-hosted / Kestrel**: Ensure the correct port and environment variables are set, and that the process is managed by a service manager such as `systemd` on Linux or Windows Services on Windows.
- Set the `ASPNETCORE_ENVIRONMENT` environment variable appropriately (e.g., `Production`).