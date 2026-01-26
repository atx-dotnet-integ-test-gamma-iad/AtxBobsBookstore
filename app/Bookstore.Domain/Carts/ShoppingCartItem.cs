using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Bookstore.Domain.Books;

namespace Bookstore.Domain.Carts
{
    [Table("shoppingcartitem", Schema = "bobsbookstore_dbo")]
    public class ShoppingCartItem : Entity
    {
        // An empty constructor is required by EF Core
        private ShoppingCartItem() { }

        public ShoppingCartItem(ShoppingCart shoppingCart, int bookId, int quantity, bool wantToBuy)
        {
            ShoppingCartId = shoppingCart.Id;
            ShoppingCart = shoppingCart;
            BookId = bookId;
            Quantity = quantity;
            WantToBuy = wantToBuy;
        }

        [Column("shoppingcartid")]
        public int ShoppingCartId { get; set; }
        
        public ShoppingCart ShoppingCart { get; set; }

        [Column("bookid")]
        public int BookId { get; set; }
        
        public Book Book { get; set; }

        [Column("quantity")]
        public int Quantity { get; set; }

        [Column("wanttobuy")]
        public bool WantToBuy { get; set; }

        // Inherited properties from Entity base class
        [Column("id")]
        public new int Id { get; set; }

        [Column("createdby")]
        public new string CreatedBy { get; set; }

        [Column("createdon")]
        public new DateTime CreatedOn { get; set; }

        [Column("updatedon")]
        public new DateTime? UpdatedOn { get; set; }
    }
}