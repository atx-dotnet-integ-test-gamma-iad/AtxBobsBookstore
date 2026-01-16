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
                // SQL Statement converted from T-SQL to PostgreSQL
                // Original: EXEC [dbo].[uspGetProductData];
                // Conversion Method: MANUAL_AFTER_DMS_FAILURE
                // Converted stored procedure call to PostgreSQL function call syntax
                string sql = @"SELECT * FROM public.uspgetproductdata();";

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