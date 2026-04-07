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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings, even if there are no errors. Warnings related to nullable reference types, obsolete APIs, or platform compatibility should be reviewed and addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key application flows, such as browsing books, managing data, and any authentication or authorization features, to confirm they function as expected.

### 5. Review Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- Database connection strings in configuration files (e.g., `appsettings.json`) are correct for the target environment.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If migrations need to be applied to the database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Check Configuration Files

Review `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) to ensure:

- Connection strings are updated and valid.
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to the new configuration system.

### 7. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element is consistent across the solution.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and compiled assemblies.

### 3. Deploy to Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the runtime environment has the correct version of the .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` value in the web project's `.csproj` file.