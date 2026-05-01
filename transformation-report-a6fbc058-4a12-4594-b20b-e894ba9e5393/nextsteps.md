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

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review all test results. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Entity Framework Core Migrations (if applicable)

Since the solution includes a `Bookstore.Data` project, it likely uses Entity Framework. Verify that your migrations are compatible with the new EF Core version:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated, apply the migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` for the following:

- **Connection strings** are correctly formatted for the target database provider.
- Any settings that were previously in `Web.config` have been properly migrated to the `appsettings.json` format.
- Environment-specific configuration is handled using the appropriate `appsettings.{Environment}.json` files.

---

## 6. Run the Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Manually navigate through the key areas of the application, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data entry and persistence operations

Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 8. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that have changed behavior between .NET Framework and modern .NET. Common areas to check include:

- `HttpContext` and request/response handling in `Bookstore.Web`
- Any use of `System.Web` namespaces, which are not available in modern .NET
- Serialization behavior differences in `System.Text.Json` versus `Newtonsoft.Json`

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.