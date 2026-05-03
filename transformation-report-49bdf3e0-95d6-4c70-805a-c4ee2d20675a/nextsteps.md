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

Ensure all three projects are targeting a consistent framework version.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary workflows, particularly any that involve database access through `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 6. Verify Data Access

If `Bookstore.Data` uses Entity Framework, confirm that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or the appropriate provider for your database).
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check for Runtime Compatibility Issues

Some APIs that existed in .NET Framework are absent or behave differently in cross-platform .NET. Pay particular attention to:

- `System.Web` usages, which are not available outside of ASP.NET Core.
- Windows-specific APIs (registry, WCF server-side, etc.) that may compile but fail at runtime on non-Windows platforms.
- Configuration changes, as `Web.config` is replaced by `appsettings.json` in ASP.NET Core.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is well-formed:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all expected assets and dependencies are present before deploying to the target environment.