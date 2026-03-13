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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` before proceeding.

### 5. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that the data layer connects correctly to the database:

- Check the connection string in `appsettings.json` or `appsettings.Development.json` within `Bookstore.Web`.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions.
- Pages or API endpoints load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization flows work correctly.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were specific to .NET Framework and may not behave identically on cross-platform .NET. Common areas to review include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific registry or file path assumptions.
- Any third-party NuGet packages that have not yet been updated to support cross-platform .NET.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to assist with this review if needed.

### 8. Review Application Configuration

Confirm that configuration sources such as `appsettings.json`, environment variables, and any secrets management are functioning correctly under the new hosting model, particularly if the project previously relied on `Web.config` or `App.config`.