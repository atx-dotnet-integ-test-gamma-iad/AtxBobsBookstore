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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

If an older version such as `net6.0` or `net7.0` is present, consider updating to `net8.0`, which is the current Long-Term Support (LTS) release.

---

## 4. Verify Entity Framework Core Configuration

Since this is a data-driven bookstore application, confirm that `Bookstore.Data` is using **Entity Framework Core** rather than the legacy `System.Data.Entity` (EF6).

- Check that the `DbContext` class inherits from `Microsoft.EntityFrameworkCore.DbContext`.
- Verify that connection strings in `appsettings.json` are correctly configured.
- Run any pending migrations or verify the database schema:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually exercise the primary features of the application, such as browsing, searching, and any data entry forms.

---

## 6. Check for Runtime Compatibility Issues

Even with a clean build, certain issues may only appear at runtime. Pay attention to the following areas:

- **Configuration**: Ensure `appsettings.json` replaces any legacy `Web.config` or `App.config` values. The `ConfigurationManager` API is not available by default in .NET; use `IConfiguration` instead.
- **Static files and routing**: Confirm that `UseStaticFiles()` and routing middleware are correctly registered in `Program.cs` or `Startup.cs`.
- **Authentication/Authorization**: If the application uses ASP.NET Identity or cookie authentication, verify the middleware setup is compatible with ASP.NET Core.

---

## 7. Execute Automated Tests

If the solution contains a test project, run the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying to a production environment.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder and deploy it to your target hosting environment (IIS, Azure App Service, or a Linux server with the .NET runtime installed).