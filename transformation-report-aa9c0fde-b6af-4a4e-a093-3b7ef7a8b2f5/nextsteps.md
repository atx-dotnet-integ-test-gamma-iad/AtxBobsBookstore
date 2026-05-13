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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete API usage introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced by the migration or a pre-existing issue.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, verify that the migrations are compatible with the target runtime.
- Run the following command to check for pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data
```

- Confirm that connection strings in `appsettings.json` or environment-specific configuration files are correctly set for the target environment.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain models or business logic classes for use of APIs that may have changed behavior between .NET Framework and modern .NET.
- Pay particular attention to:
  - `System.Configuration` usage, which is not available in the same form on cross-platform .NET.
  - Any serialization logic using `BinaryFormatter`, which is disabled by default in .NET 5+.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that:
  - All pages render correctly.
  - Forms submit and process data as expected.
  - Authentication and authorization flows work correctly if applicable.
- Check that static files, bundling, and any middleware configurations are functioning properly.
- If the project previously used `System.Web`, confirm that all references have been replaced with their ASP.NET Core equivalents.

---

## 7. Review Configuration Files

- Confirm that `appsettings.json` contains all necessary settings that were previously stored in `Web.config` or `App.config`.
- Verify environment-specific configuration files (e.g., `appsettings.Development.json`, `appsettings.Production.json`) are in place and correct.
- Ensure that any secrets (connection strings, API keys) are handled using the appropriate mechanism such as `dotnet user-secrets` for local development.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a newer Long-Term Support (LTS) version of .NET is available and desired, update the target framework and re-run the build and test steps above.

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.