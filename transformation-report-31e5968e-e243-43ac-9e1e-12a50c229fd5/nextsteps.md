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

- Verify that all previously passing tests continue to pass.
- If tests were written against .NET Framework-specific behavior (e.g., `System.Web`, `HttpContext`), they may need to be updated to use ASP.NET Core equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is using the correct provider package for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer` instead of `EntityFramework`).
- If database migrations are used, verify existing migrations are compatible:

```bash
dotnet ef migrations list
```

- Run a migration or update against a development database to confirm schema integrity:

```bash
dotnet ef database update
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any types that previously relied on .NET Framework-only namespaces (e.g., `System.Runtime.Serialization`, `System.ComponentModel`).
- Confirm that all business logic behaves as expected by running any associated unit tests.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project runs locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Open the application in a browser and manually verify key pages and workflows (e.g., browsing books, authentication, checkout if applicable).
- Check that configuration values previously stored in `Web.config` have been correctly migrated to `appsettings.json`.
- Verify that any middleware, authentication, or routing configuration in `Startup.cs` or `Program.cs` is functioning as expected.

---

## 7. Review Removed or Changed APIs

Cross-reference the migrated code against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any runtime-level behavioral differences that would not surface as build errors.

---

## 8. Test Against a Staging Environment

Before promoting to production, deploy the application to a staging environment that mirrors production. Validate:

- Database connectivity and query behavior.
- Authentication and session handling.
- Static file serving and routing.
- Any third-party integrations or external API calls.

---

## 9. Review Target Framework

Confirm that all three projects are targeting the intended version of .NET (e.g., `net8.0`). Open each `.csproj` file and verify the `<TargetFramework>` element:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a newer LTS version is available and desired, this is a straightforward update to make before going to production.