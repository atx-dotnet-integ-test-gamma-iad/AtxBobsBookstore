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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version (e.g., `net6.0` or `net7.0`), consider updating to `net8.0` as it is the current Long-Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-only APIs or libraries remain in use. The .NET Compatibility Analyzer can assist with this.

Add the analyzer to any project where you want to check platform compatibility:

```xml
<ItemGroup>
  <PackageReference Include="Microsoft.DotNet.Analyzers.Compatibility" Version="0.2.12-alpha" />
</ItemGroup>
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns that differ from ASP.NET Core

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm it has been migrated to **Entity Framework Core**.

```bash
dotnet ef dbcontext info --project app/Bookstore.Data
```

If database migrations exist, verify they are compatible with EF Core:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If the migrations were generated under EF 6, they will need to be regenerated under EF Core:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data
```

---

## 6. Run Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality behaves as expected after the migration.

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed in the application code.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web
```

Check the following areas specifically:
- Application startup and middleware pipeline configuration in `Program.cs`
- Authentication and authorization behavior if applicable
- Database connectivity and data retrieval through `Bookstore.Data`
- Routing and controller/action resolution

---

## 8. Review `appsettings.json` Configuration

Ensure that configuration values previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json`. Connection strings in particular should be verified.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Your connection string here"
  }
}
```

Sensitive values such as connection strings or API keys should be stored using the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Your connection string here" --project app/Bookstore.Web
```

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```