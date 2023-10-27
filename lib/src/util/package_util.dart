/// Package utility to common function
class PackageUtil {
  /// Cart item subtotal
  double cartItemSubTotal({required quantity, required unitPrice}) {
    double subTotal = 0.0;
    subTotal = double.parse((quantity * unitPrice).toStringAsFixed(2));
    return subTotal;
  }

  /// Compare to item
  bool compareOptions(
      {required List<dynamic> cartItemOptionList,
      required List<dynamic> cartItemOptionList2}) {
    if (cartItemOptionList.toString() == cartItemOptionList2.toString()) {
      return true;
    }
    return false;
  }
}

PackageUtil packageUtil = PackageUtil();
