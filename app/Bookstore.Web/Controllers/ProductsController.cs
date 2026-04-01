using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Bookstore.Data;
using Bookstore.Domain.Products;
using Npgsql;


namespace Bookstore.Web.Controllers
{
    public class ProductsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ProductsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Products
        public async Task<IActionResult> Index()
        {
            return View(await FindAllProducts());
        }
        
        public async Task<List<Product>> FindAllProducts()
        {
            try
            {
                // TODO: Manual migration required - Stored procedure call detected.
                // This stored procedure needs to be migrated to PostgreSQL and this call updated accordingly.
                // PostgreSQL does not support EXEC; use CALL BobsBookstore_dbo.uspGetProductData() or SELECT BobsBookstore_dbo.uspGetProductData() depending on whether it is a procedure or function.
                string sql = @"EXEC [dbo].[uspGetProductData];";

                return await _context.Database.SqlQueryRaw<Product>(sql).ToListAsync();
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                Console.WriteLine(ex.ToString());
                return new List<Product>();
            }
        }
    }
}