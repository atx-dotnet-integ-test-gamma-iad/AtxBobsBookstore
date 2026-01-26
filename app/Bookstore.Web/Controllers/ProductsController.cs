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
                // SQL CONVERSION: Original MS SQL Server EXEC converted to PostgreSQL function call
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
                // Equivalency Status: ERROR (sql-equivalency tool returned UNKNOWN - formal verifier cannot prove stored procedure conversion)
                // Original: EXEC [dbo].[uspGetProductData];
                // Converted: SELECT * FROM bobsbookstore_dbo.uspGetProductData();
                // Note: Stored procedures migrated to PostgreSQL functions called via SELECT * FROM
                string sql = @"SELECT * FROM bobsbookstore_dbo.uspGetProductData();";

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