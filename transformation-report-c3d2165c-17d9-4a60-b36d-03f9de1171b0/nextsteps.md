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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same or compatible framework versions to avoid runtime mismatches.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review the code and project files for any remaining Windows-specific dependencies, such as:

- References to `System.Web`
- Usage of the Windows Registry
- Windows Communication Foundation (WCF) client or server code
- Any `<PackageReference>` pointing to packages that only support Windows

If any are found, replace them with cross-platform alternatives or apply runtime platform guards where appropriate.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access configuration is compatible with the new runtime:

- If using Entity Framework Core, verify the correct provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality, including:

- Page rendering and routing
- Database read and write operations
- Authentication and authorization, if applicable
- Any file system interactions

---

## 8. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files to ensure:

- Connection strings are correct for the target environment
- Any configuration keys previously stored in `Web.config` have been migrated to `appsettings.json`
- Secrets are not stored in source-controlled files; use `dotnet user-secrets` for local development

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.