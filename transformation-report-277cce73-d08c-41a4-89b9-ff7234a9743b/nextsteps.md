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

Check the output for any warnings, particularly around nullable reference types, obsolete APIs, or platform compatibility annotations, as these may indicate areas that need attention even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves correctly after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that the connection strings in your configuration files are correct and that the data layer (`Bookstore.Data`) connects and queries as expected.
- **Entity Framework migrations**: If the project uses Entity Framework, verify that migrations apply cleanly:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Authentication and authorization**: If the application uses ASP.NET Identity or cookie-based auth, verify that login and session behavior works correctly.
- **Static files and routing**: Confirm that all pages, routes, and static assets (CSS, JS, images) resolve correctly in the browser.
- **Configuration**: Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment variables.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET (for example, `net8.0`). Ensure all three projects target the same framework version to avoid compatibility issues between them.

### 6. Check for Windows-Specific Dependencies

Even without build errors, some APIs are Windows-only at runtime. Search the codebase for usages of APIs annotated with `[SupportedOSPlatform("windows")]` or any P/Invoke calls, registry access, or Windows-specific file path assumptions. If cross-platform deployment is a goal, these areas will need to be addressed.

### 7. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target environment has the correct .NET runtime version installed, which can be verified with:

```bash
dotnet --list-runtimes
```