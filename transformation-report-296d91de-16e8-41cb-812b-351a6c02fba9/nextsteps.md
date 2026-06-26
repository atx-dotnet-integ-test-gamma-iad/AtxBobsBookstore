# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation and Testing

Since the solution builds without errors, the following steps are recommended to validate the migrated project before deploying.

---

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for cross-platform compatible versions.

---

### 2. Build the Solution

Perform a full build to confirm there are no warnings that could indicate runtime issues:

```bash
dotnet build --configuration Release
```

Address any warnings related to nullable reference types, obsolete APIs, or platform compatibility.

---

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected:

```bash
dotnet test
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

---

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework is used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema is created or updated as expected.

---

### 5. Run the Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test key user flows such as browsing, searching, and any CRUD operations.
- Check the console output and application logs for any runtime exceptions or warnings.

---

### 6. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references (these are not available in modern .NET)
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)
- Windows-specific registry or file path assumptions
- Any use of `AppDomain` APIs that have been removed or restricted

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if further analysis is needed.

---

### 7. Review Target Framework Monikers

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

---

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.