using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Authors;

[NotMapped]
public class AuthorAgeResult
{
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
