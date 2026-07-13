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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

---

## 4. Verify Data Layer

Since `Bookstore.Data` likely contains database access logic, verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for your target environment.
- Any **Entity Framework Core migrations** are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify core functionality, including:

- Page rendering and routing
- Data retrieval and display
- Any form submissions or write operations

---

## 6. Review Platform-Specific Code

Even without build errors, certain APIs that existed in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Manually review the codebase for:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any Windows-specific APIs such as the registry, `System.Drawing`, or COM interop
- Configuration patterns that previously relied on `Web.config` — these should now use `appsettings.json`

---

## 7. Check Runtime Behavior in Target Environment

Deploy the application to a staging environment that matches your intended production environment (Linux, Windows, or macOS) and verify:

- The application starts without errors
- Logging output does not contain unhandled exceptions
- Database connectivity is confirmed
- All application routes and features function as expected

---

## 8. Review Deprecated or Replaced APIs

Run the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool to surface any remaining API compatibility concerns that do not produce build errors but may cause runtime issues:

```bash
dotnet tool install -g dotnet-compatibility
```

Address any flagged APIs by replacing them with their recommended cross-platform equivalents.