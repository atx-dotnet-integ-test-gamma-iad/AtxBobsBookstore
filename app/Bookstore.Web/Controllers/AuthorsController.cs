using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Bookstore.Data;
using Bookstore.Domain.Authors;
using Npgsql;


namespace Bookstore.Web.Controllers
{
    public class AuthorsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AuthorsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Authors
        public async Task<IActionResult> Index()
        {
            return View(await FindAllAuthorsEmbeddedSql());
        }
        
        // GET: Authors/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var author = await _context.Author
                .FirstOrDefaultAsync(m => m.BusinessEntityID == id);
            if (author == null)
            {
                return NotFound();
            }

            return View(author);
        }

        // GET: Authors/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Authors/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("NationalIDNumber,LoginID,JobTitle,BirthDate,MaritalStatus,Gender,HireDate,SalariedFlag,VacationHours,CurrentFlag")] Author author)
        {
            if (ModelState.IsValid)
            {
                author.ModifiedDate = DateTime.Now;
                _context.Add(author);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(author);
        }

        // GET: Authors/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var author = await _context.Author.FindAsync(id);
            
            if (author == null)
            {
                return NotFound();
            }
            
            return View(author);
        }

        // GET: Authors/Delete/5

        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var author = await _context.Author
                .FirstOrDefaultAsync(m => m.BusinessEntityID == id);
            if (author == null)
            {
                return NotFound();
            }

            return View(author);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var author = await _context.Author.FindAsync(id);

            if (author != null)
            {
                await DeleteAuthorEmbeddedSql(id);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }


        private bool AuthorExists(int id)
        {
            return _context.Author.Any(e => e.BusinessEntityID == id);
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("BusinessEntityID,NationalIDNumber,LoginID,JobTitle,BirthDate,MaritalStatus,Gender,HireDate,SalariedFlag,VacationHours,ModifiedDate")] Author author)
        {
            if (id != author.BusinessEntityID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await EditUsingStoredProcedure(author.BusinessEntityID, author.NationalIDNumber, author.BirthDate,
                        author.MaritalStatus, author.Gender);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AuthorExists(author.BusinessEntityID))
                    {
                        return NotFound();
                    }
                }
                
                return RedirectToAction(nameof(Index));
            }
            
            return View(author);
        }
        
        public async Task<bool> EditUsingStoredProcedure(int businessEntityId, string nationalIdNumber, DateTime birthDate, string maritalStatus, string gender)
        {
            try
            {
                // SQL CONVERSION: Original MS SQL Server EXEC converted to PostgreSQL function call
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
                // Equivalency Status: ERROR (sql-equivalency tool returned UNKNOWN - formal verifier cannot prove stored procedure conversion)
                // Original: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender; SELECT @rowsAffected;
                // Converted: SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
                // Note: SQL Server EXEC with return value → PostgreSQL function call in SELECT
                string sql = @"SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);";

                var rowsAffected = await _context.Database.ExecuteSqlRawAsync(sql, 
                    new NpgsqlParameter("@BusinessEntityID", businessEntityId),
                    new NpgsqlParameter("@NationalIDNumber", nationalIdNumber),
                    new NpgsqlParameter("@BirthDate", birthDate.ToUniversalTime()),
                    new NpgsqlParameter("@MaritalStatus", maritalStatus),
                    new NpgsqlParameter("@Gender", gender)
                    );

                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return false;
            }
        }

        public async Task<List<Author>> FindAllAuthorsEmbeddedSql()
        {
            try
            {
                // SQL CONVERSION: Standard SELECT statement compatible with both SQL Server and PostgreSQL
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
                // Equivalency Status: EQUIVALENT (sql-equivalency tool: StructuralEquivalenceVerifier proved equivalency)
                // Original: SELECT * FROM bobsbookstore_dbo.author
                // Converted: SELECT * FROM bobsbookstore_dbo.author (no changes needed)
                // Note: Standard SQL syntax compatible with both databases
                string sql = @"SELECT * FROM bobsbookstore_dbo.author";

                // Execute the SQL command and get the number of rows affected
                var results = await _context.Database.SqlQueryRaw<Author>(sql).ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                Console.WriteLine(ex.ToString());
                return null;
            }
        }


        public async Task<bool> DeleteAuthorEmbeddedSql(int businessEntityId)
        {
            try
            {
                // SQL CONVERSION: Original MS SQL Server EXEC converted to PostgreSQL function call
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
                // Equivalency Status: ERROR (sql-equivalency tool returned UNKNOWN - formal verifier cannot prove stored procedure conversion)
                // Original: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID; SELECT @rowsAffected;
                // Converted: SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);
                // Note: SQL Server EXEC with return value → PostgreSQL function call in SELECT
                string sql = @"SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);";

                // Execute the SQL command and get the number of rows affected
                var rowsAffected = await _context.Database.ExecuteSqlRawAsync(sql, new NpgsqlParameter("@BusinessEntityID", businessEntityId));

                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                Console.WriteLine(ex.ToString());
                return false;
            }
        }

        public async Task<List<AuthorAgeResult>> SelectAuthorsByHireYear(int hireYear)
        {
            try
            {
                // SQL CONVERSION: Original MS SQL Server date functions converted to PostgreSQL equivalents
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
                // Equivalency Status: ERROR (sql-equivalency tool returned UNKNOWN - formal verifier cannot prove complex date function conversions)
                // Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
                // Converted: SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
                // Note: FORMAT→TO_CHAR, DATEDIFF→AGE+DATE_PART, GETDATE→CURRENT_TIMESTAMP, DATEPART→EXTRACT
                string sql = @"SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;";

                // Execute the SQL command and get the number of rows affected
                var results = await _context.Database.SqlQueryRaw<AuthorAgeResult>(sql, new NpgsqlParameter("@HireDate", hireYear)).ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                Console.WriteLine(ex.ToString());
                return null;
            }
        }
        
        public async Task<IActionResult> OtherAuthors(int hireYear)
        {
            var authors = await SelectAuthorsByHireYear(hireYear);
            return View(authors);
        }
    }
}