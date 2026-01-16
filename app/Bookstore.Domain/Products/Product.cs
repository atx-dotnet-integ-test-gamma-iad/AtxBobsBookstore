using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Products;

[Table("product", Schema = "bobsbookstore_dbo")]
public class Product
{
    [Key]
    [Column("productid")]
    public int ProductID { get; set; }

    [Column("name")]
    [Required]
    [StringLength(15)]
    public string Name { get; set; }

    [Column("productnumber")]
    [Required]
    [StringLength(256)]
    public string ProductNumber { get; set; }

    [Column("safetystocklevel")]
    [Required]
    public int SafetyStockLevel { get; set; }
}