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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that the output shows zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database and performs reads and writes correctly. Check that Entity Framework migrations (if applicable) are up to date by running `dotnet ef database update`.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm expected behavior.
- **Web layer**: Navigate through the application pages or endpoints and verify that routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Check `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) to ensure that:

- Connection strings are correct for the target environment.
- Any settings previously stored in `Web.config` or `App.config` have been properly migrated.
- Logging configuration is present and appropriate.

### 6. Check for Removed or Changed APIs

Even without build errors, some .NET Framework APIs behave differently or have been removed in cross-platform .NET. Pay particular attention to:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific APIs (registry access, Windows authentication, etc.) if the application needs to run on non-Windows hosts.
- Third-party libraries that may have been targeting .NET Framework and could have compatibility issues at runtime.

### 7. Deployment

Once the application has been validated locally, publish it using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment and configure the web server (IIS, Kestrel, Nginx, etc.) to serve the application.