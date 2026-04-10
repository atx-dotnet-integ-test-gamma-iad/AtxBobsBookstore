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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check NuGet for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.
- Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 4. Verify Runtime Behavior of Bookstore.Web

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Routing and page rendering** — confirm all pages load without errors.
- **Database connectivity** — verify that `Bookstore.Data` connects to the database correctly. Connection strings may need to be updated in `appsettings.json` if they were previously stored in `Web.config`.
- **Authentication and Authorization** — if the application uses ASP.NET Identity or Windows Authentication, confirm these function correctly under the new runtime.
- **Static files** — ensure CSS, JavaScript, and image assets are served correctly.

---

## 5. Review Configuration Migration

Legacy .NET Framework projects use `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Confirm the following have been migrated:

- Connection strings
- Application settings (app keys)
- Any custom configuration sections

Open `appsettings.json` in `Bookstore.Web` and verify all necessary values are present and correct for your target environment.

---

## 6. Check for Windows-Specific Dependencies

Even with a successful build, certain APIs may only function on Windows. Run the .NET compatibility analyzer or review the code for usage of:

- `System.Web` types (should have been removed during migration)
- Windows Registry access
- Windows-specific file path assumptions
- COM interop

If the application is intended to run on Linux or macOS, test it explicitly on those platforms.

---

## 7. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If using **Entity Framework 6**, consider whether migrating to **Entity Framework Core** is appropriate, as EF6 has limited cross-platform support.
- If already using **EF Core**, run any pending migrations against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Verify that queries return expected results and that no SQL translation errors occur at runtime.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target server.