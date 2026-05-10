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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are not still referencing `net48` or `netstandard2.0` unless that is intentional for compatibility reasons.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-specific, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

If any are found, replace them with cross-platform equivalents or apply `[SupportedOSPlatform("windows")]` annotations where appropriate.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate that business logic and data access behavior is preserved after migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the core logic in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the following:

- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The database can be reached and updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 7. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality such as browsing, searching, and any data entry forms to confirm behavior matches the original application.

---

## 8. Review Middleware and Configuration

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured, including:

- Authentication and authorization middleware
- Static file serving
- Routing
- Error handling

Legacy `Global.asax`, `Web.config` settings, or HTTP modules should have been replaced with their ASP.NET Core equivalents. Verify none of these legacy files remain active.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output folder to confirm all necessary files are present, then deploy the contents to your target hosting environment.