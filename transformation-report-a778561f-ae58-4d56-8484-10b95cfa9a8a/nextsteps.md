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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility analyzers (e.g., `CA1416`).

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific APIs

If the original project used Windows-specific libraries (e.g., `System.Drawing`, `Microsoft.Win32`, `System.Windows.Forms`), verify that these have either been replaced with cross-platform alternatives or that the appropriate `<RuntimeIdentifier>` or platform guard has been applied.

You can use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 5. Run the Data Layer

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and the database context is configured correctly for the new runtime.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm the connection string in `appsettings.json` is valid for your target environment.

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are due to behavioral changes introduced during migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality such as routing, data access, and rendering.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions, middleware configuration errors, or missing environment variables.

---

## 8. Review `Program.cs` and `Startup` Configuration

If the original project used the older `Startup.cs` pattern, confirm it has been correctly migrated to the minimal hosting model used in .NET 6 and later, or that the existing `Startup.cs` is properly wired into `Program.cs`.

Verify that services such as dependency injection registrations, middleware ordering, and authentication configuration are intact.

---

## 9. Validate `appsettings.json`

Ensure that `appsettings.json` and `appsettings.{Environment}.json` contain all required configuration keys, and that any values previously stored in `Web.config` or `App.config` have been migrated appropriately.