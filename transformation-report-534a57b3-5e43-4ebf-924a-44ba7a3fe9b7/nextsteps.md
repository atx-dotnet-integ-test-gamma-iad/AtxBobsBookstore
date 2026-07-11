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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages that may need to be updated to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no framework version mismatches.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Areas to review manually include:

- **`Bookstore.Data`**: Confirm that Entity Framework or any data access library is using the correct cross-platform compatible version (e.g., EF Core instead of EF 6 for .NET Framework).
- **`Bookstore.Web`**: Confirm that any ASP.NET-specific code (e.g., `HttpContext`, authentication middleware, configuration) has been updated to use ASP.NET Core equivalents.
- **`Bookstore.Domain`**: Check for any use of `System.Web`, `AppDomain`, or other .NET Framework-specific namespaces that may have limited support.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate runtime behavior.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests that cover:

- Data access operations in `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Key pages or API endpoints load correctly.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Authentication and authorization flows work as expected, if applicable.

---

## 7. Validate Configuration Files

Cross-platform .NET uses `appsettings.json` for configuration rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings use `appsettings.Development.json` or environment variables.
- The `Web.config` file, if still present, is only used for IIS-specific hosting settings and not for application configuration.

---

## 8. Verify Static Files and Middleware

In ASP.NET Core, static file serving and middleware must be explicitly configured. In `Bookstore.Web`, confirm that `Program.cs` or `Startup.cs` includes:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication(); // if applicable
app.UseAuthorization();  // if applicable
```

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the hosting environment has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value.