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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless explicitly required.

---

## 4. Check for Windows-Specific Dependencies

Search the project files and source code for APIs or packages that are Windows-only. Common areas to check:

- Any use of `Microsoft.Win32` namespaces
- References to `System.Windows.Forms` or `System.Drawing` (unless the `EnableWindowsTargeting` flag is intentional)
- Registry access or Windows-specific file path assumptions (e.g., hardcoded `C:\` paths)

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool if a more thorough audit is needed:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Entity Framework Core migration**: If the project previously used EF6, confirm it has been updated to EF Core. Check that `DbContext` and entity configurations are compatible.
- **Connection strings**: Confirm that connection strings in `appsettings.json` are correct and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced.
- **Apply migrations**: If using EF Core migrations, apply them against a test database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.).
- Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

- Confirm that `Web.config` (if it existed) has been replaced by `appsettings.json` and `appsettings.{Environment}.json`.
- Verify that any configuration values previously stored in `Web.config` (connection strings, app settings, custom sections) have been migrated to the new configuration system.
- Ensure environment-specific settings (e.g., development vs. production database connections) are handled via environment variables or environment-specific `appsettings` files.

---

## 9. Validate Static Files and Middleware

For `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline is correctly configured in `Program.cs`:

- Static file serving (`app.UseStaticFiles()`)
- Routing (`app.UseRouting()`)
- Authentication/Authorization middleware if applicable
- Any custom middleware that was previously in `Global.asax` or HTTP modules/handlers

---

## 10. Deploy to Target Environment

Once local validation is complete, deploy the application to the target environment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

If the runtime is not present, download and install it from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).