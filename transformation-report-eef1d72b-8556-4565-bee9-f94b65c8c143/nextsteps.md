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

Ensure consistency across all three projects. A mismatch between projects can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If a test project exists in the solution, execute the tests to verify that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` before deploying.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database connection strings are correctly configured for the new runtime. Check the following:

- Connection strings in `appsettings.json` are valid for the target environment.
- If using Entity Framework Core, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are out of date, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to confirm that data access, domain logic, and the web layer are all functioning correctly.

### 7. Review Removed Windows-Specific APIs

Search the codebase for any APIs that were commonly used in .NET Framework but are unavailable or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references (should no longer be present)
- `ConfigurationManager` usage (should be replaced with `Microsoft.Extensions.Configuration`)
- Windows Registry access
- Any P/Invoke calls targeting Windows-only system libraries

```bash
grep -rn "System.Web" ./app
grep -rn "ConfigurationManager" ./app
```

Address any findings before proceeding to deployment.

### 8. Test on the Target Operating System

If the intent is to run this application on Linux or macOS, perform a full run on that operating system to catch any remaining platform-specific issues such as file path casing sensitivity or OS-specific API calls.