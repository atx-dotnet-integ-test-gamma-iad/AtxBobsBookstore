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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still actively supported.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit the code for any APIs or libraries that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific code
- **COM interop**
- **System.Drawing** (use `System.Drawing.Common` with caution, as it requires native dependencies on non-Windows platforms)

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to help identify platform-specific API usage.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version has been updated to EF Core:

```bash
dotnet ef dbcontext info
```

- Verify that migrations are present and up to date.
- Run a test migration against a development database:

```bash
dotnet ef database update
```

- Confirm that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application's key pages and features.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that database reads and writes function correctly.

---

## 7. Run Existing Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all required files are present.
- Verify the published output runs correctly by executing it directly from the publish folder:

```bash
dotnet ./publish/Bookstore.Web.dll
```