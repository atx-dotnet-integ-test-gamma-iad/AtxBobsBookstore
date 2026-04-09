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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the new project.
- If Entity Framework is used, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic classes to confirm that any dependencies previously relying on `System.Web` or other Windows-specific namespaces have been replaced with cross-platform equivalents.
- Check for any use of `BinaryFormatter` or other serialization mechanisms that are disabled or removed in modern .NET.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) are correctly configured.
- Verify that middleware, authentication, authorization, and routing configurations are functioning as expected.
- Check `appsettings.json` to ensure connection strings and application settings were correctly migrated from `Web.config`.
- Run the application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

---

## 7. Review Configuration Migration

- Confirm that all relevant settings from the legacy `Web.config` or `App.config` have been transferred to `appsettings.json`.
- Pay particular attention to connection strings, custom configuration sections, and any environment-specific settings.

---

## 8. Check for Runtime Compatibility Issues

- Test on the target operating system (Linux or macOS if cross-platform support is a goal) to surface any remaining platform-specific dependencies.
- Review usage of APIs flagged with `[SupportedOSPlatform]` attributes or similar compatibility annotations.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.