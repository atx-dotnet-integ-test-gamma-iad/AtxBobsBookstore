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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that core logic remains intact after the transformation:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they reflect a regression introduced by the migration or a pre-existing issue.

### 4. Verify Runtime Behavior

Launch the web application locally and exercise its primary functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to and query the database. If Entity Framework is in use, verify that migrations apply correctly with `dotnet ef database update`.
- **Domain logic**: Walk through the primary business workflows to confirm that `Bookstore.Domain` behaves as expected.
- **Web layer**: Test all major routes, forms, and data-rendering pages in `Bookstore.Web`.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended cross-platform .NET version (for example, `net8.0`). Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 6. Check Configuration Files

Review `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that connection strings, service endpoints, and other settings were carried over correctly from the legacy project.

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific APIs or packages (such as `System.Web`, `Microsoft.Web.*`, or Windows registry access) remain in the codebase. If any are found, they will need to be replaced with cross-platform equivalents.

## Deployment

Once the validation steps above pass without issue, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.