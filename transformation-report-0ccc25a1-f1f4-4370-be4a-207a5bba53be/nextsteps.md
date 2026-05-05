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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention after migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests after migration should be investigated, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay particular attention to:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Configuration**: Check that `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including connection strings and application settings.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware, confirm that login, registration, and role-based access work as expected.
- **Static assets and routing**: Verify that pages, routes, and static files (CSS, JS, images) resolve correctly under the new ASP.NET Core pipeline.

### 5. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage patterns, which differ between ASP.NET and ASP.NET Core.
- Any Windows-specific libraries (e.g., registry access, COM interop, WCF) that may have been silently excluded or replaced.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for a web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

### 7. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to your target environment. Confirm that the runtime is installed on the target machine or server, or include the runtime by adding `--self-contained true` along with the appropriate `-r` runtime identifier, for example:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --self-contained true -r win-x64 --output ./publish
```