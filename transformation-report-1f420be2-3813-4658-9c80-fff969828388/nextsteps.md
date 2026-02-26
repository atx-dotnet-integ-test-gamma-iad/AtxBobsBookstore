# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Validation and Testing

Congratulations on successfully transforming your Bookstore solution to cross-platform .NET. Since no build errors were reported, the transformation appears to have completed successfully. Follow these steps to validate and deploy your modernized application.

### 1. Verify Build Configuration

```bash
# Clean and rebuild the entire solution
dotnet clean
dotnet build --configuration Release

# Verify all projects build successfully
dotnet build app/Bookstore.Data/Bookstore.Data.csproj
dotnet build app/Bookstore.Domain/Bookstore.Domain.csproj
dotnet build app/Bookstore.Web/Bookstore.Web.csproj
```

### 2. Update and Verify Dependencies

Check that all NuGet packages are compatible with your target framework:

```bash
# List outdated packages
dotnet list package --outdated

# Update packages if necessary
dotnet restore
```

Review the `.csproj` files to ensure:
- Target framework is set correctly (e.g., `<TargetFramework>net8.0</TargetFramework>`)
- Package references are using compatible versions
- Any legacy framework-specific packages have been replaced with cross-platform alternatives

### 3. Run Unit Tests

If your solution includes test projects:

```bash
# Run all tests
dotnet test

# Run tests with detailed output
dotnet test --verbosity normal

# Generate code coverage report
dotnet test --collect:"XPlat Code Coverage"
```

### 4. Validate Data Layer (Bookstore.Data)

- Test database connectivity with your connection strings
- Verify Entity Framework migrations (if applicable):
  ```bash
  dotnet ef migrations list --project app/Bookstore.Data
  ```
- Run a local database instance and test CRUD operations
- Check for any platform-specific SQL queries that may need adjustment

### 5. Validate Domain Layer (Bookstore.Domain)

- Review business logic for any framework-specific dependencies
- Test domain models and validation rules
- Verify any custom attributes or data annotations work correctly

### 6. Validate Web Application (Bookstore.Web)

#### Configuration Files
- Review `appsettings.json` and `appsettings.Development.json`
- Verify connection strings point to correct databases
- Check for any legacy `Web.config` transformations that need to be migrated

#### Static Files and wwwroot
- Ensure all static assets (CSS, JavaScript, images) are in the `wwwroot` folder
- Verify bundling and minification configurations

#### Middleware and Startup
- Review `Program.cs` or `Startup.cs` for proper middleware configuration
- Verify authentication and authorization setup
- Check dependency injection registrations

### 7. Local Runtime Testing

```bash
# Run the web application locally
cd app/Bookstore.Web
dotnet run

# Or with specific environment
dotnet run --environment Development
```

Test the following:
- Application starts without errors
- All routes are accessible
- Database operations function correctly
- Authentication/authorization works as expected
- Static files load properly
- Forms and POST operations work
- Error handling displays appropriate messages

### 8. Cross-Platform Validation

Test the application on different operating systems if possible:

```bash
# Windows
dotnet run

# Linux/macOS
dotnet run
```

Check for:
- File path separator issues (use `Path.Combine()`)
- Case-sensitive file system differences
- Line ending differences in configuration files

### 9. Performance and Memory Testing

```bash
# Run with diagnostics
dotnet run --configuration Release

# Monitor performance
dotnet counters monitor --process-id <PID>
```

### 10. Prepare for Deployment

#### Publish the Application

```bash
# Publish for specific runtime
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish

# Self-contained deployment (includes runtime)
dotnet publish -c Release -r linux-x64 --self-contained true -o ./publish

# Framework-dependent deployment (requires .NET runtime on server)
dotnet publish -c Release -o ./publish
```

#### Verify Published Output
- Check that all necessary files are in the publish directory
- Verify `appsettings.json` contains production-safe values
- Ensure connection strings use environment variables or secure configuration

#### Test Published Application

```bash
cd publish
dotnet Bookstore.Web.dll
```

### 11. Environment-Specific Configuration

Set up configuration for different environments:

```bash
# Set environment variable
export ASPNETCORE_ENVIRONMENT=Production  # Linux/macOS
set ASPNETCORE_ENVIRONMENT=Production     # Windows

# Use user secrets for development
dotnet user-secrets init --project app/Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your-connection-string"
```

### 12. Security Review

- Remove any hardcoded secrets or connection strings
- Verify HTTPS redirection is enabled
- Check CORS policies are appropriately configured
- Review authentication and authorization policies
- Ensure sensitive data is not logged

### 13. Documentation Updates

Update project documentation to reflect:
- New target framework version
- Updated installation instructions
- New build and run commands
- Environment setup requirements
- Deployment procedures

### 14. Final Deployment Checklist

Before deploying to production:

- [ ] All tests pass successfully
- [ ] Application runs without errors locally
- [ ] Published application tested and verified
- [ ] Configuration files reviewed and secured
- [ ] Database migrations tested
- [ ] Performance benchmarks meet requirements
- [ ] Error logging and monitoring configured
- [ ] Backup and rollback procedures documented