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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Run the Application Locally

Start the web application locally to confirm it runs as expected on the new cross-platform .NET runtime:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- The application starts without runtime exceptions.
- Database connectivity through `Bookstore.Data` is functioning correctly.
- Core domain logic in `Bookstore.Domain` behaves as expected.
- Key pages and routes in `Bookstore.Web` load and respond correctly.

### 5. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 6. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code references Windows-specific APIs. Use the .NET Compatibility Analyzer to check:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Review any warnings related to platform compatibility and replace or conditionally compile any Windows-only code paths.

### 7. Review Data Layer Configuration

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., Entity Framework Core) is configured for cross-platform use.
- Connection strings do not rely on Windows-specific authentication mechanisms such as Windows Integrated Security, unless the deployment target is exclusively Windows.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 8. Review Static Files and Paths

In `Bookstore.Web`, check that any file path construction uses `Path.Combine` rather than hardcoded backslashes, to ensure compatibility across operating systems.

### 9. Publish the Application

Once all validation steps pass, publish the application for the target runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all necessary assets and dependencies are present before deploying to the target environment.