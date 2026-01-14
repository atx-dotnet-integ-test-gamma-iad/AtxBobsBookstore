using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.Customers
{
    [Table("customer", Schema = "bobsbookstore_dbo")]
    public class Customer : Entity
    {
        [Column("id")]
        public new int Id { get; set; }

        [Column("createdby")]
        public new string? CreatedBy { get; set; }

        [Column("createdon")]
        public new DateTime CreatedOn { get; set; }

        [Column("updatedon")]
        public new DateTime? UpdatedOn { get; set; }

        [Column("sub")]
        public string Sub { get; set; }

        [Column("username")]
        public string? Username { get; set; }

        [Column("firstname")]
        public string? FirstName { get; set; }

        [Column("lastname")]
        public string? LastName { get; set; }

        [NotMapped]
        public string FullName => $"{FirstName} {LastName}";

        [Column("email")]
        public string? Email { get; set; }

        [Column("dateofbirth")]
        public DateTime? DateOfBirth { get; set; }

        [Column("phone")]
        public string? Phone { get; set; }
    }
}
