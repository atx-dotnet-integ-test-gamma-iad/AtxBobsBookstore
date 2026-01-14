using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain.ReferenceData
{
    [Table("referencedata", Schema = "bobsbookstore_dbo")]
    public class ReferenceDataItem : Entity
    {
        // An empty constructor is required by EF Core
        private ReferenceDataItem() { }

        public ReferenceDataItem(ReferenceDataType referenceDataType, string text)
        {
            DataType = referenceDataType;
            Text = text;
        }

        [Column("id")]
        public new int Id { get; set; }

        [Column("createdby")]
        public new string? CreatedBy { get; set; }

        [Column("createdon")]
        public new DateTime CreatedOn { get; set; }

        [Column("updatedon")]
        public new DateTime? UpdatedOn { get; set; }

        [Column("datatype")]
        public ReferenceDataType DataType { get; set; }

        [Column("text")]
        public string Text { get; set; }
    }
}
