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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review the code and project files for any remaining Windows-specific dependencies, such as:

- `Microsoft.Web.Infrastructure`
- `System.Web` references
- Windows Registry access
- COM interop

These will not function correctly on non-Windows platforms. Replace them with cross-platform alternatives where applicable.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is correctly referenced.
- Connection strings are stored in `appsettings.json` rather than `web.config` or `app.config`.
- Any existing migrations are intact and compatible with the current EF Core version.

Run the following to verify migrations can be applied:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, consider generating a new initial migration after confirming the model is correct.

---

## 6. Validate Application Configuration

In `Bookstore.Web`, confirm that:

- `web.config` settings have been migrated to `appsettings.json`.
- Middleware previously configured via `Global.asax` or `Startup.cs` (OWIN) is now correctly configured in `Program.cs` using the minimal hosting model or the standard `WebApplication` builder pattern.
- Authentication, authorization, and session configuration have been updated to use the ASP.NET Core equivalents.

---

## 7. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows, including:

- Browsing and searching for books
- Any user authentication flows
- Data read and write operations

Check the console output and application logs for any runtime exceptions or warnings.

---

## 8. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.

---

## 9. Cross-Platform Verification

If cross-platform support is a requirement, run the application on a non-Windows environment (Linux or macOS) to confirm there are no platform-specific runtime failures. Pay particular attention to:

- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Case-sensitive file system behavior on Linux
- Any P/Invoke or native library calls

---

## 10. Review Deprecated API Usage

Run the build with the analysis level set to ensure deprecated or platform-specific API usage is surfaced.

```bash
dotnet build --configuration Release /p:AnalysisLevel=latest
```

Address any `CA1416` (platform compatibility) or other relevant analyzer warnings before considering the migration complete.