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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific APIs

Since this was a legacy project, verify that no Windows-specific APIs (e.g., the registry, `System.Web`, WCF, or MSMQ) remain in use. You can use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this.

```bash
dotnet tool install -g dotnet-compatibility
```

Pay particular attention to `Bookstore.Web`, as web projects commonly relied on `System.Web` in legacy .NET Framework applications.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests to determine whether they reflect genuine regressions or test code that itself requires updating for .NET compatibility.

---

## 6. Validate Runtime Behavior

Run the web application locally and manually verify core functionality such as:

- Application startup without exceptions
- Database connectivity from `Bookstore.Data`
- Correct rendering of pages served by `Bookstore.Web`
- Domain logic correctness in `Bookstore.Domain`

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the console output and application logs for any runtime exceptions or deprecation warnings that did not surface at compile time.

---

## 7. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced. Entity Framework Core is the supported option for cross-platform .NET. If the project was using Entity Framework 6 (EF6), evaluate whether migration to EF Core is appropriate.

Check that connection strings in `appsettings.json` (or equivalent configuration) are correct and that the database provider package matches your target database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm a clean, self-contained or framework-dependent output is produced.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.