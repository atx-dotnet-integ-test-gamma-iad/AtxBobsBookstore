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
            migrationBuilder.EnsureSchema(
                name: "bobsbookstore_dbo");

            // ---------------------------------------------------------------
            // author
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_author", x => x.businessentityid);
                });

            // ---------------------------------------------------------------
            // customer
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_customer", x => x.id);
                });

            // ---------------------------------------------------------------
            // product
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_product", x => x.productid);
                });

            // ---------------------------------------------------------------
            // referencedata
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_referencedata", x => x.id);
                });

            // ---------------------------------------------------------------
            // address  (depends on customer)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_address", x => x.id);
                    table.ForeignKey(
                        name: "FK_address_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // book  (depends on referencedata)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_book", x => x.id);
                    table.ForeignKey(
                        name: "FK_book_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // shoppingcart  (no FK dependencies)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_shoppingcart", x => x.id);
                });

            // ---------------------------------------------------------------
            // offer  (depends on customer + referencedata)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_offer", x => x.id);
                    table.ForeignKey(
                        name: "FK_offer_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // Order  (depends on customer + address)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_Order", x => x.id);
                    table.ForeignKey(
                        name: "FK_Order_address_addressid",
                        column: x => x.addressid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "address",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Order_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // orderitem  (depends on Order + book)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_orderitem", x => x.id);
                    table.ForeignKey(
                        name: "FK_orderitem_Order_orderid",
                        column: x => x.orderid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "Order",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_orderitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // shoppingcartitem  (depends on shoppingcart + book)
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("PK_shoppingcartitem", x => x.id);
                    table.ForeignKey(
                        name: "FK_shoppingcartitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_shoppingcartitem_shoppingcart_shoppingcartid",
                        column: x => x.shoppingcartid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "shoppingcart",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // Indexes
            // ---------------------------------------------------------------
            migrationBuilder.CreateIndex(
                name: "IX_address_customerid",
                schema: "bobsbookstore_dbo",
                table: "address",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_book_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "IX_book_conditionid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "IX_book_genreid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "IX_book_publisherid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "IX_customer_sub",
                schema: "bobsbookstore_dbo",
                table: "customer",
                column: "sub",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_offer_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_conditionid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_customerid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_genreid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_publisherid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "IX_Order_addressid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "addressid");

            migrationBuilder.CreateIndex(
                name: "IX_Order_customerid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_orderitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "IX_orderitem_orderid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "orderid");

            migrationBuilder.CreateIndex(
                name: "IX_shoppingcartitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "IX_shoppingcartitem_shoppingcartid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "shoppingcartid");

            // ---------------------------------------------------------------
            // Seed data – referencedata
            // ---------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "referencedata",
                columns: new[] { "id", "datatype", "text", "createdby", "createdon", "updatedon" },
                values: new object[,]
                {
                    { 1,  2, "Hardcover",                "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 2,  2, "Trade Paperback",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 3,  2, "Mass Market Paperback",    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 4,  1, "New",                     "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 5,  1, "Like New",                "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 6,  1, "Good",                    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 7,  1, "Acceptable",              "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 8,  3, "Biographies",             "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 9,  3, "Children's Books",        "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 10, 3, "History",                 "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 11, 3, "Literature & Fiction",    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 12, 3, "Mystery, Thriller & Suspense", "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 13, 3, "Science Fiction & Fantasy", "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 14, 3, "Travel",                  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 15, 0, "Arcadia Books",           "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 16, 0, "Astral Publishing",       "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 17, 0, "Moonlight Publishing",    "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 18, 0, "Dreamscape Press",        "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 19, 0, "Enchanted Library",       "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 20, 0, "Fantasia House",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 21, 0, "Horizon Books",           "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 22, 0, "Infinity Press",          "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 23, 0, "Paradigm Publishing",     "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 24, 0, "Aurora Publishing",       "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) }
                });

            // ---------------------------------------------------------------
            // Seed data – book
            // ---------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "book",
                columns: new[] { "id", "name", "author", "year", "isbn", "publisherid", "booktypeid", "genreid", "conditionid", "coverimageurl", "summary", "price", "quantity", "createdby", "createdon", "updatedon" },
                values: new object[,]
                {
                    { 1, "2020: The Apocalypse",       "Li Juan",        null, "6556784356", 15, 1, 13, 5, "/images/coverimages/apocalypse.png",       null, 10.95m, 25, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 2, "Children Of Iron",           "Nikki Wolf",     null, "7665438976", 16, 1, 11, 6, "/images/coverimages/childrenofiron.png",   null, 13.95m,  3, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 3, "Gold In The Dark",           "Richard Roe",    null, "5442280765", 17, 1, 13, 5, "/images/coverimages/goldinthedark.png",    null,  6.50m, 10, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 4, "Leagues Of Smoke",           "Pat Candella",   null, "4556789542", 18, 2, 11, 7, "/images/coverimages/leaguesofsmoke.png",   null,  3.00m,  1, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 5, "Alone With The Stars",       "Carlos Salazar", null, "4563358087", 19, 2, 12, 5, "/images/coverimages/alonewiththestars.png", null, 15.95m,  5, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 6, "The Girl In The Polaroid",   "Terri Whitlock", null, "2354435678", 20, 1, 12, 6, "/images/coverimages/girlinthepolaroid.png", null,  8.25m,  2, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 7, "1001 Jokes",                 "Mary Major",     null, "6554789632", 21, 2, 11, 5, "/images/coverimages/1001jokes.png",        null, 13.95m,  7, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                    { 8, "My Search For Meaning",      "Mateo Jackson",  null, "4558786554", 22, 3,  8, 7, "/images/coverimages/mysearchformeaning.png", null,  5.00m, 15, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "offer",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "author",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "product",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "Order",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "book",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "address",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "customer",
                schema: "bobsbookstore_dbo");
        }
    }
}
