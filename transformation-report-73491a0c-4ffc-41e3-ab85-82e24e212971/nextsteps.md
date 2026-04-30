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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly and that any Entity Framework migrations are up to date. Run `dotnet ef database update` if needed.
- **Configuration**: Verify that `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including connection strings and application settings.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or custom auth middleware, confirm that login, session, and role-based access work as expected.
- **Static files and routing**: Confirm that pages, API routes, and static assets resolve correctly in the browser.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references an actively supported version of .NET (for example, `net8.0`). If an older version such as `net6.0` is present, consider updating to a current long-term support release.

```xml
<TargetFramework>net8.0</TargetFramework>
```

After updating the target framework, re-run `dotnet restore` and `dotnet build` to confirm compatibility.

### 6. Review Removed Windows-Specific APIs

Search the codebase for any usage of APIs that are Windows-only or were removed in modern .NET, such as:

- `System.Web` namespaces
- `HttpContext` from `System.Web` (should now come from `Microsoft.AspNetCore.Http`)
- `ConfigurationManager` (should be replaced with `IConfiguration`)
- `System.Drawing` without the `System.Drawing.Common` NuGet package

Address any such usages before considering the migration complete.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is well-formed:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assemblies, configuration files, and static assets are present.