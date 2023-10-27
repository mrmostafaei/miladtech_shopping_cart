import 'package:example/checkout_screen.dart';
import 'package:example/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/catelog.dart';

class MyCart extends StatelessWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 20, bottom: 20),
                child: _CartList(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleMedium;

    /// This gets the current state of CartModel and also tells Flutter
    /// to rebuild this widget when CartModel notifies listeners (in other words,
    /// when it changes).
    // var cart = context.watch<CartModel>();
    var cartProvider = context.watch<CartProvider>();

    int count = cartProvider.shoppingCart.cartItem.length;

    int _isInCart = 0;
    Widget slideView(context, index) {
      var _cartItem = cartProvider.shoppingCart.cartItem[index];
      _isInCart = _cartItem.quantity;
      int cartItemApiId = _cartItem.cartItemApiId;
      String cartName = 'main';
      List<dynamic>? optionsList = _cartItem.cartItemOptionList;
      String optionsStr = "";
      optionsList!.map((e) {
        optionsStr = optionsStr + " " + e['size'];
        optionsStr = optionsStr.trim();
      }).toList();

      Future<void> removeItem(BuildContext context) async {
        await cartProvider.deleteItemFromCart(cartItemApiId, cartName);
      }

      String itemImage = cartProvider.shoppingCart.cartItem[index].itemImage!;
      String price =
          cartProvider.shoppingCart.cartItem[index].unitPrice.toString();
      String title =
          cartProvider.shoppingCart.cartItem[index].productName.toString();
      String name = title.contains("\n")
          ? title.substring(0, title.lastIndexOf("\n"))
          : title;
      String details = title.contains("\n")
          ? title.substring(title.lastIndexOf("\n") + 1, title.length)
          : "";

      Widget itemIcon() {
        return Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: SizedBox(
            height: 35,
            width: 35,
            child: itemImage.isNotEmpty
                ? Image.network(itemImage)
                : const Icon(
                    Icons.image,
                    size: 35,
                  ),
          ),
        );
      }

      return Column(
        children: [
          Slidable(
            /// Specify a key if the Slidable is dismissible.
            key: UniqueKey(),

            /// The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              extentRatio: 0.22,
              dragDismissible: true,
              openThreshold: 0.15,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  spacing: 2,

                  /// An action can be bigger than the others.
                  flex: 1,
                  onPressed: removeItem,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                  //label: 'Remove',
                )
              ],
            ),

            /// The child of the Slidable is what the user sees when the
            /// component is not dragged.
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        itemIcon(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: itemNameStyle!
                                    .copyWith(fontSize: 15, color: Colors.blue),
                                maxLines: 2,
                              ),
                              details.trim().isEmpty
                                  ? Container()
                                  : Text(
                                      details,
                                      style: itemNameStyle.copyWith(
                                          fontSize: 12, color: Colors.grey),
                                      maxLines: 2,
                                    ),
                              Text(
                                "Size: ${optionsStr.trim().isEmpty ? "Free" : optionsStr.trim()}",
                                style: itemNameStyle.copyWith(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(price),
                IconButton(
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    cartProvider.decrementItemFromCartProvider(
                      productId: _cartItem.productId,
                      vendorId: _cartItem.vendorId!,
                      cartItemOptionList: _cartItem.cartItemOptionList,
                    );
                  },
                ),
                Text('$_isInCart'),
                IconButton(
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    Item _item =
                        Item(_cartItem.productId, _cartItem.productName!);
                    _item.price = _cartItem.unitPrice;
                    _item.options = _cartItem.cartItemOptionList;
                    cartProvider.addToCart(_item);
                  },
                )
              ],
            ),
          ),
          const Divider(height: 4, color: Colors.black)
        ],
      );
    }

    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index) {
            var _cartItem = cartProvider.shoppingCart.cartItem[index];
            _isInCart = _cartItem.quantity;
            return slideView(context, index);
          }),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18);

    return SizedBox(
      height: 200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 45.0, left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Another way to listen to a model's change is to include
                  /// the Consumer widget. This widget will automatically listen
                  /// to CartModel and rerun its builder on every change.
                  //
                  /// The important thing is that it will not rebuild
                  /// the rest of the widgets in this build method.
                  Consumer<CartProvider>(builder: (context, cart, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Items total amount',
                                style: hugeStyle.copyWith(fontSize: 20)),
                            const SizedBox(width: 15),
                            Text('\$${cart.getTotalAmount().toString()}',
                                style: hugeStyle.copyWith(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Tax amount of 18% ',
                                style: hugeStyle.copyWith(fontSize: 20)),
                            const SizedBox(width: 15),
                            Text('\$${cart.getTotalTaxAmount().toString()}',
                                style: hugeStyle.copyWith(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(height: 1, width: 260, color: Colors.black),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Grand total ',
                                style: hugeStyle.copyWith(fontSize: 20)),
                            const SizedBox(width: 15),
                            Text('\$${cart.getTotalAmountWithTax().toString()}',
                                style: hugeStyle.copyWith(fontSize: 20)),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
              TextButton(
                onPressed: () {
                  /*ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buying not supported yet.')));*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutScreen()),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('BUY'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
