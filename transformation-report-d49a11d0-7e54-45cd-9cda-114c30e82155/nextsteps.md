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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** configurations in `Bookstore.Web`
- **File path separators** — replace hardcoded backslashes with `Path.Combine` or `Path.DirectorySeparatorChar`
- **Entity Framework** provider — confirm the database provider (e.g., SQL Server, SQLite, PostgreSQL) is configured correctly in `Bookstore.Data` for the target environment

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly on the development machine.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and verify the application loads and functions as expected.

---

## 6. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that any pending migrations are applied and that the database connection string in `appsettings.json` is correct for the target environment.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the `dotnet-ef` tool is not installed, install it with:

```bash
dotnet tool install --global dotnet-ef
```

---

## 7. Execute Unit Tests

If the solution contains test projects, run them to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 8. Publish the Application

Once validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

The `./publish` directory will contain all files needed to deploy the application. Confirm the output directory contains the expected binaries and static assets before deploying to the target environment.