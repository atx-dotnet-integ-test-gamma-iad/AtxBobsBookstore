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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or earlier, consider updating to `net8.0` (the current LTS release).

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the following:

- The EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.
- Any database migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to a local database for testing:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Web Project Configuration

In `Bookstore.Web`, review the following files for correctness after migration:

- **`Program.cs`** – Confirm the app is using the minimal hosting model appropriate for the target .NET version. Legacy `Startup.cs` patterns are still supported but can be consolidated into `Program.cs`.
- **`appsettings.json`** – Verify connection strings and any environment-specific configuration values are correct.
- **`wwwroot`** – Confirm static assets are present and the folder structure is intact.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually exercise the core functionality of the application, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data reads and writes through the `Bookstore.Data` layer

---

## 7. Run Automated Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review any failing tests. Failures may indicate runtime behavioral differences between the old .NET Framework and the new .NET version that were not caught at compile time.

---

## 8. Publish the Application

Once validation is complete, publish the application to a folder for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.