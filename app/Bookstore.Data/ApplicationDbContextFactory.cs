using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Bookstore.Data
{
    /// <summary>
    /// Design-time factory used by the EF Core tooling (dotnet ef migrations add / database update)
    /// when a startup project cannot be resolved automatically or when running CLI commands
    /// without the full ASP.NET Core host.
    ///
    /// Usage:
    ///   dotnet ef migrations add InitialPostgres \
    ///     --project Bookstore.Data \
    ///     --startup-project Bookstore.Web \
    ///     --output-dir Migrations
    ///
    /// If the startup project cannot provide a connection string at design time, set the
    /// BOBSBOOKSTORE_CONNECTIONSTRING environment variable before running dotnet ef, or
    /// update the fallback literal below.
    /// </summary>
    public class ApplicationDbContextFactory : IDesignTimeDbContextFactory<ApplicationDbContext>
    {
        public ApplicationDbContext CreateDbContext(string[] args)
        {
            // 1. Prefer an environment variable so that CI/CD pipelines do not need
            //    to modify source code.
            var connectionString =
                System.Environment.GetEnvironmentVariable("BOBSBOOKSTORE_CONNECTIONSTRING")
                ?? "Host=localhost;Port=5432;Database=bobsbookstore;Username=postgres;Password=postgres;Search Path=bobsbookstore_dbo";

            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();

            optionsBuilder.UseNpgsql(
                connectionString,
                npgsqlOptions =>
                {
                    // Keep the EF migrations history table inside the application schema
                    // so that all bookstore-related objects live in one schema.
                    npgsqlOptions.MigrationsHistoryTable(
                        tableName: "__EFMigrationsHistory",
                        schema: "bobsbookstore_dbo");
                });

            return new ApplicationDbContext(optionsBuilder.Options);
        }
    }
}
