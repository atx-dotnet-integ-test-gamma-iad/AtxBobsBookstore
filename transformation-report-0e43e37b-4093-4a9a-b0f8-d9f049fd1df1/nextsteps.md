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

Check the output for any warnings that may indicate compatibility issues even if the build succeeds, such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken during the transformation:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to verify include:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure the database provider (e.g., Entity Framework Core) is configured properly.
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Check for Removed or Changed APIs

Cross-platform .NET removes or modifies certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` — this namespace is not available in cross-platform .NET. It should have been replaced during transformation, but confirm this is the case.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage should reference `Microsoft.AspNetCore.Http` equivalents.
- `ConfigurationManager` should be replaced with `Microsoft.Extensions.Configuration`.
- `AppDomain`, `Thread.Abort`, and similar APIs may behave differently or be unavailable.

### 6. Review the Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to an appropriate and supported version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible and that the database schema can be applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations were originally written for Entity Framework 6, they may need to be regenerated for Entity Framework Core.

### 8. Review Logging and Configuration

Confirm that logging and configuration have been updated to use the `Microsoft.Extensions.Logging` and `Microsoft.Extensions.Configuration` abstractions, which are standard in cross-platform .NET applications. Legacy approaches such as `log4net` or `web.config`-based configuration should be replaced or supplemented with the modern equivalents.