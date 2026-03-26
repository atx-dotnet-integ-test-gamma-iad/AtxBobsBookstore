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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the current .NET runtime.

---

## 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm the following:

- The correct version of Entity Framework (Core or otherwise) is referenced and compatible with the target framework.
- Any database migrations are present and up to date. Run the following if using EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that connection strings in `appsettings.json` are correctly configured for your local environment.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm the following:

- Configuration has been migrated to `appsettings.json` and `appsettings.{Environment}.json`.
- Any environment-specific settings (connection strings, API keys) are correctly placed and not hardcoded.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately for local development (typically `Development`).

---

## 7. Check for Windows-Specific Dependencies

Review the code in all three projects for any remaining Windows-specific APIs or dependencies, such as:

- References to `System.Web`
- Windows Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- COM interop or P/Invoke calls targeting Windows libraries

Replace or abstract any such dependencies to ensure true cross-platform compatibility.

---

## 8. Validate on Target Platform

If the intended deployment target is Linux or macOS, run the application on that platform to catch any remaining platform-specific issues that would not surface on Windows:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify behavior matches the Windows environment.