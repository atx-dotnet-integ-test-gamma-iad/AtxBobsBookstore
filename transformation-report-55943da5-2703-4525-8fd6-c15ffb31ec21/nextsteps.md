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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that EF Core is being used rather than EF 6, as EF 6 has limited support on non-Windows platforms.

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the locally hosted URL and test the primary user-facing features, such as browsing, searching, and any authentication flows.

### 7. Check for Windows-Specific API Usage

Even without build errors, certain APIs behave differently or are unsupported on non-Windows platforms. Search the codebase for the following:

- `Registry` access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `System.Drawing` usage (requires additional native dependencies on Linux/macOS)
- Any P/Invoke calls targeting Windows-only native libraries

Use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 8. Review Middleware and HTTP Pipeline (Bookstore.Web)

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify that:

- Middleware is registered correctly in `Program.cs` or `Startup.cs`.
- Authentication and authorization configurations are in place.
- Static file serving, routing, and model binding behave as expected.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.