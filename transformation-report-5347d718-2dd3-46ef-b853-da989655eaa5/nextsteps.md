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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or other Windows-only target frameworks unless there is a specific dependency that requires them.

---

## 4. Check for Windows-Specific APIs

Search the codebase for APIs that are not supported on Linux or macOS. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)

You can use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by migration-related changes.

---

## 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correct and not referencing legacy configuration sources such as `Web.config` or `App.config`.
- If Entity Framework is used, confirm migrations are up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Confirm the EF Core version in use is compatible with the target framework.

---

## 7. Run the Web Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Data is retrieved and displayed as expected from `Bookstore.Data` and `Bookstore.Domain`.
- Authentication and authorization flows work if applicable.

---

## 8. Review Configuration Files

Confirm that `Web.config` or `App.config` settings have been migrated to `appsettings.json` and that the application reads them correctly using `IConfiguration`. Legacy configuration files are not used by ASP.NET Core by default.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to the target environment.