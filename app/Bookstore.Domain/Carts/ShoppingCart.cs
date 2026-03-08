using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using Bookstore.Domain.Customers;

namespace Bookstore.Domain.Carts
{
    public enum ShoppingCartItemFilter
    {
        IncludeOutOfStockItems,
        ExcludeOutOfStockItems
    }

    [Table("shoppingcart", Schema = "bobsbookstore_dbo")]
    public class ShoppingCart : Entity
    {
        private readonly List<ShoppingCartItem> shoppingCartItems = new List<ShoppingCartItem>();

        public ShoppingCart(string correlationId)
        {
            CorrelationId = correlationId;
        }

        public ShoppingCart(Customer customer)
        {
            CustomerId = customer.Id;
            Customer = customer;
        }

        private ShoppingCart() { }

        [Column("correlationid")]
        public string CorrelationId { get; set; }

        [Column("customerid")]
        public int CustomerId { get; set; }

        public Customer Customer { get; set; }

        public IEnumerable<ShoppingCartItem> ShoppingCartItems => shoppingCartItems;

        public void AddItemToShoppingCart(int bookId, int quantity)
        {
            shoppingCartItems.Add(new ShoppingCartItem(this, bookId, quantity, true));
        }

        public void AddItemToWishlist(int bookId)
        {
            shoppingCartItems.Add(new ShoppingCartItem(this, bookId, 1, false));
        }

        public IEnumerable<ShoppingCartItem> GetWishListItems()
        {
            return shoppingCartItems.Where(x => !x.WantToBuy);
        }

        public IEnumerable<ShoppingCartItem> GetShoppingCartItems(ShoppingCartItemFilter filter)
        {
            var items = shoppingCartItems.Where(x => x.WantToBuy);
            if (filter == ShoppingCartItemFilter.ExcludeOutOfStockItems)
            {
                items = items.Where(x => x.Book != null && x.Book.Quantity > 0);
            }
            return items;
        }

        public decimal GetSubTotal(ShoppingCartItemFilter filter)
        {
            return GetShoppingCartItems(filter).Sum(x => x.Book != null ? x.Book.Price * x.Quantity : 0);
        }

        public void MoveWishListItemToShoppingCart(int shoppingCartItemId)
        {
            var item = shoppingCartItems.SingleOrDefault(x => x.Id == shoppingCartItemId);
            if (item != null)
            {
                item.WantToBuy = true;
                item.Quantity = 1;
            }
        }

        public void RemoveShoppingCartItemById(int shoppingCartItemId)
        {
            var item = shoppingCartItems.SingleOrDefault(x => x.Id == shoppingCartItemId);
            if (item != null)
            {
                shoppingCartItems.Remove(item);
            }
        }
    }
}
