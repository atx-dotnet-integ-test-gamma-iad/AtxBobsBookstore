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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the primary business logic paths to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

### 5. Review Replaced or Removed APIs

Check for any uses of APIs that were available in .NET Framework but have changed behavior or limited support in cross-platform .NET. Common areas to review include:

- `System.Web` references, which are not available in cross-platform .NET and may have been substituted during transformation.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages, which have different APIs in ASP.NET Core.
- Any configuration previously handled via `Web.config`, which should now be managed through `appsettings.json` and the `IConfiguration` system.
- Entity Framework version differences if the project migrated from EF6 to EF Core, particularly around query behavior and lazy loading.

### 6. Check Logging and Error Handling

Confirm that logging is properly configured in `Program.cs` or `Startup.cs` and that unhandled exceptions are surfaced correctly during local testing.

### 7. Validate Database Migrations

If the project uses Entity Framework Core migrations, verify that the migration history is consistent and apply any pending migrations against a test database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example `net8.0`, and that it is consistent across all projects in the solution.