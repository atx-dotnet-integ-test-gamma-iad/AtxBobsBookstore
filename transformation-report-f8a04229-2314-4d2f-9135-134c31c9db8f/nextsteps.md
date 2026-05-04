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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** in `Bookstore.Web`
- **System.Drawing** (partially supported cross-platform via `System.Drawing.Common`)
- Any P/Invoke calls to Windows DLLs

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to surface platform-specific API usage.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the data access configuration is compatible with cross-platform .NET:

- If using **Entity Framework 6**, migrate to **Entity Framework Core**, as EF6 does not fully support cross-platform .NET.
- Verify the database connection strings in `appsettings.json` are correct and do not rely on Windows-integrated security if targeting non-Windows environments.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic smoke tests for:

- Domain model validation logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Key controller actions or Razor pages in `Bookstore.Web`

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without exceptions
- Database reads and writes function correctly
- Authentication and authorization behave as expected

Check the console output and application logs for any runtime warnings or errors.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once the application has been validated locally, publish it using the appropriate runtime identifier for your target environment:

**For Linux:**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

**For Windows:**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime win-x64 --self-contained false
```

Review the contents of the `publish` output folder to confirm all necessary files are present before deploying to the target server.