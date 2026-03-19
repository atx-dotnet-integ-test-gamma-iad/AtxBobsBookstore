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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid cross-project compatibility issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific APIs or packages remain. Search the codebase for any usage of:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry APIs
- Any packages that target `net4x` only

If any are found, they will need to be replaced with cross-platform equivalents.

### 8. Review Middleware and HTTP Pipeline (Bookstore.Web)

If the web project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify the following in `Program.cs` or `Startup.cs`:

- Authentication and authorization middleware is correctly configured.
- Static file serving is enabled if required.
- Any custom HTTP modules or handlers from the legacy project have been replaced with ASP.NET Core middleware.

### 9. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and ensure the hosting environment has the appropriate .NET runtime installed. You can verify the required runtime version with:

```bash
dotnet --info
```