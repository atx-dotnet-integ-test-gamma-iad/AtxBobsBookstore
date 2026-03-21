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

Ensure no project is still referencing `net48` or any other Windows-only framework unintentionally.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, as these will not function on Linux or macOS. Common areas to check include:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- Any NuGet packages that have a `windows` target framework moniker

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review test results and address any failures that may have been introduced by the migration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correct and use the appropriate format for the target database.
- Any Entity Framework Core migrations are up to date. Run the following to apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) matches the target database.

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly in the new framework.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior. Check the console output for any runtime exceptions or middleware configuration issues.

---

## 8. Review `Program.cs` and Startup Configuration

If the project was migrated from ASP.NET MVC (.NET Framework), the startup configuration may have been converted from `Startup.cs` to the minimal hosting model in `Program.cs`. Verify that:

- Middleware is registered in the correct order.
- Services such as authentication, authorization, and dependency injection are configured properly.
- Static files, routing, and error handling middleware are present.

---

## 9. Verify Configuration Files

Ensure that `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. The `Web.config` file is not used in cross-platform .NET for application configuration.

---

## 10. Test on Target Platform

If the goal is to run on Linux or macOS, perform a test run on that operating system to surface any remaining platform-specific issues that would not appear on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify the application starts and functions correctly.