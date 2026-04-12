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

Check the output for any warnings that, while non-breaking, may indicate areas needing attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that queries return expected results. Check that Entity Framework migrations, if applicable, are compatible with the new runtime.
- **Domain logic**: Exercise key business logic paths to ensure outputs match pre-migration behavior.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm that routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to confirm that:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the `appsettings.json` format.
- Authentication or authorization settings, if present, are functioning correctly under the new configuration system.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently across .NET versions. Review the [.NET Compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) for any breaking changes relevant to the framework version you have targeted, particularly in areas such as:

- HTTP request/response handling
- Session and cookie management
- Globalization and encoding behavior

### 7. Review Dependency Versions

Examine the `.csproj` files for each project to confirm that all third-party NuGet packages are targeting versions compatible with the new framework. Use the following command to identify outdated packages:

```bash
dotnet list package --outdated
```

Update packages where necessary, and re-run the build and tests after doing so.

## Deployment

Once validation is complete and the application behaves as expected:

1. Publish the application using the appropriate runtime identifier for your target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory to ensure all required files, including static assets and configuration files, are present.

3. Deploy the contents of the `./publish` directory to your target server or hosting environment, following the standard process for that environment.