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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Pay attention to:
- Any tests that were previously passing but now fail, which may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.
- Tests that rely on Windows-specific APIs or behaviors that may not translate directly.

---

## 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas:
- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm correctness.
- **Configuration**: Verify that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment variables.

---

## 5. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies that may only function on Windows. Common areas to check include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access.
- COM interop or P/Invoke calls targeting Windows-only libraries.
- File path assumptions using backslashes rather than `Path.Combine`.

---

## 6. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider matching your database).
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Scaffolded models or database-first configurations have been reviewed for compatibility with EF Core.

---

## 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.