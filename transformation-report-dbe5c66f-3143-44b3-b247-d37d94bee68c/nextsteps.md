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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any `NETSDK` warnings about target framework compatibility
- Obsolete API usage warnings that may indicate areas needing further modernization

---

## 3. Review Project Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Verify Runtime Behavior

Run the web application locally and navigate through its core functionality to confirm runtime behavior matches expectations from the original application.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and homepage rendering
- Database connectivity (if `Bookstore.Data` uses Entity Framework or another ORM)
- Any authentication or authorization flows
- CRUD operations related to the bookstore domain (e.g., listing, adding, editing, deleting books)

---

## 5. Check Entity Framework Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and compatible with the new target framework.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be applied or updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 6. Run Automated Tests

If the solution contains a test project, execute the test suite to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review test output for any failures. Failures may indicate areas where behavior has changed between .NET Framework and the new cross-platform .NET runtime, such as:

- Changes in `System.Web` equivalents
- Differences in configuration loading (`appsettings.json` vs. `Web.config`)
- Differences in HTTP pipeline behavior

---

## 7. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment-specific configuration files (`appsettings.Development.json`, etc.).

Check that the following are properly configured:

- Connection strings
- Application settings
- Logging configuration

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including static assets and configuration files.