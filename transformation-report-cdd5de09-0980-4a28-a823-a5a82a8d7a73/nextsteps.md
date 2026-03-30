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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Ensure any settings previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` sections.

### 3.2 Database Connectivity

If the project uses Entity Framework, verify the database connection and apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the database schema matches what is expected after migration.

### 3.3 Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm they behave as expected.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems. Pay particular attention to tests covering:

- Domain model logic in `Bookstore.Domain`
- Data access and repository behavior in `Bookstore.Data`
- Controller or middleware behavior in `Bookstore.Web`

---

## 5. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in .NET. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext` and session handling**: Confirm these are accessed via dependency injection rather than static accessors.
- **Security and authentication**: Verify that any `FormsAuthentication` or `MembershipProvider` usage has been replaced with ASP.NET Core Identity or a comparable mechanism.
- **Global.asax**: Confirm its logic has been moved to `Program.cs` or `Startup.cs`.

---

## 6. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 7. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.