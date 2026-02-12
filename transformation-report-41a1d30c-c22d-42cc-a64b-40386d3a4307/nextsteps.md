# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the projects in your solution:
- `Bookstore.Data`
- `Bookstore.Domain`
- `Bookstore.Web`

Since there are no compilation errors, you can proceed with validation, testing, and deployment preparation.

## 1. Verify Project Configuration

### Check Target Framework
Ensure all projects are targeting the appropriate .NET version:

```bash
dotnet --version
```

Review each `.csproj` file to confirm the `<TargetFramework>` is set correctly (e.g., `net6.0`, `net7.0`, or `net8.0`).

### Validate Package References
Run the following command to check for deprecated or vulnerable packages:

```bash
dotnet list package --outdated
dotnet list package --vulnerable
```

Update any outdated packages as needed:

```bash
dotnet add package <PackageName>
```

## 2. Build Verification

### Clean and Rebuild
Perform a clean build to ensure no cached artifacts are causing false positives:

```bash
dotnet clean
dotnet build --configuration Release
```

### Check for Warnings
Review build warnings that may indicate potential runtime issues:

```bash
dotnet build --configuration Release /warnaserror
```

Address any warnings related to deprecated APIs, nullable reference types, or platform-specific code.

## 3. Runtime Testing

### Run Unit Tests
Execute existing unit tests to verify functionality:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If tests fail, investigate and fix issues related to:
- Database connection strings
- File path differences between Windows and cross-platform environments
- Case-sensitive file system operations
- Line ending differences

### Manual Testing
Start the application and perform manual testing:

```bash
cd app/Bookstore.Web
dotnet run
```

Test critical functionality:
- Database connectivity and CRUD operations
- Authentication and authorization
- File uploads and downloads
- API endpoints (if applicable)
- UI rendering and navigation

## 4. Cross-Platform Validation

### Test on Target Platforms
Run and test the application on each target platform:

**Linux:**
```bash
dotnet run --configuration Release
```

**macOS:**
```bash
dotnet run --configuration Release
```

**Windows:**
```bash
dotnet run --configuration Release
```

### Check Platform-Specific Issues
Look for:
- Path separator issues (use `Path.Combine()` instead of hardcoded separators)
- Case-sensitive file system operations
- Environment variable differences
- Line ending handling (CRLF vs LF)

## 5. Configuration Updates

### Update Connection Strings
Review `appsettings.json` and `appsettings.Development.json` for:
- Database connection strings (ensure compatibility with cross-platform database drivers)
- File paths (use relative paths or environment variables)
- URLs and ports

### Environment Variables
Verify environment-specific configurations are properly set:

```bash
export ASPNETCORE_ENVIRONMENT=Development
dotnet run
```

## 6. Database Migration Verification

### Check Entity Framework Migrations
If using Entity Framework, verify migrations work correctly:

```bash
cd app/Bookstore.Data
dotnet ef migrations list
dotnet ef database update
```

Test database operations on the target platform's database engine.

## 7. Performance Testing

### Run Performance Benchmarks
Compare performance between the legacy and migrated versions:

```bash
dotnet run --configuration Release
```

Monitor:
- Application startup time
- Memory usage
- Response times for critical operations
- Database query performance

## 8. Static Code Analysis

### Run Code Analysis
Use built-in analyzers to identify potential issues:

```bash
dotnet build /p:RunAnalyzers=true /p:EnforceCodeStyleInBuild=true
```

### Security Scanning
Check for security vulnerabilities:

```bash
dotnet list package --vulnerable --include-transitive
```

## 9. Documentation Updates

### Update README
Document:
- New target framework version
- Prerequisites for running the application
- Platform-specific setup instructions
- Changes in configuration or deployment

### Update Deployment Instructions
Create or update deployment documentation for:
- Installation steps on target platforms
- Configuration requirements
- Database setup procedures
- Troubleshooting common issues

## 10. Deployment Preparation

### Create Publish Profiles
Generate platform-specific publish profiles:

```bash
dotnet publish -c Release -r win-x64 --self-contained false
dotnet publish -c Release -r linux-x64 --self-contained false
dotnet publish -c Release -r osx-x64 --self-contained false
```

### Test Published Output
Run the published application to ensure it works outside the development environment:

```bash
cd bin/Release/net*/publish
dotnet Bookstore.Web.dll
```

### Verify Dependencies
Ensure all required dependencies are included in the published output:
- Configuration files
- Static assets
- Third-party libraries

## 11. Rollback Plan

### Document Rollback Procedure
Prepare a rollback plan in case issues arise:
- Keep the legacy version accessible
- Document configuration differences
- Create backup of production data before deployment

### Version Control
Ensure all changes are committed and tagged:

```bash
git add .
git commit -m "Migrate to cross-platform .NET"
git tag -a v2.0.0 -m "Cross-platform .NET migration"
```

## 12. Monitoring Setup

### Configure Logging
Verify logging is properly configured for the production environment:
- Check log levels in `appsettings.json`
- Ensure log output is accessible on target platforms
- Configure structured logging if needed

### Health Checks
Implement or verify health check endpoints:
- Application health
- Database connectivity
- External service dependencies

## Summary

With no build errors present, your migration appears successful. Focus on thorough testing across all target platforms, updating configuration for cross-platform compatibility, and validating that all functionality works as expected before deploying to production.