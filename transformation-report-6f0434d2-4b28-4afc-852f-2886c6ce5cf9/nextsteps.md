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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

### 5. Run the Application Locally

Start the `Bookstore.Web` project locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key areas of the application, including:

- Page rendering and navigation
- Data access operations through `Bookstore.Data`
- Domain logic in `Bookstore.Domain`

### 6. Review Removed or Changed APIs

Check for any usage of Windows-specific or legacy APIs that may have been silently replaced or removed during transformation. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Any use of `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another data access library, confirm that:

- The connection string is correctly configured in `appsettings.json`
- Migrations (if applicable) are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Check Runtime Configuration

Verify that `appsettings.json` and `appsettings.{Environment}.json` files contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Confirm that environment-specific settings are correctly applied at runtime.

### 9. Publish the Application

Once local validation is complete, produce a published output to verify the application packages correctly:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files and assets are present before deploying to the target environment.