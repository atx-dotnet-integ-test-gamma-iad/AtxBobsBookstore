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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and supported version of .NET.

### 5. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually exercise the key application flows such as browsing, searching, and any data-driven pages to confirm the `Bookstore.Data` and `Bookstore.Domain` layers are functioning correctly at runtime.

### 6. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs or libraries that are Windows-specific and will fail at runtime on Linux or macOS. Review the code and NuGet packages in all three projects for any of the following:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes, drive letters)
- Any package that targets `net4x` only

### 7. Review Data Layer and Database Connectivity

In `Bookstore.Data`, confirm that the database provider and connection strings are configured correctly for the new runtime environment. If Entity Framework Core is in use, run the following to verify the model is consistent with the current migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once the application has been validated locally, publish it to confirm the output is complete and self-contained:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.