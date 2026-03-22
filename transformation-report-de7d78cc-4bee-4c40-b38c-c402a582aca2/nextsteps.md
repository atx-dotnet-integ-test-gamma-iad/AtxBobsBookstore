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

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and code in each project for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Any packages marked with the `windows` platform target in their package metadata

Run the following to get a compatibility report:

```bash
dotnet tool install -g dotnet-apicompat
```

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 6. Validate the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- Application startup and routing
- Database connectivity from `Bookstore.Data`
- Domain logic behavior from `Bookstore.Domain`
- Any configuration values previously stored in `Web.config` that should now be in `appsettings.json`

---

## 7. Review Configuration Migration

If the original project used `Web.config` or `App.config`, confirm that all relevant settings have been moved to `appsettings.json` or environment variables. Key areas include:

- Connection strings
- Application settings
- Authentication configuration
- Logging settings

---

## 8. Database Validation

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

Confirm that the database schema matches expectations after applying any pending migrations.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.