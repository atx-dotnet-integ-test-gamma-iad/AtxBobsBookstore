# Next Steps

## Validation and Testing

### 1. Verify the Build
Since the solution shows no build errors across all three projects (Bookstore.Data, Bookstore.Web, and Bookstore.Domain), your first step is to confirm the build succeeds consistently:

```bash
dotnet clean
dotnet restore
dotnet build --configuration Release
```

### 2. Review Project Dependencies
Verify that project references are correctly established:

```bash
dotnet list app/Bookstore.Web/Bookstore.Web.csproj reference
dotnet list app/Bookstore.Data/Bookstore.Data.csproj reference
dotnet list app/Bookstore.Domain/Bookstore.Domain.csproj reference
```

Ensure the dependency chain is correct (typically: Web → Data → Domain or Web → Domain ← Data).

### 3. Examine NuGet Package Compatibility
Review the `.csproj` files to ensure all NuGet packages have cross-platform compatible versions:

- Check for any packages marked with warnings during restore
- Verify Entity Framework (if used) is EF Core, not EF6
- Confirm ASP.NET packages are ASP.NET Core versions
- Look for any Windows-specific dependencies that may need alternatives

### 4. Test Database Connectivity
If Bookstore.Data contains database access code:

- Update connection strings to use cross-platform formats
- Test database migrations if using Entity Framework Core
- Verify that database provider packages are installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

### 5. Run Unit Tests
Execute any existing unit tests to verify functionality:

```bash
dotnet test
```

If tests fail, review:
- File path separators (use `Path.Combine` instead of hardcoded slashes)
- Configuration file loading mechanisms
- Any platform-specific API calls

### 6. Launch and Test the Application
Start the web application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Test the following:
- Application starts without runtime errors
- All web pages load correctly
- Database operations function properly
- Static files are served correctly
- Authentication/authorization works as expected

### 7. Cross-Platform Verification
Test the application on different operating systems if possible:

**On Linux/macOS:**
```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Common issues to check:
- File path case sensitivity (Linux/macOS are case-sensitive)
- Line ending differences (CRLF vs LF)
- Environment variable access patterns

### 8. Review Configuration Files
Examine and update configuration files:

- `appsettings.json` - ensure paths and connection strings are cross-platform
- `launchSettings.json` - verify URLs and environment settings
- Remove or update any `web.config` files (not used in .NET Core/5+)

### 9. Check for Code-Level Issues
Even without build errors, review the code for:

- `System.Web` namespace usage (should be replaced with `Microsoft.AspNetCore`)
- `HttpContext.Current` calls (use dependency injection instead)
- `Server.MapPath` usage (use `IWebHostEnvironment.ContentRootPath`)
- Registry access or Windows-specific APIs
- File I/O operations that may assume Windows paths

### 10. Performance and Security Review
- Review middleware pipeline configuration in `Startup.cs` or `Program.cs`
- Verify HTTPS redirection is configured
- Check that CORS policies are properly set if needed
- Ensure static file serving is configured correctly

### 11. Prepare for Deployment
Once local testing is complete:

- Document the target framework version (net6.0, net7.0, net8.0, etc.)
- Create a publish profile:
  ```bash
  dotnet publish -c Release -o ./publish
  ```
- Test the published output locally before deploying
- Document any environment-specific configuration requirements
- Update deployment documentation with new .NET runtime requirements

### 12. Final Verification Checklist
- [ ] Solution builds without errors or warnings
- [ ] All unit tests pass
- [ ] Application runs locally without errors
- [ ] Database connectivity works
- [ ] All major features function correctly
- [ ] Configuration is externalized appropriately
- [ ] No Windows-specific code remains in critical paths
- [ ] Published application runs successfully