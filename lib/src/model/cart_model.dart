import 'dart:convert';

/// [CartItem] for managing cart data
class CartItem {
  CartItem(
      {required this.productId,
      required this.vendorId,
      this.uuid = -1,
      this.productName,
      this.itemImage = "",
      this.cartName = "main",
      this.unitPrice,
      this.subTotal = 0.0,
      this.quantity = 1,
      this.productDetails,
      this.itemCartIndex = -1,
      this.cartItemApiId = -1,
      this.uniqueCheck,
      this.cartItemOptionList = const []});

  int? uuid;
  int productId;
  int cartItemApiId;
  String? cartName = "";
  int? vendorId;
  String? productName;
  String? itemImage;
  dynamic unitPrice;
  double? subTotal;
  dynamic uniqueCheck;
  int quantity;
  dynamic productDetails;
  List<dynamic>? cartItemOptionList;
  // Item store on which index of cart so we can update or delete cart easily, initially it is -1
  int itemCartIndex;

  factory CartItem.fromJson(String str) => CartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
        uuid: json["uuid"],
        productId: json["product_id"],
        cartItemApiId: json["cart_item_api_id"],
        vendorId: json["vendor_id"],
        productName: json["product_name"],
        cartName: json.containsKey("cart_name") ? json["cart_name"] : "main",
        itemImage: json["item_image"],
        unitPrice: json["unit_price"],
        subTotal: json["sub_total"],
        uniqueCheck: json["unique_check"],
        quantity: json["quantity"] ?? 1,
        productDetails: json["product_details"],
        itemCartIndex: json["item_cart_index"] ?? -1,
        cartItemOptionList: json["cart_item_option_list"] ?? [],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "product_id": productId,
        "vendor_id": vendorId,
        "cart_item_api_id": cartItemApiId,
        "product_name": productName,
        "item_image": itemImage,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "cart_name": cartName,
        "unique_check": uniqueCheck,
        "quantity": quantity == 0 ? null : quantity,
        "item_cart_index": itemCartIndex,
        "product_details": productDetails == null ? null : productDetails!,
        "cart_item_option_list": cartItemOptionList
      };
}

/// [CartItemOption] model for managing cart options data
class CartItemOption {
  CartItemOption(
      {required this.optionsId, required this.optionPrice, this.optionDetails});

  int optionsId;
  double optionPrice;
  dynamic optionDetails;

  factory CartItemOption.fromJson(String str) =>
      CartItemOption.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItemOption.fromMap(Map<String, dynamic> json) => CartItemOption(
      optionsId: json["options_id"],
      optionPrice: json["option_price"],
      optionDetails: json["option_details"]);

  Map<String, dynamic> toMap() => {
        "options_id": optionsId,
        "option_price": optionPrice,
        "option_details": optionDetails
      };
}
