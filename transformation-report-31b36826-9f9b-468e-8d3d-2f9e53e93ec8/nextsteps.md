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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any remaining platform-specific API usage (e.g., `System.Web`, Windows Registry, COM interop).
- Nullable reference type warnings if nullable annotations were introduced during transformation.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net4x` or `netstandard2.0`, update it to a modern target framework and re-run the restore and build steps.

---

## 4. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify that the application starts and responds correctly.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Database connectivity works if `Bookstore.Data` uses Entity Framework Core or another ORM. Run any pending migrations if applicable:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 6. Validate Configuration Files

Review `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) to ensure:

- Connection strings are correct and use a supported database provider.
- Any configuration keys that were previously in `Web.config` or `App.config` have been properly migrated to the `appsettings.json` format.
- Secrets are not stored in plain text; use `dotnet user-secrets` for local development.

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all necessary files are present before deploying to the target environment.