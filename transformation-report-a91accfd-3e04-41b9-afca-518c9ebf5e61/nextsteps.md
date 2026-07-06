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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

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

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime.

### 5. Run the Application Locally

Start the web application locally to validate runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key workflows of the application, such as browsing, searching, and any data entry flows, to confirm they function correctly.

### 6. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that:

- The connection string in `appsettings.json` (or equivalent configuration) is valid for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, apply them with:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Removed Windows-Specific APIs

Even without build errors, certain APIs that previously worked on .NET Framework may behave differently on cross-platform .NET. Review the code for usage of the following and test them explicitly:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific authentication mechanisms
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Check Runtime Configuration

Review the following files to ensure they are correctly configured for the new runtime:

- `appsettings.json` and `appsettings.Production.json`
- `Program.cs` for proper service registration and middleware pipeline setup
- Any custom configuration providers or startup logic

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Test the Published Output

Run the published output directly to confirm it behaves consistently with the local development run:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Verify the application starts without errors and that core functionality remains intact before deploying to a production environment.