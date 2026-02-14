# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in your solution:
- `Bookstore.Data`
- `Bookstore.Web`
- `Bookstore.Domain`

## Validation Steps

### 1. Verify Project Structure

Confirm that all projects have been correctly converted to SDK-style project format:

```bash
# Check that all .csproj files use the SDK-style format
cat app/Bookstore.Data/Bookstore.Data.csproj
cat app/Bookstore.Web/Bookstore.Web.csproj
cat app/Bookstore.Domain/Bookstore.Domain.csproj
```

Ensure each project file contains `<Project Sdk="Microsoft.NET.Sdk">` or `<Project Sdk="Microsoft.NET.Sdk.Web">` at the root.

### 2. Restore and Build Verification

Execute a clean build to confirm all dependencies resolve correctly:

```bash
# Clean previous build artifacts
dotnet clean

# Restore NuGet packages
dotnet restore

# Build the entire solution
dotnet build --configuration Release

# Build each project individually to verify independence
dotnet build app/Bookstore.Domain/Bookstore.Domain.csproj
dotnet build app/Bookstore.Data/Bookstore.Data.csproj
dotnet build app/Bookstore.Web/Bookstore.Web.csproj
```

### 3. Run Unit Tests

If your solution contains unit tests, execute them to ensure functionality remains intact:

```bash
# Run all tests in the solution
dotnet test

# Run tests with detailed output
dotnet test --verbosity normal
```

### 4. Check for Runtime Dependencies

Verify that any platform-specific or Windows-only dependencies have been addressed:

- Review `packages.config` files (if any remain) and confirm migration to PackageReference format
- Check for references to Windows-specific APIs (System.Drawing, System.Web, etc.)
- Validate database connection strings and providers are cross-platform compatible

### 5. Test Application Functionality

#### For Bookstore.Web:

```bash
# Run the web application
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj

# Test on different ports if needed
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --urls "http://localhost:5000"
```

- Navigate to the application in a browser
- Test critical user workflows (browsing books, searching, etc.)
- Verify database connectivity through the Data layer
- Check static file serving and routing

#### For Bookstore.Data:

- Verify Entity Framework or data access layer functionality
- Test database migrations if applicable:

```bash
# List migrations (if using EF Core)
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj

# Apply migrations to a test database
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 6. Cross-Platform Validation

Test the application on different operating systems to ensure true cross-platform compatibility:

- **Linux**: Deploy and run on a Linux environment (Ubuntu, Debian, etc.)
- **macOS**: Test on macOS if available
- **Windows**: Verify it still functions correctly on Windows

```bash
# Check the target framework
dotnet --info

# Verify runtime compatibility
dotnet --list-runtimes
```

### 7. Configuration Review

Examine configuration files for any legacy settings:

- Review `appsettings.json` and `appsettings.Development.json`
- Check `web.config` files (should be minimal or removed for Kestrel hosting)
- Validate connection strings use cross-platform compatible formats
- Ensure file paths use `Path.Combine()` rather than hardcoded separators

### 8. Performance Baseline

Establish performance metrics for the migrated application:

```bash
# Publish the application in Release mode
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish

# Run the published application
dotnet ./publish/Bookstore.Web.dll
```

- Measure startup time
- Test response times for key endpoints
- Monitor memory usage
- Compare against legacy application metrics if available

### 9. Dependency Audit

Review all NuGet package dependencies:

```bash
# List all package dependencies
dotnet list package

# Check for outdated packages
dotnet list package --outdated

# Look for deprecated packages
dotnet list package --deprecated

# Check for vulnerable packages
dotnet list package --vulnerable
```

Update any outdated or vulnerable packages to their latest stable versions.

### 10. Documentation Updates

Update project documentation to reflect the migration:

- Document the new target framework version
- Update build instructions for the new SDK-style projects
- Revise deployment procedures
- Note any breaking changes or behavioral differences

## Deployment Preparation

### 1. Create Publish Profiles

Generate optimized builds for deployment:

```bash
# Self-contained deployment (includes runtime)
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -r linux-x64 --self-contained

# Framework-dependent deployment (requires runtime installed)
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release
```

### 2. Environment Configuration

- Set up environment-specific configuration files
- Configure environment variables for sensitive data
- Validate logging configuration for production environments

### 3. Database Migration Strategy

- Create database backup procedures
- Test migration scripts in a staging environment
- Document rollback procedures

### 4. Smoke Testing

Perform final validation in a staging environment that mirrors production:

- Deploy the application to staging
- Execute end-to-end test scenarios
- Verify external integrations
- Test error handling and logging

## Final Checklist

- [ ] All projects build without errors
- [ ] Unit tests pass successfully
- [ ] Application runs on target operating system(s)
- [ ] Database connectivity verified
- [ ] Configuration files reviewed and updated
- [ ] Dependencies audited and updated
- [ ] Performance baseline established
- [ ] Documentation updated
- [ ] Staging environment tested
- [ ] Rollback plan documented

Once all validation steps are complete and the application functions as expected, you can proceed with production deployment.