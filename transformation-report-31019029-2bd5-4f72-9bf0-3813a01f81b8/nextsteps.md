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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the project files and source code for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespaces
- `System.Windows.Forms` or `System.Drawing` (unless the `EnableWindowsTargeting` flag is intentional)
- Any NuGet packages that only support Windows target frameworks

Use the following command to inspect package compatibility:

```bash
dotnet list package --include-transitive
```

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and perform basic functional checks, such as:

- Loading the home page
- Browsing or searching for books
- Any data-driven pages that rely on `Bookstore.Data` and `Bookstore.Domain`

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Existing Tests

If the solution contains any test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures that may have been introduced during the migration.

---

## 8. Cross-Platform Validation

If cross-platform support is a requirement, run the application on a non-Windows operating system (e.g., Linux or macOS) to confirm there are no runtime issues that were not caught at compile time. Pay particular attention to:

- File path separators
- Case-sensitive file system behavior
- Any configuration or environment variable differences