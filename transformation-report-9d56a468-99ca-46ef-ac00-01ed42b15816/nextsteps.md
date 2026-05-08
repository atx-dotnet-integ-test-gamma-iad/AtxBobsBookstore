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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings, even if there are no errors. Warnings related to nullable reference types, obsolete APIs, or platform compatibility should be reviewed and addressed.

### 3. Run Unit Tests

If the solution contains test projects, run them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by test setup issues.

### 4. Verify Data Layer

Since `Bookstore.Data` is likely responsible for database access, verify the following:

- If using Entity Framework Core, confirm that migrations are up to date by running:
  ```bash
  dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
  ```
- Apply any pending migrations to a test database:
  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```
- Confirm that connection strings in `appsettings.json` or environment-specific configuration files are correct for the target environment.

### 5. Run the Web Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

### 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `appsettings.json` contains all necessary settings previously found in `Web.config` or `App.config`.
- Any environment-specific overrides are present in `appsettings.Development.json` or equivalent files.
- Static files, bundling, and routing are configured correctly in `Program.cs` or `Startup.cs`.

### 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific registry or file path assumptions.
- Any third-party libraries that may not have cross-platform support.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target environment according to your existing deployment process.