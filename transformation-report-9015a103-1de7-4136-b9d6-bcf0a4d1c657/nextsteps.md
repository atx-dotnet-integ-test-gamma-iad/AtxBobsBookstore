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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any environment-specific configuration is handled using the `IConfiguration` system rather than `ConfigurationManager`, which is a legacy .NET Framework approach.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is in use, ensure it has been migrated to **Entity Framework Core**.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Validate that the database schema matches expectations after the migration runs.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to confirm existing functionality is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral changes introduced by the migration or pre-existing issues.

---

## 6. Run the Application Locally

Start the `Bookstore.Web` project locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Development
```

- Navigate through the application and exercise the primary workflows (e.g., browsing books, user authentication, data persistence).
- Check the console and application logs for any runtime exceptions or warnings.
- Verify that static assets, routing, and middleware are functioning as expected.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs that may not be supported cross-platform. Common areas to check include:

- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if image processing is needed)
- Windows Registry access
- COM interop
- `HttpContext.Current` (replace with injected `IHttpContextAccessor`)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

---

## 8. Validate on Target Platform

If the goal is cross-platform deployment (e.g., Linux), test the application on the target operating system to catch any platform-specific runtime issues that may not surface on Windows:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then run the published output on the target machine and confirm the application starts and operates correctly.