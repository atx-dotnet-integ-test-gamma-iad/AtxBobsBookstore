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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their latest stable versions using:

```bash
dotnet list package --outdated
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (not EF6) is being used. Check the `.csproj` for references to `Microsoft.EntityFrameworkCore` rather than `EntityFramework`.
- Verify that the `DbContext` class and all entity configurations are compatible with EF Core conventions.
- Run any existing database migrations or create a new initial migration to validate the model:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Check that no Windows-specific APIs or `System.Web` references remain in this project.
- Confirm all class libraries are using portable, cross-platform APIs.
- Run any unit tests that cover domain logic:

```bash
dotnet test
```

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project is using ASP.NET Core and not legacy `System.Web`-based ASP.NET.
- Check `Program.cs` and `Startup.cs` (if present) for correct middleware configuration, including routing, authentication, and static files.
- Verify `appsettings.json` contains the correct connection strings and configuration values that were previously in `Web.config`.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify core functionality such as page rendering, database reads/writes, and authentication if applicable.

---

## 7. Cross-Platform Verification

If cross-platform support is a goal, test the build and run steps on a non-Windows operating system (Linux or macOS) to surface any remaining platform-specific issues such as:

- Case-sensitive file paths
- Windows registry access
- `System.Drawing` or other Windows-only dependencies

---

## 8. Review and Remove Legacy Configuration Files

Ensure the following legacy files are no longer being used and can be safely removed if present:

- `Web.config`
- `packages.config`
- `Global.asax`

Configuration should now reside in `appsettings.json` and middleware registered in `Program.cs`.