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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Data Layer

Since `Bookstore.Data` is likely responsible for database access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Any connection strings in configuration files (`appsettings.json`) are valid and accessible in the new environment.
- Run any pending Entity Framework Core migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:

- Application startup completes without runtime exceptions.
- Routing and page rendering work as expected.
- Database read and write operations function correctly.
- Any authentication or session handling behaves as intended.

### 6. Review Configuration Files

Confirm that the following have been correctly migrated or created for the new project structure:

- `appsettings.json` and `appsettings.Production.json` contain the appropriate settings.
- Any settings previously stored in `Web.config` or `App.config` have been moved to the appropriate `appsettings.json` sections or handled via the `Microsoft.Extensions.Configuration` APIs.

### 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer if not already done, to identify any remaining usage of Windows-only or legacy APIs that may cause issues on non-Windows platforms:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review and replace any flagged APIs with cross-platform alternatives where necessary.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```