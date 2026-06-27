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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`. Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or another out-of-support framework, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (EF6) package. Run any pending migrations and verify the database schema.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC (System.Web) project, confirm that all middleware, routing, and configuration has been properly migrated to the ASP.NET Core model. Check `Program.cs` and any `Startup.cs` for correctness.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading code behaves as expected under the new runtime.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate runtime behavior.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic smoke tests that cover:

- Database connectivity and basic CRUD operations via `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any authenticated actions, to confirm end-to-end functionality.

---

## 7. Review Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain the correct values for:

- Database connection strings
- Any API keys or external service endpoints
- Logging configuration

Ensure that secrets are not stored directly in source-controlled configuration files. Use the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment artifact.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --runtime linux-x64 \
  --self-contained true \
  --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment.