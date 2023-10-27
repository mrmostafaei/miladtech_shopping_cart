import 'cart_model.dart';

///Cart Response wrapper
class CartResponseWrapper {
  final bool status;
  final String message;
  List<CartItem> cartItemList;
  final int price = 42;

  CartResponseWrapper(this.status, this.message, this.cartItemList);
}
