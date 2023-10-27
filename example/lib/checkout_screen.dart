import 'package:example/providers/cart_provider.dart';
import 'package:miladtech_shopping_cart/miladtech_shopping_cart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CartProvider _cartProvider;

  ShippingAddressModel? shippingAddress;

  ShippingAddressModel? billingAddress = ShippingAddressModel(
      address: Address(
          city: "Indore",
          country: "India",
          fullAddress: "263, Orbit Mall, AB Rd, Indore, Madhya Pradesh 452010",
          state: "Madhya Pradesh",
          zip: 452010),
      addressId: -1,
      isDefault: true,
      contact: Contact(primaryNumber: "1234567890"),
      gAddress: GAddress(lat: "22.74461378171717", long: "75.89668946851594"));

  TextEditingController promoCodeController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  bool _couponApplied = false;

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Shipping Info",
                // style: CustomTextStyle.textFormFieldMedium
                //     .copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Get it by 20 jul - 27 jul | Free Delivery",
                // style: CustomTextStyle.textFormFieldMedium.copyWith(
                //   color: Colors.black,
                //   fontSize: 12,
                // ),
              )
            ],
          ),
        ],
      ),
    );
  }

  showAddress({required label, required address, required editButtonCallback}) {
    return Card(
      color: Colors.redAccent.withOpacity(0.2),
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.only(left: 12, top: 5, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 6,
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(address ?? ''),
                ),
                TextButton(
                  onPressed: editButtonCallback,
                  child: const Text(
                    "Change",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  addAddressView({label, required clickCallback}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: clickCallback,
              child: Container(
                  decoration: BoxDecoration(
                    // color: const Color(0xff7c94b6),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add address',
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  couponField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text("You have promocode/coupon?"),
        const SizedBox(
          height: 3,
        ),
        _couponApplied
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Coupon Code: ${promoCodeController.text}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        ResponseWrapper? response = await _cartProvider
                            .redeemCoupon(couponCode: promoCodeController.text);
                        if (response != null) {
                          if (response.status) {
                            //  promoCodeController.text = '';
                            setState(() {
                              _couponApplied = false;
                              promoCodeController.text = '';
                            });
                          } else {
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context1) {
                                  //mContext = context1;
                                  return AlertDialog(
                                    //insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                    /*  title:  Text(,
                          style:  const TextStyle(color: Colors.black54, fontSize: 20.0)),
                   */
                                    content: Text(
                                      response.message,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Padding(
                                          padding: EdgeInsets.only(bottom: 0),
                                          child: Text("OK",
                                              style: TextStyle(fontSize: 18.0)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context1);
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      child: const Text(
                        'Redeem Coupon',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              )
            : Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: promoCodeController,
                      maxLength: 6,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.all(5),
                          hintText: 'Enter coupon code',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        ResponseWrapper? response = await _cartProvider
                            .applyCoupon(couponCode: promoCodeController.text);
                        if (response != null) {
                          if (response.status) {
                            //  promoCodeController.text = '';
                            setState(() {
                              _couponApplied = true;
                            });
                          } else {
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context1) {
                                  //mContext = context1;
                                  return AlertDialog(
                                    //insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                    /*  title:  Text(,
                          style:  const TextStyle(color: Colors.black54, fontSize: 20.0)),
                   */
                                    content: Text(
                                      response.message,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Padding(
                                          padding: EdgeInsets.only(bottom: 0),
                                          child: Text("OK",
                                              style: TextStyle(fontSize: 18.0)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context1);
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      child: const Text('Apply Coupon'))
                ],
              ),
      ],
    );
  }

  proceedForPayment() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Proceed for payment'),
    );
  }

  addAddressTextField({required textFieldController}) {
    return Material(
      child: TextField(
        controller: textFieldController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.all(5),
            hintText: 'Enter address',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            fillColor: Color(0xfff3f3f4),
            filled: true),
      ),
    );
  }

  addAddressButton({addCallback}) {
    return ElevatedButton(
      onPressed: addCallback,
      child: const Text("Add"),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
          color: Colors.white30,
          padding: const EdgeInsets.all(15),
          child: ListView(
            shrinkWrap: true,
            children: [
              _CartList(),
              const SizedBox(
                height: 10,
              ),
              shippingAddress != null
                  ? showAddress(
                      label: "Delivery address",
                      address: shippingAddress!.address!.fullAddress ?? '',
                      editButtonCallback: () {})
                  : addAddressView(
                      clickCallback: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        addAddressTextField(
                                            textFieldController:
                                                shippingAddressController),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        addAddressButton(addCallback: () {
                                          setState(() {
                                            shippingAddress = ShippingAddressModel(
                                                address: Address(
                                                    city: "Indore",
                                                    country: "India",
                                                    fullAddress:
                                                        shippingAddressController
                                                            .text,
                                                    state: "Madhya Pradesh",
                                                    zip: 452010),
                                                addressId: -1,
                                                isDefault: true,
                                                contact: Contact(
                                                    primaryNumber:
                                                        "1234567890"),
                                                gAddress: GAddress(
                                                    lat: "22.74461378171717",
                                                    long: "75.89668946851594"));
                                          });
                                          Navigator.pop(context);
                                        })
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      label: "Delivery Address"),
              const SizedBox(
                height: 10,
              ),
              shippingAddress != null
                  ? showAddress(
                      label: "Billing address",
                      address: billingAddress!.address!.fullAddress ?? '',
                      editButtonCallback: () {})
                  : addAddressView(
                      clickCallback: () {}, label: "Billing Address"),
              const SizedBox(
                height: 10,
              ),
              couponField(),
              const SizedBox(
                height: 10,
              ),
              const Divider(height: 4, color: Colors.black),
              _CartTotal(),
              const SizedBox(
                height: 10,
              ),
              proceedForPayment()
            ],
          )),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleSmall;

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
            // Specify a key if the Slidable is dismissible.
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
                  // An action can be bigger than the others.
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
                    // cartProvider.decrementItemFromCartProvider(
                    //   productId: _cartItem.productId,
                    //   vendorId: _cartItem.vendorId!,
                    //   cartItemOptionList: _cartItem.cartItemOptionList,
                    // );
                    Navigator.pop(context);
                  },
                ),
                Text('$_isInCart'),
                IconButton(
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Item _item =
                    // Item(_cartItem.productId, _cartItem.productName!);
                    // _item.price = _cartItem.unitPrice;
                    // _item.options = _cartItem.cartItemOptionList;
                    // cartProvider.addToCart(_item);

                    Navigator.pop(context);
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
          shrinkWrap: true,
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

    shownAmountRow({label, value}) {
      return Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(label, style: hugeStyle.copyWith(fontSize: 18)),
          ),
          const SizedBox(width: 15),
          Text('$value', style: hugeStyle.copyWith(fontSize: 18)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    cart.getAppliedCouponAmount() > 0
                        ? shownAmountRow(
                            label: 'Total coupon amount',
                            value:
                                '\$${cart.getAppliedCouponAmount().toString()}')
                        : Container(),
                    const SizedBox(height: 10),
                    shownAmountRow(
                        label: 'Items total amount',
                        value: '\$${cart.getTotalAmount().toString()}'),
                    const SizedBox(height: 10),
                    shownAmountRow(
                        label: 'Tax amount of 18%',
                        value: '\$${cart.getTotalTaxAmount().toString()}'),
                    const SizedBox(height: 5),
                    Container(height: 1, width: 220, color: Colors.black),
                    const SizedBox(height: 5),
                    shownAmountRow(
                        label: 'Grand total',
                        value: '\$${cart.getTotalAmountWithTax().toString()}'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
