using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Bookstore.Data.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // ------------------------------------------------------------------
            // Ensure the target schema exists before creating any tables.
            // ------------------------------------------------------------------
            migrationBuilder.EnsureSchema(name: "bobsbookstore_dbo");

            // ------------------------------------------------------------------
            // referencedata  (no FK dependencies – create first)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    datatype = table.Column<int>(type: "integer", nullable: false),
                    text = table.Column<string>(type: "text", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_referencedata", x => x.id);
                });

            // ------------------------------------------------------------------
            // author  (no FK dependencies)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "author",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    businessentityid = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nationalidnumber = table.Column<string>(type: "varchar(15)", maxLength: 15, nullable: false),
                    loginid = table.Column<string>(type: "varchar(256)", maxLength: 256, nullable: false),
                    jobtitle = table.Column<string>(type: "varchar(50)", maxLength: 50, nullable: false),
                    birthdate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    maritalstatus = table.Column<string>(type: "char(1)", maxLength: 1, nullable: false),
                    gender = table.Column<string>(type: "char(1)", maxLength: 1, nullable: false),
                    hiredate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    vacationhours = table.Column<short>(type: "smallint", nullable: false),
                    modifieddate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_author", x => x.businessentityid);
                });

            // ------------------------------------------------------------------
            // product  (no FK dependencies)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "product",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    productid = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    name = table.Column<string>(type: "varchar(15)", maxLength: 15, nullable: false),
                    productnumber = table.Column<string>(type: "varchar(256)", maxLength: 256, nullable: false),
                    safetystocklevel = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_product", x => x.productid);
                });

            // ------------------------------------------------------------------
            // customer  (no FK dependencies)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "customer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    sub = table.Column<string>(type: "text", nullable: false),
                    username = table.Column<string>(type: "text", nullable: true),
                    firstname = table.Column<string>(type: "text", nullable: true),
                    lastname = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: true),
                    dateofbirth = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    phone = table.Column<string>(type: "text", nullable: true),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_customer", x => x.id);
                });

            // ------------------------------------------------------------------
            // book  (FK -> referencedata x4)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "book",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    name = table.Column<string>(type: "text", nullable: false),
                    author = table.Column<string>(type: "text", nullable: false),
                    year = table.Column<int>(type: "integer", nullable: true),
                    isbn = table.Column<string>(type: "text", nullable: false),
                    publisherid = table.Column<int>(type: "integer", nullable: false),
                    booktypeid = table.Column<int>(type: "integer", nullable: false),
                    genreid = table.Column<int>(type: "integer", nullable: false),
                    conditionid = table.Column<int>(type: "integer", nullable: false),
                    coverimageurl = table.Column<string>(type: "text", nullable: true),
                    summary = table.Column<string>(type: "text", nullable: true),
                    price = table.Column<decimal>(type: "numeric", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_book", x => x.id);
                    table.ForeignKey(
                        name: "fk_book_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ------------------------------------------------------------------
            // address  (FK -> customer)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "address",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    addressline1 = table.Column<string>(type: "text", nullable: false),
                    addressline2 = table.Column<string>(type: "text", nullable: true),
                    city = table.Column<string>(type: "text", nullable: false),
                    state = table.Column<string>(type: "text", nullable: false),
                    country = table.Column<string>(type: "text", nullable: false),
                    zipcode = table.Column<string>(type: "text", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    isactive = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_address", x => x.id);
                    table.ForeignKey(
                        name: "fk_address_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ------------------------------------------------------------------
            // offer  (FK -> customer, referencedata x4)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "offer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    author = table.Column<string>(type: "text", nullable: false),
                    isbn = table.Column<string>(type: "text", nullable: false),
                    bookname = table.Column<string>(type: "text", nullable: false),
                    fronturl = table.Column<string>(type: "text", nullable: true),
                    genreid = table.Column<int>(type: "integer", nullable: false),
                    conditionid = table.Column<int>(type: "integer", nullable: false),
                    publisherid = table.Column<int>(type: "integer", nullable: false),
                    booktypeid = table.Column<int>(type: "integer", nullable: false),
                    summary = table.Column<string>(type: "text", nullable: true),
                    offerstatus = table.Column<int>(type: "integer", nullable: false),
                    comment = table.Column<string>(type: "text", nullable: true),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    bookprice = table.Column<decimal>(type: "numeric", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_offer", x => x.id);
                    table.ForeignKey(
                        name: "fk_offer_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ------------------------------------------------------------------
            // Order  (FK -> customer, address)
            // NOTE: entity.ToTable uses "Order" (mixed-case) – preserved as-is
            //       per schema mappings (SourceTable=Order, TargetTable=Order).
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "Order",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    addressid = table.Column<int>(type: "integer", nullable: false),
                    deliverydate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderstatus = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_order", x => x.id);
                    table.ForeignKey(
                        name: "fk_order_address_addressid",
                        column: x => x.addressid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "address",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_order_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ------------------------------------------------------------------
            // shoppingcart  (no FK dependencies)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    correlationid = table.Column<string>(type: "text", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_shoppingcart", x => x.id);
                });

            // ------------------------------------------------------------------
            // orderitem  (FK -> Order, book)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    orderid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_orderitem", x => x.id);
                    table.ForeignKey(
                        name: "fk_orderitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_orderitem_order_orderid",
                        column: x => x.orderid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "Order",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ------------------------------------------------------------------
            // shoppingcartitem  (FK -> shoppingcart, book)
            // ------------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    shoppingcartid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    wanttobuy = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_shoppingcartitem", x => x.id);
                    table.ForeignKey(
                        name: "fk_shoppingcartitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_shoppingcartitem_shoppingcart_shoppingcartid",
                        column: x => x.shoppingcartid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "shoppingcart",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ------------------------------------------------------------------
            // Seed: referencedata
            // ------------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "referencedata",
                columns: new[] { "id", "datatype", "text", "createdby", "createdon", "updatedon" },
                values: new object[,]
                {
                    { 1,  2, "Hardcover",                      "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 2,  2, "Trade Paperback",                "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 3,  2, "Mass Market Paperback",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 4,  1, "New",                           "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 5,  1, "Like New",                      "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 6,  1, "Good",                          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 7,  1, "Acceptable",                    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 8,  3, "Biographies",                   "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 9,  3, "Children's Books",              "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 10, 3, "History",                       "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 11, 3, "Literature & Fiction",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 12, 3, "Mystery, Thriller & Suspense",  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 13, 3, "Science Fiction & Fantasy",     "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 14, 3, "Travel",                        "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 15, 0, "Arcadia Books",                 "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 16, 0, "Astral Publishing",             "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 17, 0, "Moonlight Publishing",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 18, 0, "Dreamscape Press",              "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 19, 0, "Enchanted Library",             "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 20, 0, "Fantasia House",                "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 21, 0, "Horizon Books",                 "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 22, 0, "Infinity Press",                "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 23, 0, "Paradigm Publishing",           "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 24, 0, "Aurora Publishing",             "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) }
                });

            // ------------------------------------------------------------------
            // Seed: book
            // ------------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "book",
                columns: new[] { "id", "name", "author", "isbn", "publisherid", "booktypeid", "genreid", "conditionid", "price", "quantity", "year", "summary", "coverimageurl", "createdby", "createdon", "updatedon" },
                values: new object[,]
                {
                    { 1, "2020: The Apocalypse",      "Li Juan",        "6556784356", 15, 1, 13, 5, 10.95m, 25, null, null, "/images/coverimages/apocalypse.png",       "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 2, "Children Of Iron",          "Nikki Wolf",     "7665438976", 16, 1, 11, 6, 13.95m,  3, null, null, "/images/coverimages/childrenofiron.png",   "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 3, "Gold In The Dark",          "Richard Roe",    "5442280765", 17, 1, 13, 5,  6.50m, 10, null, null, "/images/coverimages/goldinthedark.png",    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 4, "Leagues Of Smoke",          "Pat Candella",   "4556789542", 18, 2, 11, 7,  3.00m,  1, null, null, "/images/coverimages/leaguesofsmoke.png",   "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 5, "Alone With The Stars",      "Carlos Salazar", "4563358087", 19, 2, 12, 5, 15.95m,  5, null, null, "/images/coverimages/alonewiththestars.png","System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 6, "The Girl In The Polaroid",  "Terri Whitlock", "2354435678", 20, 1, 12, 6,  8.25m,  2, null, null, "/images/coverimages/girlinthepolaroid.png","System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 7, "1001 Jokes",                "Mary Major",     "6554789632", 21, 2, 11, 5, 13.95m,  7, null, null, "/images/coverimages/1001jokes.png",        "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 8, "My Search For Meaning",     "Mateo Jackson",  "4558786554", 22, 3,  8, 7,  5.00m, 15, null, null, "/images/coverimages/mysearchformeaning.png","System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) }
                });

            // ------------------------------------------------------------------
            // Indexes
            // ------------------------------------------------------------------
            migrationBuilder.CreateIndex(
                name: "ix_address_customerid",
                schema: "bobsbookstore_dbo",
                table: "address",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_book_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "ix_book_conditionid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "ix_book_genreid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "ix_book_publisherid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "ix_customer_sub",
                schema: "bobsbookstore_dbo",
                table: "customer",
                column: "sub",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_offer_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_conditionid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_customerid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_genreid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_publisherid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "ix_order_addressid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "addressid");

            migrationBuilder.CreateIndex(
                name: "ix_order_customerid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_orderitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "ix_orderitem_orderid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "orderid");

            migrationBuilder.CreateIndex(
                name: "ix_shoppingcartitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "ix_shoppingcartitem_shoppingcartid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "shoppingcartid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Drop in reverse dependency order
            migrationBuilder.DropTable(name: "shoppingcartitem", schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "orderitem",         schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "shoppingcart",      schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "Order",             schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "offer",             schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "address",           schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "book",              schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "customer",          schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "product",           schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "author",            schema: "bobsbookstore_dbo");
            migrationBuilder.DropTable(name: "referencedata",     schema: "bobsbookstore_dbo");
        }
    }
}
