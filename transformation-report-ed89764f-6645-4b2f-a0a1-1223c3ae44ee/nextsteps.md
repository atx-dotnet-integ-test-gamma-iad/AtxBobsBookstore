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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database connection strings are correctly configured for the new target framework. Check the following:

- Connection strings in `appsettings.json` are valid and point to the correct database.
- If using Entity Framework Core, run the following to verify the model is consistent with the database schema:

```bash
dotnet ef migrations list
```

If migrations are out of sync, update the database:

```bash
dotnet ef database update
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify that core functionality works as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and confirm that:

- Pages load without runtime exceptions.
- Data is correctly read from and written to the database.
- Any authentication or authorization flows behave as expected.

### 6. Review Target Framework and Dependencies

Open each `.csproj` file and confirm the following:

- The `<TargetFramework>` element targets the intended .NET version (e.g., `net8.0`).
- No remaining references to `net4x` framework-specific libraries exist.
- Third-party NuGet packages are using versions compatible with the target framework.

### 7. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs that may not be available cross-platform, such as:

- `System.Web` references
- Windows Registry access
- `System.Drawing` (GDI+) without the `System.Drawing.Common` package
- COM interop calls

These will not cause build errors but may produce runtime exceptions on non-Windows platforms.

### 8. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and self-contained:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present.