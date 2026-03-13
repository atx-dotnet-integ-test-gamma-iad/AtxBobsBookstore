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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`) across all three projects:

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

Mismatched target frameworks between projects can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Review the `Bookstore.Data` and `Bookstore.Web` projects for any remaining dependencies that are Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- MSMQ or WCF components
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies with cross-platform equivalents where applicable.

---

## 5. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity` (the legacy EF6 package).
- Any database migrations are compatible with the new EF Core provider.
- Connection strings in configuration files (`appsettings.json`) are correctly formatted.

Run a migration check if applicable:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core business logic:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` project to verify domain logic correctness after migration.

---

## 7. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without exceptions
- Database read and write operations function correctly
- Any authentication or authorization flows behave as expected

---

## 8. Review Configuration Files

Ensure the following configuration concerns are addressed:

- `web.config` settings have been migrated to `appsettings.json` or `appsettings.{Environment}.json`
- Environment-specific settings (e.g., connection strings) are not hardcoded
- The `Program.cs` and `Startup.cs` (or combined `Program.cs` in minimal hosting model) correctly register all required services

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.