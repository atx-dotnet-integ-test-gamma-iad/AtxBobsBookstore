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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Ensure the output shows zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Any Entity Framework or other ORM configurations are compatible with the target .NET version.
- If Entity Framework is used, confirm the version is **Entity Framework Core** and not the legacy `System.Data.Entity` namespace, which is not supported on cross-platform .NET.
- Run any pending migrations or verify the database schema is still consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate the Web Layer

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- Key pages and routes load correctly.
- Database reads and writes function as expected.
- Any authentication or session management behaves correctly.

---

## 7. Review Removed Windows-Specific APIs

Cross-platform .NET does not support certain Windows-only APIs (e.g., `System.Web`, `HttpContext` from classic ASP.NET, registry access, or WCF server-side components). Search the codebase for any remaining usages:

```bash
grep -rn "System.Web" .
```

If any are found, they will need to be replaced with their ASP.NET Core or .NET equivalents.

---

## 8. Review Configuration Files

Ensure that `web.config` or `app.config` files have been replaced or supplemented by `appsettings.json` and the ASP.NET Core configuration system. Connection strings and application settings should be present in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 9. Deploy to Target Environment

Once all validation steps pass, publish the application:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target environment has the correct .NET runtime installed by running:

```bash
dotnet --info
```