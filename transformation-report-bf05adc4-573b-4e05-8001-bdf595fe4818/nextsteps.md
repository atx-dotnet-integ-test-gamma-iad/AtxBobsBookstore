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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`. For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.1`, `net5.0`, or `net6.0`, consider updating to `net8.0` as those versions are out of support.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by breaking API changes introduced in the newer .NET version.

### 5. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm that your migrations are compatible with the current EF Core version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are outdated or incompatible, you may need to add a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality such as routing, data access, and page rendering:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm end-to-end behavior is intact.

### 7. Review `appsettings.json` and Configuration

Confirm that connection strings, environment-specific settings, and any configuration keys previously stored in `Web.config` have been correctly migrated to `appsettings.json` or `appsettings.Production.json`.

### 8. Check for Removed or Changed APIs

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or review the [.NET breaking changes documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/breaking-changes) relevant to your target framework version to identify any runtime issues that would not surface as build errors.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected assemblies, static assets, and configuration files are present.

### 3. Test the Published Output

Run the published output directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Verify the application starts without errors and that all core functionality remains operational before deploying to the target environment.