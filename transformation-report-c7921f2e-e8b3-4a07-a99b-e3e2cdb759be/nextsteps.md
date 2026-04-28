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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check Entity Framework or Data Access Layer

Since a `Bookstore.Data` project is present, verify the following:

- The EF Core version referenced is compatible with the target framework.
- Any database migrations are up to date. Run the following to apply or verify migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core logic:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

Manually test the following areas:

- Application startup with no exceptions.
- Database connectivity and data retrieval.
- Core user-facing functionality such as browsing, searching, and any CRUD operations.
- Authentication and authorization flows, if applicable.

---

## 7. Review Configuration Files

Confirm that `appsettings.json` and `appsettings.Development.json` contain all necessary configuration values that may have previously been stored in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Logging configuration
- Any custom application settings

---

## 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.