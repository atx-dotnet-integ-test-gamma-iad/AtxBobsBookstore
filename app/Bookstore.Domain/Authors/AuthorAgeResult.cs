using Microsoft.EntityFrameworkCore;

namespace Bookstore.Domain.Authors;

[Keyless]
public class AuthorAgeResult
{
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
