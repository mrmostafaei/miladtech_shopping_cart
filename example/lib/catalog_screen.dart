import 'package:example/providers/cart_provider.dart';
import 'package:miladtech_shopping_cart/miladtech_shopping_cart.dart';
import 'package:provider/provider.dart';

import 'models/catelog.dart';

class MyCatalog extends StatelessWidget {
  const MyCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => Column(
                  children: [
                    Center(child: _MyListItem(index)),
                    Padding(
                      padding: EdgeInsets.all(index == 0 ? 0 : 8.0),
                      child: Divider(
                          height: index == 0 ? 0 : 4, color: Colors.black),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatefulWidget {
  final Item item;
  final Function(List<dynamic>)? cartItemOptionListCallBack;

  const _OptionButton(
      {required this.item, this.cartItemOptionListCallBack, Key? key})
      : super(key: key);

  @override
  _OptionButtonState createState() => _OptionButtonState(
      item: item, cartItemOptionListCallBack: cartItemOptionListCallBack);
}

class _OptionButtonState extends State<_OptionButton> {
  late CartProvider _cartProvider;
  late CartItem? _cartItem;
  late Item? item;
  final Function(List<dynamic>)? cartItemOptionListCallBack;
  bool isInited = false;
  late List<dynamic> cartItemOptionList = [];
  bool selectedSize = false;
  bool selectedSize2 = false;
  bool selectedSize3 = false;
  int selectedIndex = -1;

  _OptionButtonState({this.item, this.cartItemOptionListCallBack});

  @override
  void didUpdateWidget(covariant _OptionButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    setState(() {
      item = widget.item;
    });
  }

  @override
  void initState() {
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    super.initState();
  }

  int _checkItemisInCart() {
    _cartItem = _cartProvider.getSpecificItemFromCartProvider(
        productId: item!.id, cartItemOptionList: cartItemOptionList);
    return _cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    /// The context.select() method will let you listen to changes to
    /// a *part* of a model. You define a function that "selects" (i.e. returns)
    /// the part you're interested in, and the provider package will not rebuild
    /// this widget unless that particular part of the model changes.
    /// This can lead to significant performance improvements.

    if (!isInited) {
      cartItemOptionList = [
        {"size": "s"}
      ];
      selectedIndex = _checkItemisInCart() > 0 ? 1 : -1;
      if (selectedIndex == 1) {
        cartItemOptionListCallBack?.call(cartItemOptionList);
      } else {
        cartItemOptionList = [];
      }
      item!.options = cartItemOptionList;
      isInited = true;
    }
    double height = 25;
    double width = 25;
    Color selectedColor = Colors.grey;

    Widget blockView(
        {Color boxColor = Colors.transparent,
        String value = "",
        clickCallBack,
        bool isSelected = false}) {
      return InkWell(
        onTap: clickCallBack,
        child: Container(
            height: isSelected ? height + 0 : height,
            width: isSelected ? width + 0 : width,
            child: Center(child: Text(value)),
            decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                      color: selectedColor,
                      width: isSelected
                          ? 2
                          : 2), /* borderRadius: const BorderRadius.all(Radius.circular(4))*/
                ),
                color: !isSelected ? Colors.transparent : boxColor)),
      );
    }

    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              blockView(
                  boxColor: Colors.blue,
                  isSelected: selectedIndex == 1,
                  value: "S",
                  clickCallBack: () {
                    setState(() {
                      selectedIndex = selectedIndex != 1 ? 1 : -1;
                      if (selectedIndex == 1) {
                        cartItemOptionList = [
                          {"size": "S"}
                        ];
                      } else {
                        cartItemOptionList = [];
                      }
                      cartItemOptionListCallBack?.call(cartItemOptionList);
                      item!.options = cartItemOptionList;
                    });
                    item!.options = cartItemOptionList;
                    // print("object");
                  }),
              const SizedBox(
                width: 15,
              ),
              blockView(
                  boxColor: Colors.green,
                  isSelected: selectedIndex == 2,
                  value: "M",
                  clickCallBack: () {
                    setState(() {
                      selectedIndex = selectedIndex != 2 ? 2 : -1;
                      if (selectedIndex == 2) {
                        cartItemOptionList = [
                          {"size": "M"}
                        ];
                      } else {
                        cartItemOptionList = [];
                      }
                      cartItemOptionListCallBack?.call(cartItemOptionList);
                      item!.options = cartItemOptionList;
                    });
                  }),
              const SizedBox(
                width: 15,
              ),
              blockView(
                  boxColor: Colors.orangeAccent,
                  isSelected: selectedIndex == 3,
                  value: "L",
                  clickCallBack: () {
                    setState(() {
                      selectedIndex = selectedIndex != 3 ? 3 : -1;
                      if (selectedIndex == 3) {
                        cartItemOptionList = [
                          {"size": "L"}
                        ];
                      } else {
                        cartItemOptionList = [];
                      }
                      cartItemOptionListCallBack?.call(cartItemOptionList);
                      item!.options = cartItemOptionList;
                    });
                  }),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Consumer<CartProvider>(builder: (context, cart, child) {
          return _AddButton(item: item!);
        })
      ],
    ));
  }
}

