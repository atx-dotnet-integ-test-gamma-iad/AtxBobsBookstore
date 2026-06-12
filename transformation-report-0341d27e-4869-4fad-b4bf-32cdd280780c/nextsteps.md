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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results to confirm that existing functionality behaves as expected after the migration.

---

## 5. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correct and accessible from the new runtime environment.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify that core application flows (e.g., browsing books, data retrieval) function as expected.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Check for runtime exceptions related to:

- `System.Web` usage (not available in .NET Core/5+)
- Windows-specific APIs such as the registry or certain cryptography providers
- Any third-party libraries that may have been updated and have breaking changes

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if further API compatibility checks are needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.