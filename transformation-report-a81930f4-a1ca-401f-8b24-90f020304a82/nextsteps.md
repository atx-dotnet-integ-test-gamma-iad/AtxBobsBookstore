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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures. If tests were written against .NET Framework-specific behavior, some may require updates to align with cross-platform .NET semantics.

---

## 4. Verify Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your database).
- Any existing migrations are compatible with EF Core. If the project was previously using EF 6, migrations may need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 5. Validate Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes resolve correctly.
- Database reads and writes function as expected.
- Any authentication or session handling behaves correctly, as these subsystems changed significantly between .NET Framework and cross-platform .NET.

---

## 6. Review Configuration

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm that:

- All configuration values previously in `Web.config` have been migrated to `appsettings.json`.
- Environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Any connection strings, API keys, or application settings are present and correct.

---

## 7. Check for Platform-Specific Code

Even without build errors, some APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access.
- Windows-specific file path assumptions (e.g., backslash separators).
- Any P/Invoke calls targeting Windows-only native libraries.

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 8. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target server or hosting environment according to your infrastructure requirements.