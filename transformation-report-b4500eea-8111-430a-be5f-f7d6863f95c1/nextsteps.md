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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process. If any packages are flagged as incompatible with the new target framework, update them to versions that support the target framework (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., `CA1416`)

Address any warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net5.0` or `net6.0`, consider updating to `net8.0` (the current LTS release).

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the following areas for any remaining Windows-specific dependencies:

- **`Bookstore.Data`**: Check for any usage of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which is cross-platform.
- **`Bookstore.Web`**: Confirm that no Windows-only authentication schemes (e.g., Windows Authentication / NTLM) are being used unless intentionally required.
- **`Bookstore.Domain`**: Check for any use of `System.Drawing` (GDI+), which has limited cross-platform support. Replace with a library such as `SkiaSharp` or `ImageSharp` if needed.

---

## 5. Run the Application Locally

Start the web application to confirm it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following:
- The application starts without exceptions.
- Key pages and routes load correctly.
- Database connectivity is functional (check connection strings in `appsettings.json`).

---

## 6. Validate Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration:

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by:
- Behavioral differences in the new framework version.
- Changed APIs or removed types.
- Configuration or dependency injection differences.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration files are correct for the target environment:

- Connection strings reference the correct database server and credentials.
- Any environment-specific settings (e.g., `appsettings.Production.json`) are present and accurate.
- Logging configuration is appropriate for the deployment environment.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target server.