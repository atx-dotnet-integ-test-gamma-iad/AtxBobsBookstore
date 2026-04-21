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

- Confirm that your database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is the correct version for your target .NET runtime.
- If the project uses Entity Framework, run the following to verify that migrations are consistent with the current model:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Check that connection strings in `appsettings.json` are correctly configured for your target environment.

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and ensure no types are relying on APIs that were removed or changed in cross-platform .NET (e.g., certain `System.Runtime` or `System.Web` types).
- Run any existing unit tests targeting the domain layer:

```bash
dotnet test
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (if present) follow the expected structure for ASP.NET Core.
- Verify that middleware, routing, and dependency injection configurations are correct.
- Check that static files, views, and Razor pages (if applicable) are located in the expected directories (`wwwroot`, `Views`, `Pages`).
- Run the application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the application in a browser and manually verify that core functionality (e.g., browsing books, authentication if present) works as expected.

---

## 6. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.Development.json` contain all necessary configuration values that were previously held in `Web.config` or `App.config`.
- Confirm that any environment-specific settings are properly handled using the `IConfiguration` system.

---

## 7. Run All Tests

If the solution contains test projects, execute the full test suite:

```bash
dotnet test --configuration Release --logger trx
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to your target environment.