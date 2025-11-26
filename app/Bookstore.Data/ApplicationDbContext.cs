using System;
using Bookstore.Domain.Addresses;
using Bookstore.Domain.Authors;
using Bookstore.Domain.Books;
using Bookstore.Domain.Carts;
using Bookstore.Domain.Customers;
using Bookstore.Domain.Offers;
using Bookstore.Domain.Orders;
using Bookstore.Domain.Products;
using Bookstore.Domain.ReferenceData;
using Microsoft.EntityFrameworkCore;

namespace Bookstore.Data
{
    public partial class ApplicationDbContext : DbContext
    {
        static ApplicationDbContext()
        {
            AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
        }

        public ApplicationDbContext() { }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        public DbSet<Address> Address { get; set; }

        public DbSet<Book> Book { get; set; }

        public DbSet<Customer> Customer { get; set; }

        public DbSet<Order> Order { get; set; }

        public DbSet<ShoppingCart> ShoppingCart { get; set; }

        public DbSet<ShoppingCartItem> ShoppingCartItem { get; set; }

        public DbSet<OrderItem> OrderItem { get; set; }

        public DbSet<Offer> Offer { get; set; }

        public DbSet<Author> Author { get; set; }

        public DbSet<Product> Product { get; set; }


        public DbSet<ReferenceDataItem> ReferenceData { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Apply table mappings with schema
            modelBuilder.Entity<Address>().ToTable("address", "bobsbookstore_dbo");
            modelBuilder.Entity<Book>().ToTable("book", "bobsbookstore_dbo");
            modelBuilder.Entity<Customer>().ToTable("customer", "bobsbookstore_dbo");
            modelBuilder.Entity<Order>().ToTable("Order", "bobsbookstore_dbo");
            modelBuilder.Entity<ShoppingCart>().ToTable("shoppingcart", "bobsbookstore_dbo");
            modelBuilder.Entity<ShoppingCartItem>().ToTable("shoppingcartitem", "bobsbookstore_dbo");
            modelBuilder.Entity<OrderItem>().ToTable("orderitem", "bobsbookstore_dbo");
            modelBuilder.Entity<Offer>().ToTable("offer", "bobsbookstore_dbo");
            modelBuilder.Entity<Author>().ToTable("author", "bobsbookstore_dbo");
            modelBuilder.Entity<Product>().ToTable("product", "bobsbookstore_dbo");
            modelBuilder.Entity<ReferenceDataItem>().ToTable("referencedata", "bobsbookstore_dbo");

            // Apply boolean to int conversions for PostgreSQL
            modelBuilder.Entity<Address>().Property(e => e.IsActive).HasConversion<int>();
            modelBuilder.Entity<Book>().Property(e => e.IsInStock).HasConversion<int>();
            modelBuilder.Entity<Book>().Property(e => e.IsLowInStock).HasConversion<int>();
            modelBuilder.Entity<ShoppingCartItem>().Property(e => e.WantToBuy).HasConversion<int>();

            modelBuilder.Entity<Customer>().HasIndex(x => x.Sub).IsUnique();

            modelBuilder.Entity<Book>().HasOne(x => x.Publisher).WithMany().HasForeignKey(x => x.PublisherId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Book>().HasOne(x => x.BookType).WithMany().HasForeignKey(x => x.BookTypeId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Book>().HasOne(x => x.Genre).WithMany().HasForeignKey(x => x.GenreId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Book>().HasOne(x => x.Condition).WithMany().HasForeignKey(x => x.ConditionId).OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Offer>().HasOne(x => x.Publisher).WithMany().HasForeignKey(x => x.PublisherId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Offer>().HasOne(x => x.BookType).WithMany().HasForeignKey(x => x.BookTypeId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Offer>().HasOne(x => x.Genre).WithMany().HasForeignKey(x => x.GenreId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Offer>().HasOne(x => x.Condition).WithMany().HasForeignKey(x => x.ConditionId).OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Order>().HasOne(x => x.Customer).WithMany().OnDelete(DeleteBehavior.Restrict);

            PopulateDatabase(modelBuilder);

            base.OnModelCreating(modelBuilder);
        }
    }
}
