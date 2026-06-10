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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the code may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify that all previously passing tests continue to pass.
- Pay close attention to any tests that interact with the data layer (`Bookstore.Data`), as database provider behavior can differ between .NET Framework and modern .NET.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new runtime environment.
- If Entity Framework is used, run or verify any pending migrations:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 5. Validate the Domain Layer

Review `Bookstore.Domain` for any types or patterns that relied on .NET Framework-specific behavior, such as:

- `System.Runtime.Serialization` attributes
- `BinaryFormatter` usage (removed or restricted in modern .NET)
- Any types inheriting from `MarshalByRefObject`

---

## 6. Run the Web Application Locally

Start the web application to confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate through the application and verify core functionality such as browsing, searching, and any data-driven pages.
- Check the console output for runtime exceptions or middleware configuration warnings.
- Confirm that static files, routing, and authentication (if applicable) behave correctly under ASP.NET Core.

---

## 7. Review Configuration Migration

Ensure that the old `Web.config` or `App.config` settings have been properly transferred to `appsettings.json`. Key areas to check:

- Connection strings
- Application settings (e.g., API keys, feature flags)
- Logging configuration

---

## 8. Check for Removed or Changed APIs

Review the code for any usage of APIs that were removed or significantly changed in modern .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool can help identify remaining compatibility concerns:

```bash
upgrade-assistant analyze app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the output folder to confirm all required files, including runtime dependencies and configuration files, are present before deploying to the target environment.