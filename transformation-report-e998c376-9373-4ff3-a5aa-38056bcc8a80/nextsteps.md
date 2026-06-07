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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build output reports **0 Error(s)** for all three projects before proceeding.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still under active or LTS support.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in .NET. If any references remain, they will need to be replaced with ASP.NET Core equivalents.
- **Entity Framework** — if the project uses EF6, consider migrating to EF Core. Verify that your `DbContext` and model configurations are compatible.
- **Configuration** — `Web.config` and `App.config` are replaced by `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.
- **Authentication/Authorization** — any legacy `FormsAuthentication` or `WindowsIdentity` usage should be replaced with ASP.NET Core middleware.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) to surface any remaining compatibility issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify runtime behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing integration or unit tests that cover the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before deploying.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data`
- Core domain workflows (e.g., browsing, searching, and managing books)
- Any authentication or authorization flows

---

## 7. Validate the Database Connection

Confirm that the connection string in `appsettings.json` (or `appsettings.Production.json`) is correctly configured for the target environment. If the project uses EF Core migrations, apply them to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to your target host (IIS, Linux server, Azure App Service, etc.) according to the platform's hosting documentation.