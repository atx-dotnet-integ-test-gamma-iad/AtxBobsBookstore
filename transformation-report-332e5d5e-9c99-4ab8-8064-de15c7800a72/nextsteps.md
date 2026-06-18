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

Since all projects compiled without errors, the following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore and Build the Solution

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure there are no warnings that could indicate compatibility issues, such as deprecated APIs or platform-specific code that may have been silently carried over.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and rebuild.

---

## 3. Check for Remaining Windows-Specific Dependencies

Scan the project files and source code for any NuGet packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Win32` registry access
- `System.Windows.Forms`
- `System.Drawing` (without the `System.Drawing.Common` cross-platform package)
- COM interop references

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool to assist:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 4. Run Existing Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and modern .NET (e.g., changes in `HttpContext`, `EntityFramework` vs `EntityFrameworkCore`, or serialization behavior).

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the ORM in use (e.g., Entity Framework Core) is the cross-platform version and not the legacy `EntityFramework` (6.x) package targeting .NET Framework.
- If migrations are used, run them against a development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data
```

- Verify connection strings in `appsettings.json` are correct and no longer rely on `Web.config` or `App.config`.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project uses ASP.NET Core and not legacy ASP.NET (`System.Web`).
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application in a browser and verify that routing, authentication, static files, and data display function as expected.
- Check that middleware configuration in `Program.cs` or `Startup.cs` is complete and correct.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` contains all necessary configuration that was previously in `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., `appsettings.Development.json`) are in place.
- Verify that secrets (connection strings, API keys) are not hardcoded and are managed via environment variables or the .NET Secret Manager:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm a clean release build:

```bash
dotnet publish Bookstore.Web -c Release -o ./publish
```

Review the output directory to ensure all necessary files are present, then deploy the contents of `./publish` to your target hosting environment (e.g., IIS, Linux server, or Azure App Service).