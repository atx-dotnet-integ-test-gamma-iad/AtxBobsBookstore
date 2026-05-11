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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any NuGet packages that only support `net4x` target frameworks

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify these issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, such as changes in:

- `HttpClient` behavior
- JSON serialization defaults (`System.Text.Json` vs `Newtonsoft.Json`)
- Entity Framework Core query translation differences

---

## 6. Validate the Web Application

For `Bookstore.Web`, run the application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Key areas to validate:

- **Routing**: Confirm all routes resolve correctly.
- **Database connectivity**: Verify that `Bookstore.Data` connects to the database and that any Entity Framework migrations are up to date.
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Authentication/Authorization**: If the application uses ASP.NET Identity or custom middleware, confirm login and access control work as expected.
- **Static assets**: Confirm that CSS, JavaScript, and image files are served correctly.
- **Configuration**: Ensure `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`.

---

## 7. Review Configuration Migration

.NET Framework projects use `Web.config` or `App.config` for configuration. Modern .NET uses `appsettings.json` and environment variables. Confirm that all configuration values such as connection strings, application settings, and logging configuration have been correctly transferred.

A typical `appsettings.json` structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to your target environment.