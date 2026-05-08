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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that interact with:
- Database access layers in `Bookstore.Data`
- Domain logic in `Bookstore.Domain`
- HTTP request/response handling in `Bookstore.Web`

If no test projects currently exist, consider adding them to cover critical paths before deploying.

---

## 4. Verify Runtime Behavior Locally

Run the web application locally to confirm it starts and operates correctly.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:
- The application starts without runtime exceptions
- Database connections established in `Bookstore.Data` are functional
- Key pages and routes in `Bookstore.Web` load and respond correctly
- Any authentication or authorization flows work as expected

---

## 5. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` contains the correct connection strings and application settings
- Any settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or environment variables
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are in place where needed

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have behavioral differences on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (limited support outside Windows)
- Windows Registry access
- File path assumptions using backslashes instead of `Path.Combine`
- Windows-specific authentication mechanisms

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific concerns.

---

## 7. Validate the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.