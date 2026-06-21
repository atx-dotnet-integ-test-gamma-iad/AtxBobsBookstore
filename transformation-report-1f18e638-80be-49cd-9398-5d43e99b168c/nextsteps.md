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

The following steps outline how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are approaching or have reached end of support.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs are being used unintentionally. Run the .NET Compatibility Analyzer if not already applied:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output files for any failed or skipped tests. Investigate failures that may be caused by behavioral differences between .NET Framework and cross-platform .NET.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Entity Framework Core**: If the project uses EF Core, confirm the correct provider package is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- **Connection Strings**: Confirm that connection strings in `appsettings.json` are valid and accessible from the new runtime environment.
- **Migrations**: If EF Core migrations are used, verify they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:
- Application startup without exceptions
- Routing and page rendering
- Database read and write operations
- Authentication and authorization flows, if applicable
- Static file serving (CSS, JavaScript, images)

---

## 8. Review Configuration and Middleware

Inspect `Program.cs` (and `Startup.cs` if still present) to ensure middleware is configured correctly for cross-platform .NET. Legacy patterns such as `UseStartup<Startup>()` can be consolidated into the minimal hosting model if desired, though this is optional.

Confirm that environment-specific configuration files (e.g., `appsettings.Development.json`) are present and correctly structured.

---

## 9. Validate Logging

Ensure that the logging configuration in `appsettings.json` is functional. The default `Microsoft.Extensions.Logging` setup should work without changes, but any third-party logging providers (e.g., log4net, NLog) should be verified for .NET compatibility.

---

## 10. Publish the Application

Once local validation is complete, produce a published output to verify the application can be packaged correctly.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including configuration files and static assets.