namespace Bookstore.Domain.Authors;

[System.ComponentModel.DataAnnotations.Schema.NotMapped]
public class AuthorAgeResult
{
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
