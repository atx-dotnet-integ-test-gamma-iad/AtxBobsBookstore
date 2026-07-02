using System.ComponentModel.DataAnnotations;

namespace Bookstore.Domain.Authors;

public class AuthorAgeResult
{
    [Key]
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
