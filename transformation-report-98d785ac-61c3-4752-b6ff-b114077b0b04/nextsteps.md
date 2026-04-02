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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay attention to any nullable reference type warnings or obsolete API usage that may have been introduced during the transformation.

---

## 3. Review Configuration Files

Cross-platform .NET projects rely on `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- `appsettings.json` and `appsettings.Development.json` exist in `Bookstore.Web` and contain the correct connection strings and application settings.
- Any environment-specific configuration that previously lived in `Web.config` transforms has been moved to the appropriate `appsettings.{Environment}.json` file.
- The `Bookstore.Data` project is correctly reading connection strings from the new configuration system, typically via dependency injection in `Program.cs` or `Startup.cs`.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database context (e.g., Entity Framework `DbContext`) is registered correctly in the dependency injection container.
- Connection strings are valid and point to the correct database instance.
- If Entity Framework Core is being used and migrations are present, verify the migration history is intact:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the terminal output and verify:

- The home page loads correctly.
- Navigation between pages functions as expected.
- Any data-driven pages (e.g., book listings) retrieve and display data from the database.

---

## 6. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or patterns that may cause issues on non-Windows platforms:

- References to `System.Web` (should have been removed during transformation).
- Use of `HttpContext.Current` (should be replaced with injected `IHttpContextAccessor`).
- Windows registry access or Windows-only file paths using backslashes instead of `Path.Combine`.
- Any P/Invoke calls targeting Windows-only native libraries.

```bash
grep -rn "System.Web" app/
grep -rn "HttpContext.Current" app/
```

Address any findings before considering the migration complete.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests to determine whether the failure is due to a migration issue or a pre-existing problem. Focus first on failures in tests that cover `Bookstore.Domain` and `Bookstore.Data`, as these form the foundation of the application.

---

## 8. Validate Logging and Error Handling

Confirm that logging is configured correctly in `Program.cs` using the `Microsoft.Extensions.Logging` infrastructure. Ensure unhandled exceptions are surfaced appropriately in both development and production environments by checking the middleware pipeline for `UseDeveloperExceptionPage` (development) and `UseExceptionHandler` (production).