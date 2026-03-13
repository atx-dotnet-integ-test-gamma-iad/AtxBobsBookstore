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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the following areas at a minimum:

- Application startup and landing page rendering
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic exposed through `Bookstore.Domain`
- Any authentication or authorization flows if present

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid and point to the correct database instances
- Any file paths or platform-specific settings have been updated to use cross-platform equivalents
- Logging configuration is correct

### 6. Check for Platform-Specific API Usage

Even without build errors, certain APIs may have changed behavior on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (limited support outside Windows without additional packages)
- Windows registry access
- Windows-specific file path assumptions (backslashes, drive letters)
- `System.Web` namespaces, which are not available in cross-platform .NET

### 7. Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible and apply cleanly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations were generated under the legacy framework, review them for any SQL or provider-specific constructs that may need updating.

### 8. Publish a Release Build

Once validation is complete, produce a published output to confirm the final deployable artifact builds without issue:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, static files, and configuration files are present.