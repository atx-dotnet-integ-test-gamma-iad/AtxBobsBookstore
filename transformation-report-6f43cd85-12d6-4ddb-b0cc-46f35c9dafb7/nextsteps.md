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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether the failure is due to a behavioral change introduced by the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema is created or updated as expected.

---

## 5. Run the Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Data is read from and written to the database as expected.
- Any authentication or authorization flows function correctly.

---

## 6. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes certain Windows-specific APIs that were available in .NET Framework. Manually review the code for any usage of the following, which may cause runtime errors even if they do not produce build errors:

- `System.Web` namespaces or types
- Windows Registry access
- `HttpContext.Current`
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- `System.Drawing` without the `System.Drawing.Common` NuGet package

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.