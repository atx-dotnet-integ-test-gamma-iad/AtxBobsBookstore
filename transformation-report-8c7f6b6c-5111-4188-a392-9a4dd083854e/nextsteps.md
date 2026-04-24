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

Review the output for any warnings that, while not blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which commonly surface runtime issues after migration even when the build succeeds:

- **Database connectivity**: Verify that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (`appsettings.json`) and confirm the correct provider (e.g., SQL Server, SQLite) is referenced.
- **Entity Framework migrations**: If the project uses Entity Framework, confirm that existing migrations are compatible with the new runtime by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration system**: The legacy `System.Configuration` (e.g., `Web.config`, `App.config`) has been replaced by `Microsoft.Extensions.Configuration` in modern .NET. Confirm that all configuration values previously read from `Web.config` are now present and correctly read from `appsettings.json`.
- **Authentication and authorization**: If the application uses ASP.NET Membership, Forms Authentication, or similar legacy mechanisms, these are not directly supported in modern ASP.NET Core and will require manual replacement with ASP.NET Core Identity or another supported mechanism.
- **HTTP modules and handlers**: These do not exist in ASP.NET Core. Confirm they have been replaced with the appropriate middleware.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy moniker, update it accordingly.

### 6. Check for Removed or Changed APIs

Some .NET Framework APIs were removed or changed in cross-platform .NET. Run the .NET Upgrade Analyzer or the compatibility analyzer to surface any remaining API usage concerns:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

Review any analyzer diagnostics that are emitted during the build.

### 7. Deployment

Once the application has been validated locally, publish it using the following command, targeting your intended runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime win-x64 --self-contained false
```

Adjust the `--runtime` flag to match your target environment (e.g., `linux-x64` for Linux-based hosting). The output will be placed in the `publish` directory and can be deployed to IIS, a web server, or any compatible hosting environment.