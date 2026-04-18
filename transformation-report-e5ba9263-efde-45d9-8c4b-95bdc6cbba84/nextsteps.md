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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Ensure the output shows **0 Error(s)** for all three projects before continuing.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of specific components.

---

## 5. Validate Data Layer (`Bookstore.Data`)

- Confirm that any Entity Framework or database-related packages have been updated to their cross-platform compatible versions (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`).
- Run any pending database migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate Domain Layer (`Bookstore.Domain`)

- Review any classes that previously relied on Windows-specific APIs (e.g., `System.Web`, `System.Drawing`, or COM interop).
- Replace any such dependencies with cross-platform equivalents where applicable.

---

## 7. Validate Web Layer (`Bookstore.Web`)

- Start the web application locally and navigate through the primary workflows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Check for runtime exceptions that would not surface at compile time, such as missing configuration values, incorrect middleware ordering, or removed APIs.
- Confirm that `appsettings.json` contains all configuration values previously held in `Web.config` or `App.config`, including connection strings and application settings.

---

## 8. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Use the .NET Upgrade Assistant compatibility analyzer or the API compatibility tool to identify any remaining issues:

```bash
dotnet tool install -g dotnet-apicompat
```

Additionally, review the [.NET Framework to .NET porting guide](https://learn.microsoft.com/en-us/dotnet/core/porting/) for a reference on commonly removed APIs.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.