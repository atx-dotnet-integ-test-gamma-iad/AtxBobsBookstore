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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while not blocking the build, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Target Framework Monikers

Open each `.csproj` file and confirm the `<TargetFramework>` element references an appropriate modern TFM, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses the appropriate web TFM if applicable:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 5. Verify Runtime Behavior

Start the web application locally and manually exercise the primary workflows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common sources of subtle runtime differences after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly and that any Entity Framework migrations are up to date. Run pending migrations if necessary:

  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```

- **Configuration**: Verify that settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` and are being read at runtime.

- **Authentication and Authorization**: If the application uses ASP.NET Identity or any authentication middleware, confirm that login, registration, and role-based access function correctly.

- **Static files and routing**: Navigate through the application to confirm that views render correctly and that routing behaves as expected under the new ASP.NET Core pipeline.

### 6. Review Removed or Changed APIs

Cross-reference the `Bookstore.Domain` and `Bookstore.Data` projects for any usage of APIs that exist in .NET but behave differently from .NET Framework. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced.
- `HttpContext` usage, which must go through dependency injection in ASP.NET Core.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

### 7. Check NuGet Package Compatibility

Review the NuGet packages referenced across all three projects and confirm they target .NET Standard 2.0 or later, or provide a `net6.0`/`net8.0` compatible build. Packages that only target .NET Framework may cause runtime issues even if they compile successfully.

```bash
dotnet list package --outdated
```

Update any outdated packages that have stable releases compatible with your target framework.