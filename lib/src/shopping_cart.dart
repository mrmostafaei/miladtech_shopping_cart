part of miladtech_shopping_cart;

///  Shopping cart main class to get cart info and card details
class ShoppingCart {
  static final ShoppingCart _instance = ShoppingCart._internal();

  ShoppingCart._internal() {
/*    _cartItemList = <CartItem>[];
    _vendorCartItemList = {};*/
  }

  factory ShoppingCart() {
    return _instance;
  }

  late List<CartItem> _cartItemList;
  late double _couponAmount = 0.0;
  final ConfigSetting _configSetting = ConfigSetting.instance;
  late Map<String, List<CartItem>> _vendorCartItemList;
  late CartResponseWrapper message;
  late ResponseWrapper responseWrapper;

  ///Cart item list
  List<CartItem> get cartItem => _cartItemList;

  /// This method is called when we have to add new product or increment same product into cart
  Future<dynamic> addToCart(
      {required int productId,
      required int vendorId,
      required double unitPrice,
      required String itemImage,
      String? productName,
      String? cartName = 'main',
      int quantity = 1,
      List<dynamic>? cartItemOptionList = const [],
      dynamic productDetailsObject}) async {
    ///Check vendor id must bigger than 0
    if (vendorId <= 0) {
      message = CartResponseWrapper(true, _validVendorIdMessage, []);
      return message;
    }

    ///Check product id must bigger than 0
    else if (productId <= 0) {
      message = CartResponseWrapper(true, _validProductIdMessage, []);
      return message;
    } else {
      String mapKey = vendorId.toString() + cartName!;
      _cartItemList = _vendorCartItemList[mapKey] ?? [];
      CartItem cartItem = _setProductValues(
          productId: productId,
          vendorId: vendorId,
          cartName: cartName,
          unitPrice: unitPrice,
          productName: productName,
          itemImage: itemImage,
          quantity: quantity,
          cartItemOptionList: cartItemOptionList,
          productDetailsObject: productDetailsObject);

      ///Check cart list status if it empty than we will add item in cart list and update vendor id
      if (_cartItemList.isEmpty) {
        cartItem.subTotal = packageUtil.cartItemSubTotal(
            quantity: quantity, unitPrice: unitPrice);
        //Add item in DB
        DbCartItemModel? dbCartItem =
            _setProductValuesForDb(cartItem: cartItem);
        dbCartItem = await dbMain.dbAddCartItem(content: dbCartItem);
        if (dbCartItem != null) {
          cartItem.cartItemApiId = dbCartItem.cartItemApiId;
          _cartItemList.add(cartItem);
          _vendorCartItemList[mapKey] = _cartItemList;
        }
        message = CartResponseWrapper(true, _successMessage, _cartItemList);
        return message;
      }

      /// Check product's options list combination for update and add
      else {
        int index = _cartItemList.indexWhere((element) =>
            cartItem.productId == element.productId &&
            cartItem.cartName == element.cartName &&
            packageUtil.compareOptions(
                cartItemOptionList: element.cartItemOptionList!,
                cartItemOptionList2: cartItemOptionList!));

        ///If is true than compare item options
        if (index >= 0) {
          int index = _cartItemList.indexWhere((element) {
            if (cartItem.productId == element.productId &&
                cartItem.cartName == element.cartName &&
                packageUtil.compareOptions(
                    cartItemOptionList: element.cartItemOptionList!,
                    cartItemOptionList2: cartItemOptionList!)) {
              return true;
            }
            return false;
          });

          ///Update item count and sub total in cart
          if (index >= 0) {
            cartItem = _cartItemList[index];
            int quantity = cartItem.quantity < 0 ? 1 : cartItem.quantity + 1;
            cartItem = _updateProductDetails(
                index: index,
                cartItem: cartItem,
                quantity: quantity,
                unitPrice: unitPrice);
            message = CartResponseWrapper(true, _updateMessage, _cartItemList);
            return message;
          }

          ///Add new item in cart
          else if (_configSetting._isMultiVendor!) {
            ///Add new item in cart
            cartItem.subTotal = packageUtil.cartItemSubTotal(
                quantity: quantity, unitPrice: unitPrice);

            ///Add item in DB
            DbCartItemModel? dbCartItem =
                _setProductValuesForDb(cartItem: cartItem);
            dbCartItem = await dbMain.dbAddCartItem(content: dbCartItem);
            if (dbCartItem != null) {
              cartItem.cartItemApiId = dbCartItem.cartItemApiId;
              _cartItemList.add(cartItem);
              _vendorCartItemList[mapKey] = _cartItemList;
            }
            message = CartResponseWrapper(true, _successMessage, _cartItemList);
            return message;
          }

          ///compare Vendor id with pre added and add item in cart
          else if (!_configSetting._isMultiVendor!) {
            ///We will compare Vendor id with pre added
            int index = _cartItemList.indexWhere((element) =>
                cartItem.vendorId == element.vendorId &&
                cartItem.cartName == element.cartName &&
                packageUtil.compareOptions(
                    cartItemOptionList: element.cartItemOptionList!,
                    cartItemOptionList2: cartItemOptionList!));
            bool isVendorAdded = index > 0 ? true : false;
            if (isVendorAdded) {
              ///Add new item in cart
              cartItem.subTotal = packageUtil.cartItemSubTotal(
                  quantity: quantity, unitPrice: unitPrice);

              ///Add item in DB
              DbCartItemModel? dbCartItem =
                  _setProductValuesForDb(cartItem: cartItem);
              dbCartItem = await dbMain.dbAddCartItem(content: dbCartItem);
              if (dbCartItem != null) {
                cartItem.cartItemApiId = dbCartItem.cartItemApiId;
                _cartItemList.add(cartItem);
                _vendorCartItemList[mapKey] = _cartItemList;
              }
              message =
                  CartResponseWrapper(true, _successMessage, _cartItemList);
              return message;
            } else {
              ///Asked to user for delete old vendor and add again
            }
          }
        }

        ///Add as a new product
        else {
          ///Add as a new product
          cartItem.subTotal = packageUtil.cartItemSubTotal(
              quantity: quantity, unitPrice: unitPrice);

          ///Add item in DB
          DbCartItemModel? dbCartItem =
              _setProductValuesForDb(cartItem: cartItem);
          dbCartItem = await dbMain.dbAddCartItem(content: dbCartItem);
          if (dbCartItem != null) {
            cartItem.cartItemApiId = dbCartItem.cartItemApiId;
            _cartItemList.add(cartItem);
            _vendorCartItemList[mapKey] = _cartItemList;
          }
          message = CartResponseWrapper(true, _successMessage, _cartItemList);
          return message;
        }
      }
    }
  }

