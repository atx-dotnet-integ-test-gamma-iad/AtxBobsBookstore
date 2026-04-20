using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Authors;

public class AuthorAgeResult
{
    [NotMapped]
    public int BusinessEntityID { get; set; }
    [NotMapped]
    public string FormattedModifiedDate { get; set; }
    [NotMapped]
    public int Age { get; set; }
}
