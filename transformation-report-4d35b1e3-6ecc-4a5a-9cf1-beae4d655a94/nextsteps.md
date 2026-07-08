# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Production.json` contain all settings previously held in `Web.config` or `App.config` from the legacy project.
- Verify that any environment-specific settings (connection strings, API keys, logging levels) are correctly separated by environment.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unavailable on non-Windows platforms. If cross-platform deployment is intended, test the application on the target OS (Linux/macOS) and watch for `PlatformNotSupportedException` at runtime.

### 8. Review Logging and Error Handling

Confirm that the logging configuration in `Program.cs` or `Startup.cs` is correctly set up using `Microsoft.Extensions.Logging`. Verify that errors surface correctly in the console or log files during local testing.