  /// This function is used to decrement the item quantity from cart
  decrementItemFromCart(
      {required int productId,
      required int vendorId,
      String? cartName = "main",
      List<dynamic>? cartItemOptionList = const []}) {
    ///Check vendor id must bigger than 0
    if (vendorId <= 0) {
      message = CartResponseWrapper(true, _validVendorIdMessage, []);
      return message;
    }

    ///Check product id must bigger than 0
    else if (productId <= 0) {
      message = CartResponseWrapper(true, _validProductIdMessage, []);
      return message;
    } else {
      String mapKey = vendorId.toString() + cartName!;

      _cartItemList = _vendorCartItemList[mapKey] ?? [];
      CartItem? cartItem;

      /// Check product's options list combination for to remove item
      if (_cartItemList.isNotEmpty) {
        int index = _cartItemList
            .indexWhere((element) => productId == element.productId);

        ///If is true than compare item options
        if (index >= 0) {
          int index = _cartItemList.indexWhere((element) {
            if (productId == element.productId &&
                cartName == element.cartName &&
                packageUtil.compareOptions(
                    cartItemOptionList: element.cartItemOptionList!,
                    cartItemOptionList2: cartItemOptionList!)) {
              return true;
            }
            return false;
          });

          ///Item decrement from cart
          if (index >= 0) {
            cartItem = _cartItemList[index];

            ///Update Quantity
            if (cartItem.quantity > 1) {
              int quantity = cartItem.quantity - 1;
              double unitPrice = cartItem.unitPrice;
              cartItem = _updateProductDetails(
                  index: index,
                  cartItem: cartItem,
                  quantity: quantity,
                  unitPrice: unitPrice);
              message =
                  CartResponseWrapper(true, _updateMessage, _cartItemList);
              return message;
            } else {
              message = CartResponseWrapper(true, _noItemQuantityMessage, []);
              return message;
            }
          }
        } else {
          message = CartResponseWrapper(true, _noItemFoundMessage, []);
          return message;
        }
      } else {
        message = CartResponseWrapper(true, _noItemFoundMessage, []);
        return message;
      }
    }
  }

