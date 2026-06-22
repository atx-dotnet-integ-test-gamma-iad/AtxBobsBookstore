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

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used EF 6, confirm it has been migrated to EF Core and that all `DbContext` configurations, relationships, and queries function correctly.

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and check:

- Pages render without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization mechanisms function as expected.

### 7. Check for Windows-Specific API Usage

Even without build errors, certain APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the codebase for usage of:

- `Microsoft.Win32` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `System.Web` types that may have been shimmed during transformation

Use the .NET Compatibility Analyzer to assist with this review:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 8. Review Removed or Changed APIs

Cross-reference the codebase against the [.NET Upgrade Assistant compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/porting/net-framework-tech-unavailable) to identify any APIs that behave differently or have been removed in modern .NET, particularly in the areas of:

- `System.Configuration` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` and `System.Web` (replaced by ASP.NET Core equivalents)
- WCF client or server usage, if applicable

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and dependent assemblies.

### 3. Configure the Target Environment

Ensure the target server or hosting environment has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the appropriate runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

### 4. Test in the Target Environment

Deploy the published output to a staging environment that mirrors production and repeat the manual validation steps described above before promoting to production.