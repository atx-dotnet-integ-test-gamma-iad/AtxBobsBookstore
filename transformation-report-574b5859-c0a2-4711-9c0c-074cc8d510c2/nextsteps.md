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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects — `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` — build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x`, `net5.0`, or `net6.0`, update it to a current long-term support (LTS) version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in newer versions of .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework Core is up to date and that any database migrations are compatible with the current EF Core version. Run the following to check:

  ```bash
  dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **`Bookstore.Web`**: Review any middleware configuration in `Program.cs` or `Startup.cs`. The hosting model changed significantly between .NET Framework and modern .NET. Confirm that the application uses the minimal hosting model correctly if it was migrated to .NET 6+.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality is preserved after the migration.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the framework upgrade rather than logic errors.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs as expected.

```bash
dotnet run --project Bookstore.Web
```

Verify the following manually:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application routes and pages load correctly.

---

## 7. Validate Configuration Files

Check `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously in `Web.config` have been properly migrated to `appsettings.json`.
- The `Web.config` file, if still present, is only being used for IIS-specific settings such as the ASP.NET Core module handler and not for application configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all necessary files are present, including the compiled assemblies, `appsettings.json`, and static web assets.

---

## 9. Deploy to the Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Confirm the following on the target machine:

- The correct .NET runtime is installed. You can verify this with:

  ```bash
  dotnet --list-runtimes
  ```

- If hosting on IIS, ensure the **ASP.NET Core Hosting Bundle** is installed and the IIS site is configured to use the ASP.NET Core module.
- If hosting on Linux, confirm the application has the necessary file permissions and that a process manager such as `systemd` is configured to keep the application running.