  ///Delete/Remove item
  Future<dynamic> deleteSelectedCartItem(int cartItemId, String cartName) async {
    DbCartItemModel? dbCartItemModel = await dbMain.dbDeleteSelectedCartItem(
        cartItemId: cartItemId, cartName: cartName);
    if (dbCartItemModel != null) {
      await _getDataFromDb(
          vendorId: dbCartItemModel.vendorId, cartName: cartName);
    }

    CartItem cartItem = _setProductValues(
        productId: dbCartItemModel!.productId,
        vendorId: dbCartItemModel.vendorId,
        cartName: dbCartItemModel.cartName,
        unitPrice: dbCartItemModel.unitPrice,
        productName: dbCartItemModel.productName,
        itemImage: dbCartItemModel.itemImage,
        quantity: dbCartItemModel.quantity);
    CartResponseWrapper message =
        CartResponseWrapper(true, _successMessage, [cartItem]);
    return Future.value(message);
  }

  ///Delete/Remove item
  Future<dynamic> dbDeleteSelectedCart(int vendorId, String cartName) async {
    bool? isDeleted = await dbMain.dbDeleteSelectedCart(
        vendorId: vendorId, cartName: cartName);
    if (isDeleted) {
      await _getDataFromDb(vendorId: vendorId, cartName: cartName);
    }
    return Future.value(isDeleted);
  }

  ///Delete all Cart item
  Future<void> deleteAllCart() async {
    await dbMain.dbClear();
    _cartItemList = <CartItem>[];
    _vendorCartItemList = {};
  }

