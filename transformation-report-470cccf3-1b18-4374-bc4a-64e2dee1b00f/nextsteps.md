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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **File paths**: Ensure no hardcoded Windows-style paths (e.g., backslashes) exist in configuration or code. Use `Path.Combine` where applicable.
- **Database connectivity**: Confirm that the connection strings in `appsettings.json` are correct and that `Bookstore.Data` can connect and perform operations as expected.
- **Entity Framework migrations**: If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Static files and routing**: Confirm that pages, assets, and API routes resolve correctly in the browser.

### 5. Check Configuration Files

Review `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) to ensure settings such as connection strings, logging levels, and application URLs are appropriate for the target environment.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended .NET version (e.g., `net8.0`). Ensure consistency across all three projects.

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target host environment. Ensure the runtime environment on the host has the matching .NET version installed, which can be verified with:

```bash
dotnet --version
```