class _AddButton extends StatefulWidget {
  final Item item;

  const _AddButton({required this.item, Key? key}) : super(key: key);

  @override
  __AddButtonState createState() => __AddButtonState(item: item);
}

class __AddButtonState extends State<_AddButton> {
  late CartProvider _cartProvider;
  late CartItem? _cartItem;
  late int _isInCart;
  late List<dynamic> cartItemOptionList = [];
  late Item? item;

  __AddButtonState({this.item});

  @override
  void didUpdateWidget(covariant _AddButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    setState(() {
      item = widget.item;
    });
  }

  @override
  void initState() {
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    super.initState();
  }

  int _checkItemisInCart() {
    _cartItem = _cartProvider.getSpecificItemFromCartProvider(
        productId: item!.id, cartItemOptionList: cartItemOptionList);
    return _cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    cartItemOptionList = item!.options!;
    _isInCart = _checkItemisInCart();
    return SizedBox(
      height: 45,
      child: Center(
        child: TextButton(
          onPressed: _isInCart != 0
              ? null
              : () {
                  /// If the item is not in cart, we let the user add it.
                  /// We are using context.read() here because the callback
                  /// is executed whenever the user taps the button. In other
                  /// words, it is executed outside the build method.
                  /*var cart = context.read<CartModel>();
                  cart.add(item); */

                  // widget.item.options = cartItemOptionList;
                  Item mItem = item!;
                  // print("object");
                  _cartProvider.addToCart(mItem);
                  setState(() {});
                },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).primaryColor;
              }
              return null; // Defer to the widget's default.
            }),
          ),
          child: _isInCart > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _isInCart == 1
                          ? null
                          : () {
                              // Item mItem = item!;
                              // print("object");
                              // _cartProvider.addToCart(widget.item.id);
                              _cartProvider.decrementItemFromCartProvider(
                                  productId: item!.id,
                                  vendorId: 1001,
                                  cartItemOptionList: cartItemOptionList);
                              setState(() {});
                            },
                    ),
                    Text('$_isInCart'),
                    IconButton(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        item!.options = cartItemOptionList;
                        Item mItem = item!;
                        _cartProvider.addToCart(mItem);
                        setState(() {});
                      },
                    ),
                  ],
                )
              : const Text('ADD'),
        ),
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Catalog', style: Theme.of(context).textTheme.titleMedium),
      floating: true,
      automaticallyImplyLeading: false,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.radio_button_checked_outlined,
                    color: CartProvider.isQuantityCount
                        ? Colors.black
                        : Colors.white,
                  ),
                  onPressed: () {
                    CartProvider.isQuantityCount =
                        !CartProvider.isQuantityCount;
                  },
                ),
                Stack(
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, consumer, child) {
                        return IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () => consumer.getCartItemCount() > 0
                              ? Navigator.pushNamed(context, '/cart')
                              : null,
                        );
                      },
                    ),
                    Consumer<CartProvider>(
                      builder: (context, consumer, child) {
                        return Positioned(
                          right: 10,
                          child: Text("${consumer.getCartItemCount()}"),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      /// Here, we are only interested in the item at [index]. We don't care
      /// about any other change.
      (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.titleMedium;

    String name = item.name.substring(0, item.name.lastIndexOf("\n"));
    String details =
        item.name.substring(item.name.lastIndexOf("\n") + 1, item.name.length);

    return index == 0
        ? Container(
            height: 0,
            color: Colors.grey,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: LimitedBox(
              maxHeight: 93,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*SizedBox(
              height: 20,
              width: 20,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  color: item.color,
                ),
              ),
            ),*/
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              name,
                              style: textTheme!.copyWith(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              maxLines: 1,
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              details,
                              style: textTheme.copyWith(fontSize: 12),
                              maxLines: 2,
                            )),
                        Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Text("Size  ",
                                  style: textTheme.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              _OptionButton(
                                item: item,
                                cartItemOptionListCallBack: (value) {
                                  item.options = value;
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ), /*
            const SizedBox(width: 24),
            Consumer<CartProvider>(builder: (context, cart, child) {
              return _AddButton(item: item);
            }),*/
                ],
              ),
            ),
          );
  }
}
