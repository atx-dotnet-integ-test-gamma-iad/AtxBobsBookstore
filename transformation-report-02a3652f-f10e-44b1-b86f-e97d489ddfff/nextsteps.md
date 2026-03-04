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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Runtime Behavior

Some issues do not surface at compile time but appear at runtime. Pay attention to the following areas:

- **Entity Framework or data access**: Verify that database connections, migrations, and queries execute correctly. If the project uses Entity Framework, confirm that the correct EF Core provider is configured and that any pending migrations are applied:

  ```bash
  dotnet ef database update --project Bookstore.Data
  ```

- **Configuration**: Confirm that `appsettings.json` or environment-based configuration is correctly replacing any legacy `Web.config` or `App.config` settings.

- **Authentication and Authorization**: If the application uses ASP.NET Identity or custom authentication middleware, verify that login, session, and cookie behavior works as expected.

- **Static files and routing**: Run the application locally and navigate through its primary routes to confirm pages render correctly and static assets load.

### 5. Run the Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:

- The home page loads without errors.
- Data-driven pages retrieve and display records correctly.
- Forms submit and persist data as expected.
- Error pages and logging behave appropriately.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET (for example, `net8.0`). Ensure all three projects target a consistent framework version to avoid interoperability issues.

### 7. Address Any Remaining Warnings

After building and running, review any compiler warnings or runtime deprecation notices. Common post-migration concerns include:

- Use of obsolete APIs that existed in .NET Framework but are deprecated in modern .NET.
- Platform-specific code paths (e.g., Windows registry access, COM interop) that may not function on non-Windows platforms.
- Serialization behavior differences, particularly with `System.Text.Json` versus `Newtonsoft.Json`.