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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other legacy .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Win32` registry access
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- COM interop or P/Invoke calls targeting Windows libraries

If any are found, either replace them with cross-platform alternatives or add a runtime check using `OperatingSystem.IsWindows()`.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review the test output for any failures that may indicate behavioral differences introduced by the framework change.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Entity Framework Core migrations (if applicable) are up to date.

Run the following command to apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Page rendering
- Data retrieval and display
- Form submissions

---

## 8. Review Configuration and Middleware

Confirm that the `Bookstore.Web` project uses the current ASP.NET Core configuration patterns:

- `Program.cs` uses the minimal hosting model (top-level statements) if targeting .NET 6 or later.
- `Startup.cs` has been consolidated into `Program.cs` if it has not been already.
- Static files, routing, and authentication middleware are correctly registered.

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.