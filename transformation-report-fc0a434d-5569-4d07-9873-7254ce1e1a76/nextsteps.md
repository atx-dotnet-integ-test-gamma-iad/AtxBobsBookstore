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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- Nullable reference type warnings, which may indicate areas where null handling has changed between the legacy and modern runtime.
- Obsolete API warnings, which may require updating calls to newer equivalents.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config`, including connection strings and application settings.
- Any `<connectionStrings>` or `<appSettings>` entries from the legacy config have been migrated to `appsettings.json` or environment-specific files such as `appsettings.Development.json`.
- If `System.Configuration.ConfigurationManager` was used previously, confirm it has been replaced with `Microsoft.Extensions.Configuration`.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- If Entity Framework is used, confirm the version. Legacy projects often used Entity Framework 6 (`EF6`). The modern equivalent is Entity Framework Core (`EF Core`). These are not drop-in replacements and may require migration of `DbContext`, queries, and model configurations.
- Run any existing database migrations or verify that the schema is compatible with the updated data layer:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, generate an initial migration to validate that EF Core can read the model correctly:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:
- The application starts without exceptions in the console output.
- Database connectivity is established successfully.
- Core application routes and pages load as expected.
- Any authentication or authorization mechanisms function correctly, particularly if ASP.NET Membership or Forms Authentication was used previously, as these have direct replacements in ASP.NET Core Identity.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral differences in the new runtime or issues with the test setup itself.

---

## 7. Manual Functional Validation

Perform manual testing of the core application workflows, including:
- Browsing and searching for books.
- Any user account functionality such as registration and login.
- Any data entry or administrative features.

Pay particular attention to areas that interact with the database or external services, as these are most likely to surface runtime differences from the legacy implementation.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files. From this output directory, the application can be hosted using IIS, Kestrel, or any other supported hosting mechanism compatible with cross-platform .NET.