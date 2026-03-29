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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build. Pay particular attention to:

- Obsolete API usage warnings
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Manual Runtime Verification

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure the database provider (e.g., Entity Framework Core) is configured properly.
- **Domain logic**: Exercise the core business logic exposed by `Bookstore.Domain` to confirm expected behavior.
- **Web layer**: Navigate through the application pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Legacy .NET Framework projects used `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Confirm that:

- All connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or equivalent.
- Authentication, authorization, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`.

### 6. Verify Entity Framework Migrations (If Applicable)

If the project uses Entity Framework Core, confirm that migrations are up to date and can be applied to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Deployment

Once all validation steps pass, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to your target environment according to your hosting setup (e.g., IIS, Azure App Service, or a Linux server with the ASP.NET Core runtime installed).

Ensure the target environment has the correct version of the .NET runtime installed. You can verify the required version in the `<TargetFramework>` property of `Bookstore.Web.csproj`.