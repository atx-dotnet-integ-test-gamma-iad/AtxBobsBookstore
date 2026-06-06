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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET. Pay particular attention to the following areas:

- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from EF 6 to EF Core. Verify that `DbContext`, migrations, and connection strings are configured correctly for EF Core.
- **Configuration**: Ensure `Web.config` or `App.config` settings have been migrated to `appsettings.json` and are being read via `IConfiguration`.
- **HTTP Pipeline**: If `Bookstore.Web` was previously an ASP.NET MVC project, confirm that middleware, routing, and dependency injection have been properly set up using the ASP.NET Core conventions.

---

## 5. Run Database Migrations

If Entity Framework Core is in use, verify that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to perform a basic smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load, data is retrieved correctly, and no runtime exceptions appear in the console output.

---

## 7. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to confirm existing functionality has not regressed.

```bash
dotnet test --configuration Release
```

Review the test output for any failures and address them before proceeding to deployment.

---

## 8. Review Runtime Warnings and Logs

After running the application, inspect the console and any log files for:

- Deprecation warnings
- Middleware ordering issues
- Unhandled exceptions or null reference errors that may not have surfaced at compile time

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a folder for deployment.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder and confirm all necessary files, static assets, and configuration files are present before deploying to the target environment.