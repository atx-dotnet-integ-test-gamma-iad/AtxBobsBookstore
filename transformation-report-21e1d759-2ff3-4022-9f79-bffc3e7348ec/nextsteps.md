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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing framework versions between projects (e.g., `net6.0` in one and `net8.0` in another) can cause subtle runtime issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review the code and project files for any remaining Windows-specific dependencies, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and modern .NET.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a compatible version for modern .NET.
- If using Entity Framework 6, consider whether a migration to Entity Framework Core is appropriate.
- Run any database migrations and verify the schema is applied correctly:

```bash
dotnet ef database update
```

---

## 7. Validate the Domain Layer (`Bookstore.Domain`)

- Inspect domain models and business logic for any reliance on types or behaviors that differ between .NET Framework and modern .NET.
- Pay particular attention to serialization, globalization, and threading behaviors, which have known differences.

---

## 8. Validate the Web Layer (`Bookstore.Web`)

- Start the web application locally and navigate through its primary workflows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Verify that routing, middleware, authentication, and static file serving all function as expected.
- Check `Program.cs` and `Startup.cs` (if present) to confirm the middleware pipeline is configured correctly for modern ASP.NET Core conventions.

---

## 9. Review Configuration Files

- Ensure `appsettings.json` contains all necessary configuration values that may have previously resided in `Web.config` or `App.config`.
- Confirm connection strings, logging settings, and environment-specific configurations are properly defined.

---

## 10. Deploy to Target Environment

Once all validation steps pass:

1. Publish the application using the appropriate runtime identifier for your target platform:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

2. Copy the published output to the target server or hosting environment.
3. Confirm the correct .NET runtime version is installed on the target machine:

```bash
dotnet --info
```