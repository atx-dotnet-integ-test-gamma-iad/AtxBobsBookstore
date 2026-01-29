# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Validation and Testing

Based on the information provided, your solution appears to have completed the transformation to cross-platform .NET without any build errors. This is a positive outcome, but several validation steps are necessary before considering the migration complete.

### 1. Verify Build Configuration

```bash
# Clean and rebuild the entire solution
dotnet clean
dotnet build --configuration Release
```

Ensure both Debug and Release configurations build successfully across all projects.

### 2. Validate Project Dependencies

Review the project dependency chain:
- **Bookstore.Data** (least independent)
- **Bookstore.Web** 
- **Bookstore.Domain** (most independent)

Check that:
- All project references are correctly updated to the new SDK-style format
- NuGet package versions are compatible with the target framework
- No legacy .NET Framework-specific packages remain

### 3. Update Target Framework

Verify each `.csproj` file specifies the appropriate target framework:

```xml
<TargetFramework>net8.0</TargetFramework>
<!-- or -->
<TargetFramework>net6.0</TargetFramework>
```

### 4. Test Application Functionality

#### Unit and Integration Tests

```bash
# Run all tests in the solution
dotnet test
```

If test projects exist, ensure:
- All tests pass on the new framework
- Test dependencies (xUnit, NUnit, MSTest) are updated to compatible versions
- Mock frameworks and test utilities function correctly

#### Database Connectivity (Bookstore.Data)

- Test database connections and migrations
- Verify Entity Framework Core (if used) operates correctly
- Validate data access layer functionality
- Check connection string formats for cross-platform compatibility

#### Web Application (Bookstore.Web)

- Run the web application locally:
  ```bash
  cd app/Bookstore.Web
  dotnet run
  ```
- Test all HTTP endpoints and routes
- Verify static file serving works correctly
- Check authentication and authorization flows
- Validate view rendering (if using Razor/MVC)
- Test API responses (if applicable)

#### Domain Logic (Bookstore.Domain)

- Validate business logic executes as expected
- Test domain models and entities
- Verify any domain services or validators

### 5. Review Configuration Files

Check and update:
- `appsettings.json` and environment-specific variants
- Connection strings for cross-platform path formats
- Logging configuration
- Any file path references (use `Path.Combine` instead of hardcoded separators)

### 6. Platform-Specific Testing

Test the application on multiple platforms:

**Windows:**
```bash
dotnet run
```

**Linux/macOS:**
```bash
dotnet run
```

Verify:
- File path handling works across platforms
- Case sensitivity issues are resolved (Linux/macOS are case-sensitive)
- Line ending differences don't cause issues

### 7. Runtime Compatibility Checks

Review code for:
- Removed or deprecated APIs from .NET Framework
- Windows-specific APIs that need cross-platform alternatives
- Registry access (Windows-only)
- Windows-specific cryptography or security APIs
- COM interop or P/Invoke calls

### 8. Performance Validation

- Compare application performance metrics with the legacy version
- Monitor memory usage patterns
- Check startup time and response times
- Profile database query performance

### 9. Dependency Audit

```bash
# List all package dependencies
dotnet list package --include-transitive

# Check for deprecated packages
dotnet list package --deprecated

# Check for vulnerable packages
dotnet list package --vulnerable
```

Update any deprecated or vulnerable packages to their latest stable versions.

### 10. Documentation Updates

Update project documentation:
- README files with new build instructions
- Development environment setup for .NET SDK
- Deployment procedures for cross-platform .NET
- Any changed configuration requirements

## Deployment Preparation

### 1. Publish the Application

Test the publish process:

```bash
# Self-contained deployment
dotnet publish -c Release -r win-x64 --self-contained true

# Framework-dependent deployment
dotnet publish -c Release
```

### 2. Deployment Validation

- Deploy to a staging environment that matches production
- Run smoke tests on the deployed application
- Verify all external dependencies (databases, APIs, file systems) are accessible
- Check application logs for any warnings or errors

### 3. Rollback Plan

- Document the rollback procedure to the legacy version
- Maintain the legacy codebase until the new version is stable in production
- Create backup points before deployment

## Final Checklist

- [ ] Solution builds without errors in Debug and Release modes
- [ ] All unit and integration tests pass
- [ ] Web application runs and serves requests correctly
- [ ] Database operations function properly
- [ ] Application tested on target deployment platforms
- [ ] No deprecated or vulnerable packages remain
- [ ] Configuration files updated for new environment
- [ ] Performance meets or exceeds legacy version
- [ ] Documentation updated
- [ ] Staging deployment successful
- [ ] Rollback plan documented

Once all items are verified, the migration can be considered complete and ready for production deployment.