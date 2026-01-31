# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in the solution (Bookstore.Data, Bookstore.Web, and Bookstore.Domain). This indicates that the migration to cross-platform .NET has completed without compilation issues.

## Validation Steps

### 1. Verify Project Configuration

- Open each `.csproj` file and confirm the target framework is set appropriately (e.g., `net6.0`, `net7.0`, or `net8.0`)
- Verify that all package references have been updated to versions compatible with the target framework
- Check that any platform-specific references have been removed or replaced with cross-platform alternatives

### 2. Restore and Build Verification

```bash
# Clean the solution
dotnet clean

# Restore all dependencies
dotnet restore

# Build in Release mode
dotnet build --configuration Release
```

### 3. Run Existing Tests

If the solution contains unit tests or integration tests:

```bash
# Run all tests
dotnet test

# Run tests with detailed output
dotnet test --verbosity normal
```

Review test results to identify any runtime issues that may not have surfaced during compilation.

### 4. Runtime Validation

- Launch the Bookstore.Web application locally:
  ```bash
  dotnet run --project app/Bookstore.Web
  ```
- Test all major application workflows manually
- Verify database connectivity (Bookstore.Data) functions correctly
- Check that business logic (Bookstore.Domain) executes as expected
- Test any external integrations or API calls

### 5. Check for Deprecated APIs

- Review compiler warnings (not just errors) for deprecated API usage
- Search the codebase for platform-specific code that may have been conditionally compiled
- Look for any `#if NETFRAMEWORK` or similar preprocessor directives that may need attention

### 6. Configuration Files

- Review `appsettings.json` and other configuration files for any framework-specific settings
- Update connection strings if database providers have changed
- Verify that environment-specific configurations work correctly

### 7. Dependency Analysis

```bash
# List all package dependencies
dotnet list package

# Check for outdated packages
dotnet list package --outdated
```

Update any packages that have newer versions available for better compatibility and security.

### 8. Performance Baseline

- Establish performance baselines for key operations
- Compare application startup time, memory usage, and response times with the legacy version
- Monitor for any performance regressions

## Deployment Preparation

### 1. Publish the Application

```bash
# Publish for Linux
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained false

# Publish for Windows
dotnet publish app/Bookstore.Web -c Release -r win-x64 --self-contained false

# Publish for macOS
dotnet publish app/Bookstore.Web -c Release -r osx-x64 --self-contained false
```

### 2. Test Published Output

- Run the published application in an environment similar to production
- Verify all static files, views, and assets are included in the publish output
- Confirm that the application runs without requiring the SDK (only the runtime)

### 3. Environment-Specific Testing

- Test the application on the target operating system(s)
- Verify file path handling works across platforms (use `Path.Combine` instead of hardcoded separators)
- Check case-sensitivity issues if deploying to Linux (file names, connection strings, etc.)

### 4. Database Migration Verification

If using Entity Framework or another ORM:

```bash
# Check migration status
dotnet ef migrations list --project app/Bookstore.Data

# Generate SQL scripts for review
dotnet ef migrations script --project app/Bookstore.Data
```

### 5. Security Review

- Ensure sensitive configuration values are externalized (environment variables, key vaults)
- Verify authentication and authorization mechanisms work correctly
- Check that HTTPS redirection and security headers are properly configured

## Documentation Updates

- Update deployment documentation to reflect the new .NET version
- Document any changes in system requirements
- Update developer setup instructions for the cross-platform environment
- Note any breaking changes or behavioral differences from the legacy version

## Final Checklist

- [ ] All projects build successfully in both Debug and Release configurations
- [ ] All existing tests pass
- [ ] Application runs correctly in local development environment
- [ ] Published application runs without the SDK installed
- [ ] Application tested on target deployment platform(s)
- [ ] Configuration management verified
- [ ] Database connectivity confirmed
- [ ] Performance is acceptable compared to legacy version
- [ ] Security configurations reviewed
- [ ] Documentation updated