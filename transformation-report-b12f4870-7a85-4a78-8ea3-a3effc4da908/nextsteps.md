# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Build Status

No build errors were detected across any of the projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

This indicates the transformation to cross-platform .NET completed without introducing any compilation issues. The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Check the [.NET support lifecycle](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still receiving support.

---

## 2. Restore and Build Locally

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build --configuration Release
```

Resolve any warnings that surface during the build, particularly those related to nullable reference types or deprecated APIs, as these can indicate areas of risk at runtime.

---

## 3. Run Existing Tests

If the solution contains a test project, execute the test suite to verify core behavior is preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider adding unit tests for the domain logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations against a development database to verify they execute correctly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for your target environment.

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the primary workflows of the application, such as browsing, searching, and any data entry flows, to confirm behavior matches the pre-migration baseline.

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently across operating systems. Review the codebase for any usage of:

- `System.Drawing` (limited support on non-Windows without additional packages)
- Windows registry access
- Hardcoded Windows file path separators (`\` instead of `Path.Combine`)
- `System.Web` namespaces, which are not available in cross-platform .NET

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 7. Review NuGet Package Compatibility

Confirm that all NuGet dependencies support the target framework. Run the following to check for outdated or vulnerable packages:

```bash
dotnet list package --outdated
dotnet list package --vulnerable
```

Update packages where necessary, and verify that no packages still target only `.NET Framework`.

---

## 8. Validate Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` and any `Startup.cs` to ensure:

- Middleware is registered in the correct order
- Authentication and authorization configuration is correct
- Static file serving and routing are functioning as expected

Test these areas explicitly during local validation in step 5.