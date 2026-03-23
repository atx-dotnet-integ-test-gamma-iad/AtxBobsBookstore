# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and homepage load
- Any database-driven pages that rely on `Bookstore.Data`
- Domain logic paths exercised through the UI

### 5. Check Database Compatibility

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database schema requirements are compatible with the target runtime:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If you are using a different ORM or data access strategy, verify that connection strings and provider packages are correctly configured in `appsettings.json` or equivalent configuration files.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Review Removed or Changed APIs

Check for any use of APIs that existed in .NET Framework but have changed behavior or limited support in cross-platform .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs such as the registry or certain cryptography providers
- Any third-party libraries that may still target .NET Framework only

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.