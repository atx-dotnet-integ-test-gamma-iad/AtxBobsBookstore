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

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime failures can occur if any libraries or APIs used are Windows-only. Review the dependencies in each `.csproj` for packages that may have platform restrictions.

Use the compatibility analyzer to surface potential issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:
- Any use of `System.Windows` or `System.Web` namespaces
- Registry access
- Windows-specific file path assumptions

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify that the database connection strings and any ORM configurations (e.g., Entity Framework Core) are functioning correctly in the new environment.

- Confirm the connection string in `appsettings.json` is correct for your target environment.
- If using Entity Framework Core, run a migration check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality through the browser.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions
- Pages load and render correctly
- Data is read from and written to the database as expected
- Authentication and authorization flows work if applicable

Review the console output and application logs for any runtime warnings or errors.

---

## 8. Review `appsettings.json` and Configuration

Ensure that configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or environment variables. Verify:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, assets, and dependencies are present.