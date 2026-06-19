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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses Entity Framework, verify that the correct EF Core version is referenced (not the legacy `EntityFramework` package).
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data
```

- If migrations do not exist yet, scaffold them from the current model:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

---

## 4. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior are intact:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- `HttpContext` and web-related abstractions
- Configuration and `appsettings.json` vs. `web.config`
- Dependency injection patterns

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting) are correctly configured.
- Verify that middleware, routing, and dependency injection registrations are complete.
- Check that `appsettings.json` contains all configuration values previously held in `web.config`, including connection strings.

Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any authenticated routes) to confirm runtime behavior is correct.

---

## 6. Review Static Files and Bundling

If the project previously used `System.Web.Optimization` (BundleConfig), this is not available in modern .NET. Verify that static file serving is configured in the middleware pipeline and consider using a supported alternative such as `WebOptimizer` or a front-end build tool if bundling is required.

---

## 7. Check Authentication and Authorization

If the application uses authentication, confirm the middleware is correctly configured. Legacy `FormsAuthentication` is not available in modern .NET. It should be replaced with ASP.NET Core cookie authentication or another supported scheme, configured in the middleware pipeline.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including runtime configuration and static assets, are present before deploying to the target environment.