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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Ensure the output shows a successful build for all three projects with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1` or similar outdated monikers, update them accordingly.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

---

## 5. Validate Data Layer (`Bookstore.Data`)

- Confirm that any Entity Framework or database-related packages have been updated to their .NET-compatible versions (e.g., `Microsoft.EntityFrameworkCore` instead of `EntityFramework`).
- If database migrations are used, verify they are still intact and run them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate Domain Layer (`Bookstore.Domain`)

- Review any classes that previously relied on `System.Web` or other Windows-specific namespaces, as these are not available in cross-platform .NET.
- Confirm that serialization, validation attributes, and any third-party libraries used in this layer are compatible with the new target framework.

---

## 7. Validate Web Layer (`Bookstore.Web`)

- If this was previously an ASP.NET Web Forms or MVC project targeting .NET Framework, confirm it has been migrated to ASP.NET Core.
- Check `Program.cs` and any `Startup.cs` for correct middleware configuration.
- Verify that `appsettings.json` contains the necessary configuration that was previously held in `Web.config` or `App.config`.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

---

## 8. Configuration Migration Check

Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or environment variables. Pay particular attention to:

- Connection strings
- Application-specific keys
- Authentication or authorization settings

---

## 9. Static Files and Assets

If the web project serves static files (CSS, JavaScript, images), confirm they are located in the `wwwroot` folder, which is the expected location for static assets in ASP.NET Core.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a target directory:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present, then deploy the contents to your target hosting environment.