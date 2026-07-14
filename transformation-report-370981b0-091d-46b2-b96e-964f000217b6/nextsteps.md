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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under .NET compared to .NET Framework.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test
```

Review test output carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly in areas such as:

- `System.Web` replacements (e.g., `HttpContext`, `HttpRequest`)
- Entity Framework version differences
- Serialization behavior changes

---

## 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is correctly referenced and compatible with the target .NET version.
- Run any pending migrations or verify the database schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, verify that the `DbContext` configuration is correct and that connection strings are properly set in `appsettings.json`.

---

## 5. Review Configuration Files

- Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`.
- Confirm that connection strings, application settings, and environment-specific values have been correctly migrated.
- Verify that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly registers all services, middleware, and the database context.

---

## 6. Run the Web Application Locally

Start the application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application and test primary user-facing features such as browsing, searching, and any data entry workflows.
- Check the application logs for runtime exceptions or warnings that did not surface at build time.
- Pay attention to any areas that previously relied on `System.Web`, Windows Authentication, or other Windows-specific APIs, as these may require additional configuration or replacement.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for a web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, it will need to be updated.

---

## 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.