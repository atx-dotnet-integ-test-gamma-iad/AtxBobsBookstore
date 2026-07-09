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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net472`, `netstandard2.0`, or similar legacy frameworks, update them accordingly and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect each project for any remaining Windows-specific dependencies such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

These will not function on Linux or macOS. Replace or remove them as needed.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify core functionality has not regressed:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic tests for the domain and data layers before proceeding.

---

## 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The connection string in `appsettings.json` is valid and points to the correct database.
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If you were previously using `Database.SetInitializer` or other EF6-specific patterns, ensure they have been replaced with EF Core equivalents.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary user flows such as browsing, searching, and any authentication features.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, verify the following in `Program.cs` or `Startup.cs`:

- Middleware is registered in the correct order.
- Authentication and authorization are configured using ASP.NET Core equivalents.
- Static files, routing, and session handling are properly set up.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.