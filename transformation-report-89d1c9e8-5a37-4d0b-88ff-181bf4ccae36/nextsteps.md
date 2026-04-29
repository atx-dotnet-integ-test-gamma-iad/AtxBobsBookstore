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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify all previously passing tests continue to pass.
- If tests were not previously present, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

---

## 4. Validate Data Access Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Application Configuration

- Review `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm connection strings and other settings are correct for the target environment.
- Ensure any configuration that previously relied on `Web.config` or `App.config` has been properly migrated to the `appsettings.json` pattern or environment variables.

---

## 6. Run the Web Application Locally

Start the application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Review Cross-Platform Compatibility

Since this is a cross-platform migration, verify the application behaves correctly on the target operating system:

- Check for any file path constructions that use hardcoded backslashes (`\`). Replace them with `Path.Combine()` or forward slashes where appropriate.
- Confirm that any file system operations use paths relative to `AppContext.BaseDirectory` rather than assuming a specific working directory.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to the target environment.