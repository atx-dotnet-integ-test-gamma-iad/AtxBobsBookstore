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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors. Address any warnings that could indicate behavioral differences from the original .NET Framework version.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json` if present) contains the correct connection strings and application settings that were previously in `web.config` or `app.config`.
- Verify that any environment-specific configuration values are correctly set for each target environment.
- Check that `Program.cs` and `Startup.cs` (or the minimal hosting model in `Program.cs` if applicable) correctly register all services, middleware, and database contexts that existed in the original project.

---

## 4. Database Validation

If the project uses Entity Framework, verify the data layer is functioning correctly:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are used, confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated to match the current model:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise the primary workflows (e.g., browsing books, user authentication if present, data entry).
- Check the console output and application logs for any runtime exceptions or unhandled errors.
- Confirm that static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests that cover data access, business logic in `Bookstore.Domain`, and any HTTP-level tests for `Bookstore.Web`.

---

## 7. Manual Functional Testing

Perform manual testing of the following areas, which are commonly affected by .NET Framework to .NET migrations:

- **Authentication and Authorization**: Confirm that any cookie-based or token-based auth mechanisms work as expected under ASP.NET Core.
- **HTTP Handlers and Modules**: If the original project used `IHttpHandler` or `IHttpModule`, verify that the equivalent middleware in ASP.NET Core is behaving correctly.
- **Session and State Management**: Confirm session behavior is consistent with the original application.
- **Third-party Libraries**: Verify that any third-party NuGet packages that were updated during migration behave correctly, as API surfaces may have changed between versions.

---

## 8. Publish the Application

Once validation is complete, publish the application to a folder for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including configuration files and static assets.

Deploy the contents of the publish output to the target hosting environment (IIS, self-hosted, or other). If deploying to IIS, ensure the ASP.NET Core Hosting Bundle is installed on the server and that the application pool is configured to use **No Managed Code**.