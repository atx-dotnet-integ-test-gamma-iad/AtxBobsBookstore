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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other Windows-only framework moniker unintentionally.

### 4. Check for Windows-Specific APIs

Even without build errors, some APIs may compile but fail at runtime on non-Windows platforms. Review the code in each project for usage of:

- `System.Web` types (e.g., `HttpContext`, `HttpRequest` from the old namespace)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `System.Drawing` without the `System.Drawing.Common` package and platform consideration

### 5. Run Existing Tests

If a test project exists in the solution, execute it to validate core logic:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by the migration or pre-existing issues.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and verify basic functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually navigate through the application and verify:

- Pages load without runtime exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that any existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or the schema is out of sync, create a new migration to reconcile the current model state:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) contain the correct connection strings and application settings. Legacy `Web.config` or `App.config` values may not have been fully carried over during transformation.

### 9. Address Nullable Reference Type Warnings

If the projects have `<Nullable>enable</Nullable>` set in the `.csproj` files, review any nullable warnings in the build output. While these do not block compilation by default, resolving them improves code correctness and reduces the risk of null reference exceptions at runtime.