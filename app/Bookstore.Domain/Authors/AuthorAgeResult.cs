using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Authors;

// Note: AuthorAgeResult has no schema mappings - appears to be a DTO/Result class not mapped to database
public class AuthorAgeResult
{
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
