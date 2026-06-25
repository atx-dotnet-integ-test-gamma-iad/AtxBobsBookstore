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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues even if the build succeeds.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it is using the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or have changed in cross-platform .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm it has been migrated from EF 6 to EF Core. Verify that the `DbContext`, migrations, and connection strings are configured correctly for EF Core.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC or Web Forms project, confirm it has been migrated to ASP.NET Core. Web Forms is not supported in cross-platform .NET and would require a rewrite.
- **`Bookstore.Domain`**: Check for any use of `System.Configuration.ConfigurationManager`, as this requires the `System.Configuration.ConfigurationManager` NuGet package in cross-platform .NET.

---

## 5. Run the Application Locally

Start the web application locally to verify basic functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output and verify that the application loads and core features function as expected.

---

## 6. Verify Database Connectivity

If the application uses a database, confirm the connection string in `appsettings.json` is correctly configured for your target database. If EF Core migrations are in use, apply them:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify that data reads and writes function correctly through the application.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved:

```bash
dotnet test
```

Review any failing tests to determine whether they indicate a regression introduced during migration or a test that requires updating due to API changes.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to your target environment.