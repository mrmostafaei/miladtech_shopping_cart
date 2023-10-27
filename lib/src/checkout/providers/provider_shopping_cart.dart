part of miladtech_shopping_cart;

/// Providers
class ProviderShoppingCart extends ChangeNotifier {
  var shoppingCart = ShoppingCart();
  late CartResponseWrapper cartResponseWrapper;
  static bool isQuantityCount = true;

  /// Add cart notifier
  addToCart(Item productElement, {int funcQuantity = 0}) async {
    int vendorId = 1001;
    int productId = productElement.id;
    cartResponseWrapper = await shoppingCart.addToCart(
        productId: productId,
        vendorId: vendorId,
        unitPrice: productElement.price,
        productName: productElement.name,
        itemImage: productElement.itemImage,
        quantity: funcQuantity == 0 ? 1 : funcQuantity,
        cartItemOptionList: productElement.options,
        productDetailsObject: productElement);
    notifyListeners();
  }

  bool cartIsEmpty() {
    return shoppingCart.cartItem.isEmpty;
  }

  /// Delete selected cart item notifier
  deleteItemFromCart(int cartItemApiId, String cartName) async {
    cartResponseWrapper =
        await shoppingCart.deleteSelectedCartItem(cartItemApiId, cartName);
    notifyListeners();
  }

  /// Decrement cart item notifier
  decrementItemFromCartProvider(
      {required int productId,
      required int vendorId,
      List<dynamic>? cartItemOptionList = const []}) async {
    vendorId = 1001;
    cartResponseWrapper = shoppingCart.decrementItemFromCart(
        productId: productId,
        vendorId: vendorId,
        cartItemOptionList: cartItemOptionList);
    notifyListeners();
  }

  int? findItemIndexFromCartProvider(cartId) {
    int? index = shoppingCart.findItemIndexFromCart(cartId);
    return index;
  }

  ///show already added items with their quantity on servicelistdetail screen
  CartItem? getSpecificItemFromCartProvider(
      {required int productId, required List<dynamic> cartItemOptionList}) {
    CartItem? cartItem = shoppingCart.getSpecificItemFromCart(
        productId: productId, cartItemOptionList: cartItemOptionList);
    if (cartItem != null) {
      /* print(
          "Name ${cartItem.productDetails.name} Quantity ${cartItem.quantity}");
  */
      return cartItem;
    }
    return cartItem;
  }

  /// Get total amount
  double getTotalAmount() {
    return shoppingCart.getTotalAmount();
  }

  /// Get total with text
  double getTotalAmountWithTax() {
    return shoppingCart.getTotalAmountWithTax();
  }

  /// Get total tax amount
  double getTotalTaxAmount() {
    return shoppingCart.getTotalTaxAmount();
  }

  /// Get cart items
  List<CartItem> getCartItems() {
    return shoppingCart.cartItem;
  }

  /// return total count
  int getCartItemCount() {
    return shoppingCart.getCartItemCount(isQuantityCount: isQuantityCount)!;
  }

  printCartValue() {
/*    for (var f in shoppingCart.cartItem) {
      {
          print(f.productId);
          print(f.quantity);
        };
    }*/
  }

  /// Delete all cart from DB
  deleteAllCartProvider() {
    shoppingCart.deleteAllCart();
  }
}
