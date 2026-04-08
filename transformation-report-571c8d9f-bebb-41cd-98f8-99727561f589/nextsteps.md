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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Failures in tests that previously passed may indicate behavioral differences introduced by the migration to cross-platform .NET, such as changes in:

- String comparison behavior
- File path handling (case sensitivity on Linux/macOS)
- Culture-sensitive operations
- Entity Framework query translation differences

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that the data layer functions correctly.

- Confirm that the connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- If Entity Framework Core is in use, check that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality, including:

- Page rendering and routing
- Data retrieval and persistence
- Any authentication or authorization flows

---

## 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If you intend to target a specific Long-Term Support (LTS) release, verify that all three projects are aligned to the same framework version to avoid compatibility issues between projects.

---

## 7. Review Platform-Specific Code

Search the codebase for any patterns that may not behave consistently across platforms:

- Hardcoded Windows-style file paths using backslashes. Use `Path.Combine` instead.
- Use of `Environment.NewLine` rather than hardcoded `\r\n`.
- Registry access or Windows-specific APIs, which will not be available on Linux or macOS.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment.