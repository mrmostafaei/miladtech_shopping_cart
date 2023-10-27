import 'package:miladtech_shopping_cart/src/model/db_model/db_cart_item_model.dart';
import 'package:hive/hive.dart';

abstract class DbAllAbstract {
  ///Clear all data
  Future<bool> dbInit();

  ///Clear all data
  Future<bool> dbClear();

  ///Clear all data
  Future<void> dbBoxClose(Box box);

  ///Clear selected column
  Future<bool> dbDeleteSelectedTable({required String columnName});

  ///Back up and ready data upload server
  Future<bool> dbBackUpAllData();

  ///Delete user from inbox or chat
  Future<DbCartItemModel?> dbDeleteSelectedCartItem(
      {required int cartItemId, required String cartName});

  ///Delete user from inbox or chat
  Future<bool?> dbDeleteSelectedCart(
      {required int vendorId, String cartName = 'main'});

  ///
  Future<bool> dbIsExistItem(
      {required String messageId, required String fcmUid});

  ///Add new user in inbox or chat
  dynamic dbAddCartItem({required DbCartItemModel content});

  ///Update Cart item
  Future<bool> dbUpdateCartItem({required DbCartItemModel content});

  ///Self user list from inbox
  Future<List<DbCartItemModel>> dbInboxList(int vendorId, String cartName);
}

/*
//Store all chat according user id box name will create dynamic for new user first chat
chatBox+id
example: chatBox100
* */
const String dbTableCartItem = "cartItem";
