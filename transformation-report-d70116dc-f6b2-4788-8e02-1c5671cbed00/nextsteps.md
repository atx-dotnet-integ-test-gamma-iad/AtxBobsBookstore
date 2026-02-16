# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to be successful with no build errors reported across any of the three projects in your solution:
- `Bookstore.Data`
- `Bookstore.Domain`
- `Bookstore.Web`

Since the build completed without errors, you should proceed with validation, testing, and deployment preparation.

## 1. Verify Project Configuration

### 1.1 Confirm Target Framework
- Open each `.csproj` file and verify the `<TargetFramework>` is set appropriately (e.g., `net6.0`, `net7.0`, or `net8.0`)
- Ensure all projects target compatible framework versions

### 1.2 Review Package References
- Check that all NuGet packages have been updated to versions compatible with cross-platform .NET
- Run `dotnet list package --outdated` to identify any outdated dependencies
- Update critical packages if necessary using `dotnet add package <PackageName>`

### 1.3 Validate Build Output
```bash
dotnet build --configuration Release
```
- Verify the build completes successfully in Release mode
- Check the output directory for all expected assemblies

## 2. Runtime Validation

### 2.1 Test on Target Platforms
- **Windows**: Run the application on Windows to ensure backward compatibility
- **Linux**: Test on a Linux environment (Ubuntu, Debian, or your target distribution)
- **macOS**: If applicable, validate on macOS

### 2.2 Run the Application
```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```
- Verify the application starts without runtime errors
- Check console output for any warnings or exceptions

### 2.3 Database Connectivity (Bookstore.Data)
- Test database connections on different platforms
- Verify connection strings work across environments
- If using SQL Server, ensure you're using `Microsoft.Data.SqlClient` instead of `System.Data.SqlClient`
- Test any Entity Framework migrations if applicable

## 3. Functional Testing

### 3.1 Execute Unit Tests
```bash
dotnet test
```
- Run all existing unit tests
- Address any test failures that may have emerged from the transformation
- Verify test coverage remains consistent

### 3.2 Integration Testing
- Test all API endpoints (if `Bookstore.Web` is a web API)
- Verify web pages render correctly (if `Bookstore.Web` is an MVC or Razor Pages application)
- Test data access layer operations through `Bookstore.Data`
- Validate business logic in `Bookstore.Domain`

### 3.3 Cross-Platform File Path Validation
- Review any code that uses file paths
- Replace backslashes with `Path.Combine()` or forward slashes
- Test file operations on both Windows and Linux

## 4. Configuration and Environment

### 4.1 Application Settings
- Review `appsettings.json` and `appsettings.Development.json`
- Ensure configuration values are platform-agnostic
- Test environment variable substitution

### 4.2 Dependency Injection
- Verify all services are registered correctly in `Program.cs` or `Startup.cs`
- Test service resolution at runtime

### 4.3 Static Files and Assets (Bookstore.Web)
- Verify static files (CSS, JavaScript, images) are served correctly
- Test on case-sensitive file systems (Linux/macOS)

## 5. Performance and Compatibility

### 5.1 Performance Baseline
- Establish performance metrics for the migrated application
- Compare with legacy application benchmarks if available
- Monitor memory usage and startup time

### 5.2 Third-Party Dependencies
- Test any third-party integrations
- Verify external service connections work across platforms
- Check for any platform-specific API calls that may need alternatives

## 6. Code Review

### 6.1 Platform-Specific Code
- Search for any remaining Windows-specific APIs (e.g., Registry access, Windows-only P/Invoke)
- Review any conditional compilation directives
- Identify and refactor or isolate platform-dependent code

### 6.2 Deprecated API Usage
- Check for compiler warnings about deprecated APIs
- Replace obsolete methods with recommended alternatives

## 7. Documentation

### 7.1 Update Build Instructions
- Document the new build process using `dotnet` CLI
- Update any developer setup guides
- Revise deployment documentation

### 7.2 Platform Requirements
- Document minimum .NET runtime version required
- List any platform-specific prerequisites
- Update system requirements documentation

## 8. Deployment Preparation

### 8.1 Publish the Application
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```
- Test the published output
- Verify all dependencies are included

### 8.2 Self-Contained vs Framework-Dependent
- Decide between self-contained and framework-dependent deployment
- For self-contained: `dotnet publish -c Release -r <RID> --self-contained true`
- For framework-dependent: `dotnet publish -c Release --self-contained false`

### 8.3 Runtime Identifiers (RID)
Test publishing for target platforms:
- Windows: `win-x64`, `win-x86`, `win-arm64`
- Linux: `linux-x64`, `linux-arm64`
- macOS: `osx-x64`, `osx-arm64`

### 8.4 Deployment Validation
- Deploy to a staging environment
- Perform end-to-end testing in the staging environment
- Validate on the actual target operating system

## 9. Monitoring and Rollback

### 9.1 Establish Monitoring
- Set up application logging
- Monitor for runtime exceptions
- Track performance metrics post-deployment

### 9.2 Rollback Plan
- Maintain the legacy version as a backup
- Document rollback procedures
- Keep both versions available during initial deployment phase

## 10. Final Checklist

- [ ] All projects build without errors in Debug and Release configurations
- [ ] Application runs successfully on all target platforms
- [ ] All unit and integration tests pass
- [ ] Database connectivity verified across platforms
- [ ] Configuration files reviewed and validated
- [ ] Performance benchmarks meet expectations
- [ ] Documentation updated
- [ ] Staging environment deployment successful
- [ ] Rollback plan documented and tested