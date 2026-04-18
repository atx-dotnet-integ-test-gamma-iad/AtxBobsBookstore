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

Check the output for any warnings that, while non-breaking, may indicate areas that need attention, such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, validate the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if any) are applied correctly.
- **Domain logic**: Exercise key business logic paths in `Bookstore.Domain` to ensure correctness.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Check for Runtime-Only Issues

Some issues do not surface at build time but appear at runtime. Pay attention to:

- **Configuration**: Ensure `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including connection strings.
- **Authentication and Authorization**: If the application uses Windows Authentication or ASP.NET Membership, verify these have been correctly migrated to the ASP.NET Core equivalents.
- **Static files**: Confirm that static assets (CSS, JavaScript, images) are being served correctly under the `wwwroot` folder structure.
- **Session and State Management**: Verify that any session or application state behavior works as expected under ASP.NET Core's session middleware.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 7. Review NuGet Package Versions

Check that all NuGet packages referenced across the three projects are compatible with the target framework and are not pinned to outdated versions. Use the following command to list outdated packages:

```bash
dotnet list package --outdated
```

Update packages where appropriate, taking care to review changelogs for breaking changes.