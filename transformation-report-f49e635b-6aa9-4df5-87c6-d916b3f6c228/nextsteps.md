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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that were not fully modernized during transformation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic unit tests for the core domain logic in `Bookstore.Domain` to establish a baseline.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:
- Application starts without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- All routes and pages in `Bookstore.Web` load correctly
- Any data read/write operations function as intended

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (for example, `net8.0`). Avoid targeting `net6.0` or `net7.0` as these are out of support.

### 6. Check for Windows-Specific Dependencies

Even when a build succeeds, some APIs are only available on Windows. Search the codebase for usages of APIs such as:

- `System.Web` namespaces
- Windows Registry access
- Windows-specific file path assumptions

Run the application on your target platform (Linux or macOS if applicable) to surface any platform-specific runtime errors that would not appear during a Windows build.

### 7. Review Entity Framework Configuration

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (for example, `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment and configure the web server (such as IIS, Nginx, or Apache with a reverse proxy) to serve the application.