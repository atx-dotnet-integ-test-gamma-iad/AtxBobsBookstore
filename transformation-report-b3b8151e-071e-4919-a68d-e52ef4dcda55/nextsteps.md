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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

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
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netstandard2.0`, update it to align with the rest of the solution.

---

## 4. Check for Windows-Specific Dependencies

Since this is a Bookstore web application, inspect the code and project references for any APIs or libraries that are Windows-only. Common examples include:

- `System.Drawing` (use `System.Drawing.Common` with a runtime check or migrate to an alternative like `SkiaSharp`)
- Windows Registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm it has been migrated from EF 6 to EF Core.
- Run any existing database migrations to ensure they apply cleanly.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured and that `web.config` connection strings have been moved over if they were not already.

---

## 6. Validate the Domain Layer

In `Bookstore.Domain`, confirm that:

- All models and business logic compile without warnings.
- Any serialization attributes (e.g., `[Serializable]`) that were relevant to .NET Framework binary serialization have been reviewed, as `BinaryFormatter` is disabled by default in .NET 5+.

---

## 7. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- If this was an ASP.NET MVC project, verify it has been correctly migrated to ASP.NET Core MVC.
- Check that `Startup.cs` or `Program.cs` correctly registers services, middleware, and routing.
- Confirm that any `HttpContext`, `Session`, or `TempData` usage is compatible with ASP.NET Core.
- Verify that `appsettings.json` contains all configuration values previously held in `web.config` or `app.config`.

---

## 8. Run the Application Locally

Start the application and perform basic smoke testing.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify:

- The home page loads without errors.
- Database connectivity is functional (e.g., book listings load correctly).
- Authentication and authorization behave as expected, if applicable.

---

## 9. Run Existing Tests

If a test project exists in the solution, execute all tests to confirm no regressions were introduced.

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration issues or pre-existing problems.

---

## 10. Review Logging and Error Handling

Confirm that logging has been migrated from any legacy provider (e.g., `log4net`, `NLog` configured via `web.config`) to use `Microsoft.Extensions.Logging` or a compatible provider configured through `appsettings.json`.