import 'package:example/models/catelog.dart';
import 'package:miladtech_shopping_cart/miladtech_shopping_cart.dart';

/// Cart provider Notifier
class CartProvider extends ChangeNotifier {
  var shoppingCart = ShoppingCart();
  late CartResponseWrapper cartResponseWrapper;
  late ResponseWrapper responseWrapper;
  static bool isQuantityCount = true;

  addToCart(Item _productElement, {int funcQuantity = 0}) async {
    int vendorId = 1001;
    int productId = _productElement.id;

    cartResponseWrapper = await shoppingCart.addToCart(
        productId: productId,
        vendorId: vendorId,
        unitPrice: _productElement.price,
        productName: _productElement.name,
        itemImage: _productElement.itemImage,
        quantity: funcQuantity == 0 ? 1 : funcQuantity,
        cartItemOptionList: _productElement.options,
        productDetailsObject: _productElement);
    notifyListeners();
  }

  ///Check is cart empty
  bool cartIsEmpty() {
    return shoppingCart.cartItem.isEmpty;
  }

  /// Delete cart item
  deleteItemFromCart(int cartItemApiId, String cartName) async {
    cartResponseWrapper =
        await shoppingCart.deleteSelectedCartItem(cartItemApiId, cartName);
    notifyListeners();
  }

  /// Decrement Item From Cart
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

/*  incrementItemToCartProvider(int index) async {
    cartResponseWrapper = shoppingCart.incrementItemToCart(index);
    notifyListeners();
  }*/

  int? findItemIndexFromCartProvider(cartId) {
    int? index = shoppingCart.findItemIndexFromCart(cartId);
    return index;
  }

  ///apply coupon amount
  Future<ResponseWrapper?> applyCoupon({required couponCode}) async {
    responseWrapper = shoppingCart.applyCoupon(couponCode: couponCode);
    notifyListeners();
    return responseWrapper;
  }

  ///redeem coupon
  Future<ResponseWrapper?> redeemCoupon({required couponCode}) async {
    responseWrapper = shoppingCart.redeemCoupon(couponCode: couponCode);
    notifyListeners();
    return responseWrapper;
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

  double getTotalAmount() {
    return shoppingCart.getTotalAmount();
  }

  double getTotalAmountAfterApplyCoupon(couponAmount) {
    return shoppingCart.getTotalAmountAfterApplyCoupon(
        couponAmount: couponAmount);
  }

  double getTotalAmountWithTax() {
    return shoppingCart.getTotalAmountWithTax();
  }

  double getTotalTaxAmount() {
    return shoppingCart.getTotalTaxAmount();
  }

  List<CartItem> getCartItems() {
    return shoppingCart.cartItem;
  }

  int getCartItemCount() {
    return shoppingCart.getCartItemCount(isQuantityCount: isQuantityCount)!;
  }

  double getAppliedCouponAmount() {
    return shoppingCart.getAppliedCouponAmount()!;
  }

  printCartValue() {
    /*   for (var f in shoppingCart.cartItem) {
      {
          print(f.productId);
          print(f.quantity);
        }
    }*/
  }

  deleteAllCartProvider() {
    shoppingCart.deleteAllCart();
  }
}
