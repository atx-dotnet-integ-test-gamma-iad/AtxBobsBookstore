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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are targeting the same framework version as `Bookstore.Web` to avoid runtime compatibility issues.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated before proceeding.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The EF Core tools are installed:

```bash
dotnet tool install --global dotnet-ef
```

---

## 6. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is retrieved and displayed correctly.
- Any forms or write operations function as expected.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage outside of controllers or middleware.
- Any Windows-specific APIs such as the registry, WCF, or `System.Drawing` (unless the appropriate NuGet compatibility packages have been added).

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if further analysis is needed.

---

## 8. Review Configuration Migration

Confirm that any settings previously stored in `Web.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Authentication or authorization configuration

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target environment has the correct .NET runtime version installed:

```bash
dotnet --list-runtimes
```