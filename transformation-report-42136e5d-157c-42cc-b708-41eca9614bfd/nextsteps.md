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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and consistent modern .NET version (e.g., `net8.0`) across all projects:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Inconsistent target frameworks between projects can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of test dependencies.

### 5. Verify Runtime Behavior

Run the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically verify the following areas, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. Check that Entity Framework Core (if used) migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```
- **Configuration**: Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware, verify that login, registration, and role-based access function as expected.
- **Static assets and routing**: Confirm that pages render correctly and that routes resolve as expected under ASP.NET Core conventions.

### 6. Review Removed or Changed APIs

Check for any usage of APIs that exist in .NET but behave differently from .NET Framework, including:

- `HttpContext` access patterns
- `System.Web` references that may have been shimmed during transformation
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

### 7. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files, including static assets and configuration files, are present before deploying to the target environment.