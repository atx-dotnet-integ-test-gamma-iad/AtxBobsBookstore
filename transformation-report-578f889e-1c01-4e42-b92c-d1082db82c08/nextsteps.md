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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs or libraries remain that would prevent the application from running cross-platform. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** configurations in `Bookstore.Web`
- **System.Drawing** (replaced by cross-platform alternatives like `SkiaSharp` or `ImageSharp`)
- Any P/Invoke calls to Windows DLLs

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific code.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., Entity Framework Core) is correctly configured and referencing a compatible NuGet package version.
- Connection strings in `appsettings.json` are correct and accessible in the new environment.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication, checkout) to confirm expected behavior.

---

## 7. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests. Failures may indicate behavioral differences between the legacy .NET Framework runtime and modern .NET that need to be addressed in the application code.

---

## 8. Review Application Configuration

Cross-platform .NET uses `appsettings.json` and environment variables rather than `Web.config` or `App.config`. Confirm the following:

- All configuration values previously in `Web.config` have been migrated to `appsettings.json`.
- Environment-specific settings (e.g., connection strings, API keys) are handled via `appsettings.{Environment}.json` or environment variables.
- The `Startup.cs` or `Program.cs` correctly reads and applies these configurations.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.