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

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference mismatches.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, validate the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET does not use `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- `appsettings.json` (and `appsettings.{Environment}.json`) contains all necessary configuration values previously held in `Web.config`.
- Connection strings have been correctly migrated to `appsettings.json` or environment variables.
- Any configuration transforms that existed previously have been accounted for.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw at runtime on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages such as `System.Drawing.Common`)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext.Current` or other ASP.NET-classic patterns

### 7. Review Nullable Reference Type Warnings

If nullable reference types are enabled in the migrated projects, address any warnings surfaced during the build step. While these are not errors by default, resolving them improves code correctness and prevents potential null reference exceptions at runtime.