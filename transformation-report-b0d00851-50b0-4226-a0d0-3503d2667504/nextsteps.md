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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, verify that the correct EF Core version is referenced and that all migrations are present and up to date.
- Run the following to apply or verify migrations against your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that your connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and ensure no types rely on assemblies that were specific to .NET Framework (e.g., `System.Web`, `System.Drawing` without the compatibility shim).
- Confirm that any serialization attributes or data annotations are sourced from `System.ComponentModel.DataAnnotations` or the appropriate .NET NuGet package.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) are correctly structured for ASP.NET Core.
- Verify that middleware registrations (authentication, authorization, static files, routing) are present and in the correct order.
- Check that configuration sources (`appsettings.json`, environment variables) are loading as expected.
- If the project previously used `System.Web.HttpContext`, confirm all usages have been replaced with `Microsoft.AspNetCore.Http.HttpContext`.

---

## 6. Run the Application Locally

Start the application using the .NET CLI:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the displayed local URL and verify that pages load correctly.
- Test core user flows such as browsing, searching, and any authenticated actions.
- Check the console output and application logs for runtime exceptions or misconfigurations.

---

## 7. Run Automated Tests (If Applicable)

If the solution contains a test project, execute the tests to confirm existing functionality is intact:

```bash
dotnet test
```

Review any failing tests and determine whether the failure is due to the migration or a pre-existing issue.

---

## 8. Review Logging and Error Handling

- Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider (e.g., Serilog, NLog).
- Verify that a global exception handling middleware or filter is in place.
- Check that HTTP error pages (404, 500) are handled appropriately in the ASP.NET Core pipeline.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, static assets, and configuration files are present before deploying to the target environment.