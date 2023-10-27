# miladtech_shopping_Cart 🛒

A flutter package for make your life easy. This package is used for maintaining a cart. This package
helps you perform basic cart operations like (Add, Remove, Get total count, delete cart, & manage
single and multi-vendor).

|               | Android   | iOS    |
| :-------------| :---------| :------|
| **Support**   | SDK 21+   | 10.0+  |

#### It is recommended to use any State Management. i.e:- Provider

## miladtech_shopping_cart Usage

To use the plugin you just need to add miladtech_shopping_cart: ^1.0.0+1 into your pubspec.yaml file
and run pub get.

#### Add following into your package's pubspec.yaml (and run an implicit dart pub get):

miladtech_shopping_cart: ^1.0.0+1

## Getting started

- first init flutter shopping cart package in main method of your project.

```
     await ShoppingCart().init();
```

- first create an instance of flutter shopping cart package.

```
     var shoppingCart = ShoppingCart();
```

- After getting the instance, we are able to get the built-in methods
    - Add Items into cart
      ```
           shoppingCart.addToCart(
      {required int productId,
      required int vendorId,
      required double unitPrice,
      required String itemImage,
      String? productName,
      String? cartName = 'main',
      int quantity = 1,
      List<dynamic>? cartItemOptionList = const [],
      dynamic productDetailsObject})
      ```
    - Remove item one by one from cart ➖
      ```
          shoppingCart.decrementItemFromCart(
      {required int productId,
      required int vendorId,
      String? cartName = "main",
      List<dynamic>? cartItemOptionList = const []})
      ```
    - Add item one by one to cart ➕
      ```
          shoppingCart.addToCart(
      {required int productId,
      required int vendorId,
      required double unitPrice,
      required String itemImage,
      String? productName,
      String? cartName = 'main',
      int quantity = 1,
      List<dynamic>? cartItemOptionList = const [],
      dynamic productDetailsObject})
      ```
    - Get the total amount
      ```
          shoppingCart.getTotalAmount()
      ```
    - Get the total amount with tax
      ```
          shoppingCart.getTotalAmountWithTax()
      ```
    - Get the total quantity
      ```
          shoppingCart.getCartItemCount({bool isQuantityCount = false})
      ```
    - Get Specific Item from Cart
      ```
          shoppingCart.getSpecificItemFromCart({
  required int productId, required List<dynamic>? cartItemOptionList, int? vendorId, })
  ```
    - Get Specific Item index from Cart
      ```
          shoppingCart.findItemIndexFromCart(cartId)
      ```
    - Remove Specific Item from Cart
      ```
          shoppingCart.deleteSelectedCartItem(int cartItemId, String cartName)
      ```
    - Clean all Cart item
      ```
          shoppingCart.deleteAllCart()
      ```

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues, submit them directly in
the [Issues](https://github.com/mrmostafaei/miladtech_shopping_cart/issues) section.

## License

[this file](./LICENSE).