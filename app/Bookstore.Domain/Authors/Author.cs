using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bookstore.Domain.Authors
{
    [Table("author", Schema = "bobsbookstore_dbo")]
    public class Author
    {
        [Key]
        [Column("businessentityid")]
        public int BusinessEntityID { get; set; }

        [Column("nationalidnumber")]
        [Required]
        [StringLength(15)]
        public string NationalIDNumber { get; set; }

        [Column("loginid")]
        [Required]
        [StringLength(256)]
        public string LoginID { get; set; }

        [Column("jobtitle")]
        [Required]
        [StringLength(50)]
        public string JobTitle { get; set; }

        [Column("birthdate")]
        [Required]
        public DateTime BirthDate { get; set; }

        [Column("maritalstatus")]
        [Required]
        [StringLength(1)]
        public string MaritalStatus { get; set; }

        [Column("gender")]
        [Required]
        [StringLength(1)]
        public string Gender { get; set; }

        [Column("hiredate")]
        [Required]
        public DateTime HireDate { get; set; }

        [Column("vacationhours")]
        [Required]
        public short VacationHours { get; set; }
        
        [Column("modifieddate")]
        [Required]
        public DateTime ModifiedDate { get; set; }
    }
}
