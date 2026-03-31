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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime, such as changes in:

- Globalization and culture handling
- File path separators
- Reflection behavior
- Entity Framework query translation (if applicable)

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- The connection string in your configuration file (`appsettings.json`) is correct and accessible from the new runtime environment.
- If Entity Framework is used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new stack:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality works as expected, including:

- Page rendering
- Data retrieval and display
- Form submissions
- Authentication and authorization flows, if applicable

---

## 6. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contain all settings that were previously held in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Logging configuration
- Application-specific settings
- Any third-party service keys or endpoints

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require replacement in cross-platform .NET:

- `System.Web` references (should no longer be present)
- Windows Registry access
- Windows-specific file path assumptions
- `HttpContext` usage patterns specific to the old ASP.NET pipeline

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.