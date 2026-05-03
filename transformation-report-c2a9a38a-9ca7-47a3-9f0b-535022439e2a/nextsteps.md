# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages reference `netstandard` or `net4x` target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output shows `Build succeeded` with zero errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to the latest Long-Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, there may be runtime dependencies that are Windows-specific. Review the following areas:

- **`Bookstore.Data`**: Check for any use of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which has cross-platform support.
- **`Bookstore.Web`**: Confirm that no Windows Authentication or IIS-specific middleware is being used unless that is intentional.
- **Configuration**: Ensure file paths use `Path.Combine` rather than hardcoded backslashes.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly on your local machine.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that the application loads and functions as expected.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and that the database connection is functional.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If there are pending migrations, apply them:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the connection string in `appsettings.json` points to the correct database instance for your environment.

---

## 7. Execute Existing Tests

If the solution contains any test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test output for any failures. Failures that did not exist prior to migration may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed.

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

The `./publish` directory will contain all files needed to run the application. Verify the contents of this directory before deploying to your target environment.

---

## 9. Validate on Target Operating System

If the goal of the migration is cross-platform support, run the published output on the intended target operating system (Linux or macOS) to confirm there are no platform-specific runtime errors.

```bash
dotnet ./publish/Bookstore.Web.dll
```

Check application logs for any exceptions that may only surface on non-Windows platforms.