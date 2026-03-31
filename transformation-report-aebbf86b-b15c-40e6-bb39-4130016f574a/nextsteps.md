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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x`, `net5.0`, or `net6.0`, consider updating to `net8.0` to align with the current Long-Term Support (LTS) release.

---

## 4. Run Unit and Integration Tests

If the solution contains test projects, execute them to validate that the migrated code behaves as expected.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are caused by migration-related changes, such as updated API behavior or removed APIs in newer .NET versions.

---

## 5. Verify Entity Framework Core Configuration (Bookstore.Data)

Since `Bookstore.Data` is a data layer project, confirm the following:

- The EF Core version referenced is compatible with the target framework.
- Database migrations are up to date. Run the following command to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be updated or recreated, use:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate Runtime Behavior of Bookstore.Web

Start the web application and verify that it runs without runtime exceptions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts and listens on the expected port.
- Key pages and routes load without errors.
- Any middleware configured in `Program.cs` or `Startup.cs` is functioning correctly.
- If `Startup.cs` still exists, consider consolidating it into the minimal hosting model using `Program.cs`, which is the standard pattern for .NET 6 and later.

---

## 7. Check for Removed or Changed APIs

Review the code for use of any APIs that were deprecated or removed in newer versions of .NET. Microsoft provides a compatibility analyzer that can assist with this. Ensure the following NuGet package is referenced in projects where applicable:

```xml
<PackageReference Include="Microsoft.DotNet.Compatibility" Version="*" />
```

Additionally, consult the [.NET breaking changes documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/breaking-changes) relevant to the version you migrated from and to.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) are correctly structured and contain valid connection strings and application settings for the target environment.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.