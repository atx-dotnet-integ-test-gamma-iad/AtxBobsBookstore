using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Authors;

[Table("authorageresult", Schema = "bobsbookstore_dbo")]
public class AuthorAgeResult
{
    [Column("businessentityid")]
    public int BusinessEntityID { get; set; }
    [Column("formattedmodifieddate")]
    public string FormattedModifiedDate { get; set; }
    [Column("age")]
    public int Age { get; set; }
}