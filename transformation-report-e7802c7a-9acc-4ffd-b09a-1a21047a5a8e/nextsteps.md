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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the build output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the web application locally and exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically verify the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are compatible with the new runtime.
- **Domain logic**: Walk through key business workflows to ensure `Bookstore.Domain` behaves as expected.
- **Web layer**: Test all major routes, forms, and API endpoints in `Bookstore.Web` for correct responses.

### 5. Check for Removed or Changed APIs

Review the code for any use of APIs that existed in .NET Framework but have changed behavior in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced during transformation.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage patterns.
- Configuration access patterns, which moved from `System.Configuration.ConfigurationManager` to `Microsoft.Extensions.Configuration`.
- Any Windows-specific APIs such as the registry, WCF, or Windows Identity Foundation.

### 6. Validate Entity Framework Migrations

If the project uses Entity Framework, confirm that the migration history and current schema are consistent:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If you are targeting a new database provider or a newer version of Entity Framework Core, apply any pending migrations to a test database before pointing to production data:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 7. Review Target Framework Monikers

Open each `.csproj` file and confirm that the `<TargetFramework>` element reflects the intended version of .NET, for example `net8.0`. Ensure consistency across all three projects to avoid compatibility issues between assemblies.

### 8. Deployment

Once the application has been validated locally, publish the application using the following command, adjusting the runtime identifier as appropriate for your target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server. Ensure the target server has the appropriate .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` value in the web project file.