# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework Core), verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is used, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the following:

- Pages load without errors.
- Data is retrieved and displayed correctly from the database.
- Any forms or user interactions function as expected.
- Authentication and authorization flows work correctly if applicable.

---

## 6. Review Configuration Files

Cross-platform .NET may require changes to configuration that were previously handled differently in the legacy project. Verify the following files:

- **`appsettings.json`** – Ensure environment-specific settings are present and correct.
- **`Program.cs` / `Startup.cs`** – Confirm middleware, services, and dependency injection registrations are complete and correct.
- **File paths** – If any hardcoded file paths exist in the codebase, ensure they use `Path.Combine` or forward-slash-compatible formats to maintain cross-platform compatibility.

---

## 7. Check for Platform-Specific API Usage

Search the codebase for any remaining Windows-specific APIs that may cause issues on Linux or macOS:

- `Registry` access
- `System.Drawing` (GDI+) without a cross-platform alternative
- COM interop or P/Invoke calls targeting Windows DLLs

Replace or conditionally compile any such usages as needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.