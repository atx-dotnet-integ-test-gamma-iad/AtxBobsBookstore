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

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the new project.
- If migrations are used, verify they are up to date by running:

```bash
dotnet ef migrations list
```

- Apply any pending migrations to a local or development database:

```bash
dotnet ef database update
```

- Manually test database connectivity and confirm that basic CRUD operations function as expected.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic classes to ensure no runtime behavior has changed.
- Pay particular attention to any code that previously relied on .NET Framework-specific APIs that may have been replaced or removed in cross-platform .NET.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally using:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application in a browser and verify that all pages render correctly and that form submissions, data retrieval, and navigation function as expected.
- Check that static files, routing, and middleware are configured correctly in `Program.cs` or `Startup.cs`.
- Review any configuration previously stored in `Web.config`, as this should now reside in `appsettings.json`. Confirm all connection strings, app settings, and environment-specific values are present and correct.

---

## 7. Review Logging and Error Handling

- Confirm that logging is configured correctly using the .NET logging abstractions (e.g., `Microsoft.Extensions.Logging`).
- Run the application and intentionally trigger edge cases to ensure errors are handled and logged as expected.

---

## 8. Perform a Release Build and Publish

Once validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all necessary files are present, then deploy the published output to the target hosting environment (e.g., IIS, Linux server, or Azure App Service).