  int? findItemIndexFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        return i;
      }
    }
    return null;
  }

  ///Get selected item from cart db
  CartItem? getSpecificItemFromCart({
    required int productId,
    required List<dynamic>? cartItemOptionList,
    int? vendorId,
  }) {
    ///List<CartItem> _cartItemList = _vendorCartItemList[vendorId] ?? [];
    int index = _cartItemList.indexWhere((element) {
      if (productId == element.productId &&
          packageUtil.compareOptions(
              cartItemOptionList: element.cartItemOptionList!,
              cartItemOptionList2: cartItemOptionList!)) {
        return true;
      }
      return false;
    });

    if (index >= 0) {
      return _cartItemList[index];
    } else {
      return null;
    }
  }

  ///Apply coupon
  ResponseWrapper applyCoupon({required couponCode}) {
    if (couponCode != null &&
        couponCode.toString().trim().isNotEmpty &&
        couponCode == '100001') {
      // Map data = {"coupon_code": couponCode};
      ///var response = apiRequest.applyCoupon(couponCode:data);
      try {
        var response = ' { "userId":1001,"couponCode":"","totalAmount":5.0 } ';
        CouponModel couponModel = CouponModel.fromJson(json.decode(response));
        _couponAmount = _couponAmount + (couponModel.totalAmount ?? 0.0);
        responseWrapper = ResponseWrapper(
          true,
          "Coupon Applied Successfully",
        );
      } catch (e) {
        // print(e);
        responseWrapper = ResponseWrapper(
          false,
          "Coupon apply attemp failure",
        );
      }
    } else {
      responseWrapper = ResponseWrapper(
        false,
        "Invalid Coupon",
      );
    }

    return responseWrapper;
  }

  ///Apply coupon
  ResponseWrapper redeemCoupon({required couponCode}) {
    if (couponCode != null &&
        couponCode.toString().trim().isNotEmpty &&
        couponCode == '100001') {
      // Map data = {"coupon_code": couponCode};
      ///var response = apiRequest.applyCoupon(couponCode:data);
      try {
        var response = ' { "userId":1001,"couponCode":"","totalAmount":5.0 } ';
        CouponModel couponModel = CouponModel.fromJson(json.decode(response));
        _couponAmount = _couponAmount - (couponModel.totalAmount ?? 0.0);
        responseWrapper = ResponseWrapper(
          true,
          "Coupon Redeemed Successfully",
        );
      } catch (e) {
        //print(e);
        responseWrapper = ResponseWrapper(
          false,
          "Coupon redeem attemp failure",
        );
      }
    } else {
      responseWrapper = ResponseWrapper(
        false,
        "Invalid Coupon",
      );
    }

    return responseWrapper;
  }

  ///Get total amount after apply coupon
  getTotalAmountAfterApplyCoupon({required couponAmount}) {
    double totalAmount = 0.0;
    for (var e in _cartItemList) {
      totalAmount += e.subTotal!;
    }
    if (couponAmount != null && couponAmount.toString().trim().isNotEmpty) {
      totalAmount = totalAmount - couponAmount;
    }
    return totalAmount;
  }

  /// This function is used to increment the item quantity into cart
  incrementItemToCart(int index) {
    _cartItemList[index].quantity = ++_cartItemList[index].quantity;
    _cartItemList[index].subTotal =
        (_cartItemList[index].quantity * _cartItemList[index].unitPrice)
            .roundToDouble();
    return CartResponseWrapper(true, _successMessage, _cartItemList);
  }

  /// This method is called when we have to [initialize the values in our cart object]
  CartItem _setProductValues(
      {required int productId,
      required int vendorId,
      required double unitPrice,
      required int quantity,
      required String itemImage,
      String? productName = "",
      String? cartName = "main",
      dynamic productDetailsObject,
      List<dynamic>? cartItemOptionList}) {
    CartItem cartItem = CartItem(productId: productId, vendorId: vendorId);
    cartItem.unitPrice = unitPrice;
    cartItem.productName = productName;
    cartItem.quantity = quantity;
    cartItem.itemImage = itemImage;
    cartItem.cartName = cartName;
    cartItem.productDetails = productDetailsObject;
    cartItem.cartItemOptionList = cartItemOptionList;
    return cartItem;
  }

  /// This method is called when we have to [initialize the values in our cart object]
  DbCartItemModel _setProductValuesForDb({required CartItem cartItem}) {
    DbCartItemModel cartItems = DbCartItemModel();
    try {
      cartItems.productId = cartItem.productId ?? 0;
      cartItems.vendorId = cartItem.vendorId ?? -1;
      cartItems.unitPrice = cartItem.unitPrice ?? 0.0;
      cartItems.subTotal = cartItem.subTotal ?? 0.0;
      cartItems.productName = cartItem.productName ?? "";
      cartItems.quantity = cartItem.quantity ?? 1;
      cartItems.cartItemApiId = cartItem.cartItemApiId ?? -1;
      cartItems.id = cartItem.cartItemApiId ?? -1;
      cartItems.itemImage = cartItem.itemImage ?? "";
      cartItems.cartName = cartItem.cartName ?? "";
      cartItems.cartItemOptionList = cartItem.cartItemOptionList ?? [];
      cartItems.productDetails = cartItem.productDetails ?? null;
    } catch (e) {
       //print(e.toString());
    }
    return cartItems;
  }

  /// This method is called when we have to update the [product details in  our cart]
  CartItem _updateProductDetails(
      {required int index,
      required CartItem cartItem,
      required int quantity,
      required double unitPrice}) {
    String mapKey = "${cartItem.vendorId!}${cartItem.cartName!}";

    ///Update Quantity
    cartItem.quantity = quantity;
    cartItem.subTotal =
        packageUtil.cartItemSubTotal(quantity: quantity, unitPrice: unitPrice);

    ///Add item in DB
    DbCartItemModel dbCartItem = _setProductValuesForDb(cartItem: cartItem);
    dbMain.dbUpdateCartItem(content: dbCartItem);

    _cartItemList[index] = cartItem;
    _vendorCartItemList[mapKey] = _cartItemList;
    return cartItem;
  }

  /// This method is called when we have to get the cart item total count
  int? getCartItemCount({bool isQuantityCount = false}) {
    int count = 0;
    if (!isQuantityCount) {
      count = _cartItemList.length;
    } else {
      for (var e in _cartItemList) {
        count += e.quantity;
      }
    }
    return count;
  }

  double getTotalAmountAfterCoupon(totalAmount) {
    totalAmount = totalAmount - _couponAmount;
    return totalAmount;
  }

  /// This method is called when we have to get the [totalAmount]
  getTotalAmount() {
    double totalAmount = 0.0;
    for (var e in _cartItemList) {
      totalAmount += e.subTotal!;
    }
    totalAmount = getTotalAmountAfterCoupon(totalAmount);
    totalAmount = dp(totalAmount, 2);
    return totalAmount;
  }

  getAppliedCouponAmount() {
    return _couponAmount;
  }

  /// This method is called when we have to get the [totalAmount] with taxt
  getTotalAmountWithTax() {
    double totalAmount = 0.0;
    for (var e in _cartItemList) {
      totalAmount += e.subTotal!;
    }
    totalAmount = getTotalAmountAfterCoupon(totalAmount);
    if (_configSetting._taxInPer! > 0 && totalAmount > 0) {
      double taxAmount = (_configSetting._taxInPer! / 100) * totalAmount;
      totalAmount = taxAmount + totalAmount;
    }
    totalAmount = dp(totalAmount, 2);

    return totalAmount;
  }

  /// This method is called when we have to get the [totalAmount] with taxt
  getTotalTaxAmount() {
    double totalAmount = 0.0;
    double taxAmount = 0.0;
    for (var e in _cartItemList) {
      totalAmount += e.subTotal!;
    }
    totalAmount = getTotalAmountAfterCoupon(totalAmount);
    if (_configSetting._taxInPer! > 0 && totalAmount > 0) {
      taxAmount = (_configSetting._taxInPer! / 100) * totalAmount;
    }
    taxAmount = dp(taxAmount, 2);
    return taxAmount;
  }

  double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  ///Db init
  init({int? vendorId = 1001, String? cartName = "main"}) async {
    await dbMain.dbInit();
    if (vendorId! <= 0) {
      vendorId = 1001;
    }
    if (cartName == null || cartName.isEmpty) {
      cartName = "main";
    }
    _getDataFromDb(vendorId: vendorId);
  }

  ///Db init
  Future<List<CartItem>> getSelectedCart(
      {int? vendorId = 1001, String? cartName = "main"}) async {
    if (vendorId! <= 0) {
      vendorId = 1001;
    }
    if (cartName == null || cartName.isEmpty) {
      cartName = "main";
    }
    _cartItemList = <CartItem>[];
    _vendorCartItemList = {};
    List<DbCartItemModel> dataList =
        await dbMain.dbInboxList(vendorId, cartName);
    if (dataList.isNotEmpty) {
      String mapKey = "$vendorId$cartName";
      for (var element in dataList) {
        CartItem cartItem =
            CartItem(productId: element.productId, vendorId: element.vendorId);
        cartItem.quantity = element.quantity;
        cartItem.productName = element.productName;
        cartItem.itemImage = element.itemImage;
        cartItem.subTotal = element.subTotal;
        cartItem.unitPrice = element.unitPrice;
        cartItem.cartName = element.cartName;
        cartItem.cartItemApiId = element.cartItemApiId;
        try {
          cartItem.productDetails = element.productDetails;
        } catch (e) {
          // print(e);
        }
        cartItem.cartItemOptionList = element.cartItemOptionList;
        _cartItemList.add(cartItem);
      }
      _vendorCartItemList[mapKey] = _cartItemList;
    }
    return _cartItemList;
  }

  _getDataFromDb({int? vendorId, String? cartName = "main"}) async {
    _cartItemList = <CartItem>[];
    _vendorCartItemList = {};
    List<DbCartItemModel> dataList =
        await dbMain.dbInboxList(vendorId!, cartName!);
    if (dataList.isNotEmpty) {
      String mapKey = "$vendorId$cartName";
      for (var element in dataList) {
        CartItem cartItem =
            CartItem(productId: element.productId, vendorId: element.vendorId);
        cartItem.quantity = element.quantity;
        cartItem.productName = element.productName;
        cartItem.itemImage = element.itemImage;
        cartItem.subTotal = element.subTotal;
        cartItem.unitPrice = element.unitPrice;
        cartItem.cartName = element.cartName;
        cartItem.cartItemApiId = element.cartItemApiId;
        try {
          cartItem.productDetails = element.productDetails;
        } catch (e) {
          // print(e);
        }
        cartItem.cartItemOptionList = element.cartItemOptionList;
        _cartItemList.add(cartItem);
      }
      _vendorCartItemList[mapKey] = _cartItemList;
    }
  }

  final String _successMessage = "Item added to cart successfully.";
  final String _updateMessage = "Item updated successfully.";
  final String _noItemFoundMessage = "Item not found in the cart.";
  final String _noItemQuantityMessage = "Item quantity can't less 0.";
  final String _validProductIdMessage = "Please enter valid product id";
  final String _validVendorIdMessage = "Please enter valid vendor id";
}
