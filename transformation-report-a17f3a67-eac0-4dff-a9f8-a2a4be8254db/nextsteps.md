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

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build. Pay particular attention to:

- Obsolete API usage warnings
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that the data layer functions correctly:

- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target .NET version.
- If the project uses EF Core migrations, run the following to verify migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Test database connectivity against a local or development database instance.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- All routes and pages load as expected.
- Any authentication or session-based functionality works correctly.
- Static assets (CSS, JavaScript, images) are served properly.

### 6. Review `appsettings.json` and Configuration

Legacy projects often stored configuration in `Web.config` or `App.config`. Confirm that all necessary configuration values (connection strings, app settings, etc.) have been migrated to `appsettings.json` or environment variables, and that they are being read correctly at runtime.

### 7. Check for Runtime-Only Issues

Some issues do not surface at build time but appear at runtime. Exercise all major application workflows, including:

- Browsing and searching for books
- Any create, update, or delete operations
- Any user account or authentication flows

Monitor application logs during this process for unhandled exceptions or unexpected behavior.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The compiled assemblies
- The `appsettings.json` file (and any environment-specific variants)
- Static web assets under `wwwroot`

### 3. Deploy to Target Environment

Copy the contents of the publish output to your target server or hosting environment. Ensure the target machine has the correct .NET runtime installed:

```bash
dotnet --info
```

The runtime version on the target machine must be compatible with the version targeted by the solution.