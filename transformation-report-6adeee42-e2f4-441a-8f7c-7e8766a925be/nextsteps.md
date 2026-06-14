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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework changes.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and managing books works as expected. Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that all settings previously defined in `Web.config` have been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Key areas to check include:

- Connection strings
- Application settings
- Logging configuration
- Authentication settings

---

## 7. Validate Static Files and Middleware

Confirm that static files (CSS, JavaScript, images) are being served correctly and that all middleware registered in `Program.cs` or `Startup.cs` is ordered appropriately. In ASP.NET Core, middleware order is significant and can affect authentication, routing, and error handling behavior.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.