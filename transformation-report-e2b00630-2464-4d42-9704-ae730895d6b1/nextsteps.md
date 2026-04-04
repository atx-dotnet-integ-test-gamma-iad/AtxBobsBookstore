# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Pay particular attention to:

- Tests covering data access logic in `Bookstore.Data`, as Entity Framework behavior can differ between .NET Framework and modern .NET.
- Tests covering domain logic in `Bookstore.Domain`.
- Any integration tests in `Bookstore.Web` that exercise HTTP endpoints or middleware.

If no tests currently exist, consider writing basic smoke tests to verify core functionality before proceeding.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your connection strings are correctly configured in `appsettings.json` and that any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project was migrated from Entity Framework 6 (used in .NET Framework) to Entity Framework Core, review the following:

- LINQ query behavior differences between EF6 and EF Core.
- Any use of `ObjectContext`, lazy loading configuration, or database initializers that may need to be updated.

---

## 5. Review Configuration Files

Modern .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm that:

- All connection strings have been moved to `appsettings.json`.
- Any application settings previously in `<appSettings>` have been migrated.
- Environment-specific overrides are handled via `appsettings.{Environment}.json`.

---

## 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Routing behaves as expected.
- Pages or API endpoints return correct responses.
- Static files are served correctly if applicable.

Review the console output and application logs for any runtime errors or warnings.

---

## 7. Review Middleware and Startup Configuration

In modern .NET, application startup is configured in `Program.cs`. Confirm that the following have been correctly migrated:

- Authentication and authorization middleware.
- Custom HTTP handlers or modules that may have existed in the legacy project (these do not have a direct equivalent and must be rewritten as middleware).
- Any dependency injection registrations.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the target server has the appropriate .NET runtime installed. You can verify the required runtime version from the `.csproj` or by running:

```bash
dotnet --info
```

If hosting on IIS, ensure the ASP.NET Core Hosting Bundle is installed and the application pool is configured to use **No Managed Code**.