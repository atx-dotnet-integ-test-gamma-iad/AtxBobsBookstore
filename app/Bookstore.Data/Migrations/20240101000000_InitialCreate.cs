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

            // ----------------------------------------------------------------
            // author (standalone – no base Entity, no identity on PK)
            // ----------------------------------------------------------------
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
                    maritalstatus = table.Column<string>(type: "varchar(1)", maxLength: 1, nullable: false),
                    gender = table.Column<string>(type: "varchar(1)", maxLength: 1, nullable: false),
                    hiredate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    vacationhours = table.Column<short>(type: "smallint", nullable: false),
                    modifieddate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_author", x => x.businessentityid);
                });

            // ----------------------------------------------------------------
            // customer
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "customer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    sub = table.Column<string>(type: "text", nullable: false),
                    username = table.Column<string>(type: "text", nullable: true),
                    firstname = table.Column<string>(type: "text", nullable: true),
                    lastname = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: true),
                    dateofbirth = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    phone = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_customer", x => x.id);
                });

            // ----------------------------------------------------------------
            // product (standalone – no base Entity, no identity on PK)
            // ----------------------------------------------------------------
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

            // ----------------------------------------------------------------
            // referencedata
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    datatype = table.Column<int>(type: "integer", nullable: false),
                    text = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_referencedata", x => x.id);
                });

            // ----------------------------------------------------------------
            // address  (depends on customer)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "address",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    addressline1 = table.Column<string>(type: "text", nullable: false),
                    addressline2 = table.Column<string>(type: "text", nullable: true),
                    city = table.Column<string>(type: "text", nullable: false),
                    state = table.Column<string>(type: "text", nullable: false),
                    country = table.Column<string>(type: "text", nullable: false),
                    zipcode = table.Column<string>(type: "text", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    isactive = table.Column<int>(type: "integer", nullable: false)
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
                        onDelete: ReferentialAction.Restrict);
                });

            // ----------------------------------------------------------------
            // book  (depends on referencedata)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "book",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
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
                    quantity = table.Column<int>(type: "integer", nullable: false)
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

            // ----------------------------------------------------------------
            // offer  (depends on customer + referencedata)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "offer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
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
                    bookprice = table.Column<decimal>(type: "numeric", nullable: false)
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
                        onDelete: ReferentialAction.Restrict);
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

            // ----------------------------------------------------------------
            // Order  (depends on customer + address)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "Order",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    addressid = table.Column<int>(type: "integer", nullable: false),
                    deliverydate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderstatus = table.Column<int>(type: "integer", nullable: false)
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
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_order_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ----------------------------------------------------------------
            // shoppingcart
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    correlationid = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_shoppingcart", x => x.id);
                });

            // ----------------------------------------------------------------
            // orderitem  (depends on Order + book)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false)
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
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_orderitem_order_orderid",
                        column: x => x.orderid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "Order",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ----------------------------------------------------------------
            // shoppingcartitem  (depends on shoppingcart + book)
            // ----------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    shoppingcartid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    wanttobuy = table.Column<int>(type: "integer", nullable: false)
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
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_shoppingcartitem_shoppingcart_shoppingcartid",
                        column: x => x.shoppingcartid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "shoppingcart",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ----------------------------------------------------------------
            // Indexes
            // ----------------------------------------------------------------
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

            // ----------------------------------------------------------------
            // Seed data – referencedata
            // ----------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "referencedata",
                columns: new[] { "id", "createdby", "createdon", "updatedon", "datatype", "text" },
                values: new object[,]
                {
                    // BookType (enum value 2)
                    { 1,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Hardcover" },
                    { 2,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Trade Paperback" },
                    { 3,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Mass Market Paperback" },
                    // Condition (enum value 1)
                    { 4,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "New" },
                    { 5,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Like New" },
                    { 6,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Good" },
                    { 7,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Acceptable" },
                    // Genre (enum value 3)
                    { 8,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Biographies" },
                    { 9,  "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Children's Books" },
                    { 10, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "History" },
                    { 11, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Literature & Fiction" },
                    { 12, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Mystery, Thriller & Suspense" },
                    { 13, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Science Fiction & Fantasy" },
                    { 14, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Travel" },
                    // Publisher (enum value 0)
                    { 15, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Arcadia Books" },
                    { 16, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Astral Publishing" },
                    { 17, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Moonlight Publishing" },
                    { 18, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Dreamscape Press" },
                    { 19, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Enchanted Library" },
                    { 20, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Fantasia House" },
                    { 21, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Horizon Books" },
                    { 22, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Infinity Press" },
                    { 23, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Paradigm Publishing" },
                    { 24, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Aurora Publishing" }
                });

            // ----------------------------------------------------------------
            // Seed data – book
            // ----------------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "book",
                columns: new[] { "id", "createdby", "createdon", "updatedon", "name", "author", "year", "isbn", "publisherid", "booktypeid", "genreid", "conditionid", "coverimageurl", "summary", "price", "quantity" },
                values: new object[,]
                {
                    { 1, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "2020: The Apocalypse",       "Li Juan",       null, "6556784356", 15, 1, 13, 5, "/images/coverimages/apocalypse.png",       null, 10.95m, 25 },
                    { 2, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Children Of Iron",           "Nikki Wolf",    null, "7665438976", 16, 1, 11, 6, "/images/coverimages/childrenofiron.png",   null, 13.95m,  3 },
                    { 3, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Gold In The Dark",           "Richard Roe",   null, "5442280765", 17, 1, 13, 5, "/images/coverimages/goldinthedark.png",    null,  6.50m, 10 },
                    { 4, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Leagues Of Smoke",           "Pat Candella",  null, "4556789542", 18, 2, 11, 7, "/images/coverimages/leaguesofsmoke.png",   null,  3.00m,  1 },
                    { 5, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Alone With The Stars",       "Carlos Salazar", null, "4563358087", 19, 2, 12, 5, "/images/coverimages/alonewiththestars.png", null, 15.95m,  5 },
                    { 6, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "The Girl In The Polaroid",   "Terri Whitlock", null, "2354435678", 20, 1, 12, 6, "/images/coverimages/girlinthepolaroid.png", null,  8.25m,  2 },
                    { 7, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "1001 Jokes",                 "Mary Major",    null, "6554789632", 21, 2, 11, 5, "/images/coverimages/1001jokes.png",        null, 13.95m,  7 },
                    { 8, "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "My Search For Meaning",      "Mateo Jackson", null, "4558786554", 22, 3,  8, 7, "/images/coverimages/mysearchformeaning.png", null,  5.00m, 15 }
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
                name: "Order",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "shoppingcart",
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

            migrationBuilder.DropTable(
                name: "product",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "author",
                schema: "bobsbookstore_dbo");
        }
    }
}
