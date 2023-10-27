import 'package:hive/hive.dart';

part 'db_cart_item_model.g.dart';

@HiveType(typeId: 20)
class DbCartItemModel {
  DbCartItemModel();

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int cartItemApiId = -1;

  @HiveField(2)
  int productId = 0;

  @HiveField(3)
  int vendorId = -1;

  @HiveField(4)
  String productName = "";

  @HiveField(5)
  String itemImage = "";

  @HiveField(6)
  double unitPrice = 0.0;

  @HiveField(7)
  double subTotal = 0.0;

  @HiveField(8)
  int quantity = 1;

  @HiveField(9)
  dynamic productDetails = {};

  @HiveField(10)
  List<dynamic> cartItemOptionList = [];

  @HiveField(11)
  String cartName = "main";
}
