import 'package:flutter/cupertino.dart';
import 'package:miladtech_shopping_cart/src/model/db_model/db_cart_item_model.dart';
import 'package:miladtech_shopping_cart/src/util/package_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'db_all_abstract.dart';

/// Flutter packages pub run build_runner build --delete-conflicting-outputs
class DbMain extends DbAllAbstract {
  static bool isDbInit = false;

  static String dataBoxName = "shopping_cart_db";

  static Box? chatInBox;

  /// Provides access to the ObjectBox Store throughout the app.

  ///Init Hive db
  @override
  Future<bool> dbInit() async {
    if (!isDbInit) {
      try {
        await Hive.initFlutter(dataBoxName);
      } catch (e) {
         //print(e);
      }
      //Register Adapter
      //Hive.registerAdapter(DbUserInfoModelAdapter());

      isDbInit = true;
    }
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DbCartItemModelAdapter());
      }
    } catch (e) {
      // print(e);
    }
    try {
      chatInBox = chatInBox ?? await Hive.openBox(dbTableCartItem);
    } catch (e) {
       //print(e);
    }
    return isDbInit;
  }

  ///Clear all Db
  @override
  Future<bool> dbClear() async {
    if (!isDbInit) {
      dbInit();
    }
    try {
      chatInBox?.clear();
      // box.close();
    } catch (e) {
       //print(e.toString());
    }
    return true;
  }

  /// Delete selected item
  @override
  Future<bool> dbDeleteSelectedTable({String columnName = ""}) async {
    // TODO: implement dbColumnClear
    if (columnName.trim() != "") {
      await dbInit();
      Box box = await Hive.openBox<DbCartItemModel>(columnName);
      // Box box = await dbBox(boxName: '$columnName');
      box.clear();
      box.close();
    }
    return true;
  }

  @override
  Future<bool> dbBackUpAllData() {
    // TODO: implement dbBackUpAllData
    throw UnimplementedError();
  }

  /// Close db
  @override
  Future<void> dbBoxClose(Box box) async {
    try {
      if (box.isOpen) {
        box.close();
      }
    } catch (e) {
      // print(e);
    }
  }

  /// Add item in DB
  @override
  dynamic dbAddCartItem({required DbCartItemModel content}) async {
    // TODO: implement dbAllQuickAppUserList
    int productId = content.productId;
    if (productId > 0) {
      DbCartItemModel dBInboxModel = content;
      await dbInit();
      if (chatInBox!.isOpen) {
        /// Check cart id from API if it not than add our local id
        if (dBInboxModel.cartItemApiId > 0) {
          dBInboxModel.id = dBInboxModel.cartItemApiId;
        } else {
          dBInboxModel.id = DateTime.now().millisecondsSinceEpoch;
          dBInboxModel.cartItemApiId = dBInboxModel.id;
        }
        //await chatInBox!.put(productId, dBInboxModel);
        await chatInBox!.add(dBInboxModel);
        // box.close();
        return content;
      } else {
        /* box.close();
      dbClear();*/
      }
    }
    return null;
  }

  /// Update selected item
  @override
  Future<bool> dbUpdateCartItem({required DbCartItemModel content}) async {
    // TODO: implement dbAllQuickAppUserList
    int productId = content.productId;
    String cartName = content.cartName;
    if (productId > 0) {
      DbCartItemModel dBInboxModel = content;
      await dbInit();
      if (chatInBox!.isOpen) {
        List<DbCartItemModel> dbUserInfoModelList =
            chatInBox!.values.cast<DbCartItemModel>().toList();
        int index = dbUserInfoModelList.indexWhere((element) =>
            element.productId == productId &&
            element.cartName == cartName &&
            packageUtil.compareOptions(
                cartItemOptionList: element.cartItemOptionList,
                cartItemOptionList2: dBInboxModel.cartItemOptionList));
        await chatInBox!.putAt(index, dBInboxModel);
        // box.close();
        return true;
      } else {
        /* box.close();
      dbClear();*/
      }
    }
    return false;
  }

  /// Delete selected item
  @override
  Future<DbCartItemModel?> dbDeleteSelectedCartItem(
      {required int cartItemId, required String cartName}) async {
    /// TODO: implement dbAllQuickAppUserList
    if (cartItemId > 0) {
      await dbInit();
      if (chatInBox!.isOpen) {
        List<DbCartItemModel> dbUserInfoModelList =
            chatInBox!.values.cast<DbCartItemModel>().toList();
        int index = dbUserInfoModelList.indexWhere((element) =>
            element.cartItemApiId == cartItemId &&
            element.cartName == cartName);
        if (index >= 0) {
          await chatInBox!.deleteAt(index);
          DbCartItemModel? dbCartItemModel = dbUserInfoModelList[index];
          return dbCartItemModel;
        }
        return null;
      } else {
        return null;
        /* box.close();
      dbClear();*/
      }
    }
    return null;
  }

  /// Delete selected cart
  @override
  Future<bool> dbDeleteSelectedCart(
      {int vendorId = -1, String cartName = "main"}) async {
    /// TODO: implement dbAllQuickAppUserList
    if (vendorId > 0) {
      await dbInit();
      if (chatInBox!.isOpen) {
        Map dbUserInfoModelListN = chatInBox!.toMap();
        dbUserInfoModelListN.forEach((key, element) {
          if (element.vendorId == vendorId && element.cartName == cartName) {
            try {
              chatInBox!.delete(key);
            } catch (e) {
              // print(e);
            }
          }
        });
        dbUserInfoModelListN = chatInBox!.toMap();
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  /// Get stored data list
  @override
  Future<List<DbCartItemModel>> dbInboxList(
      int vendorId, String cartName) async {
    /// TODO: implement dbAllQuickAppUserList
    List<DbCartItemModel> dbUserInfoModelList = [];
    List<DbCartItemModel> dbUserInfoModelList1 = [];
    if (vendorId > 0 && vendorId != 1001) {
      await dbInit();
      if (chatInBox!.isOpen) {
        dbUserInfoModelList =
            chatInBox!.values.cast<DbCartItemModel>().toList();
        // box.close();
        //dbUserInfoModelList = box.get(anotherUserFcmId);
        dbUserInfoModelList1 = dbUserInfoModelList.where((e) {
          debugPrint("${e.vendorId} == ${e.cartName}");
          return e.vendorId == vendorId && e.cartName == cartName;
        }).toList();
      }
    } else {
      await dbInit();
      if (chatInBox!.isOpen) {
        dbUserInfoModelList =
            chatInBox!.values.cast<DbCartItemModel>().toList();
        if (cartName.isNotEmpty) {
          dbUserInfoModelList1 = dbUserInfoModelList.where((e) {
            debugPrint(e.cartName);
            return e.cartName == cartName;
          }).toList();
        } else {
          dbUserInfoModelList1.addAll(dbUserInfoModelList);
        }
      }
    }
    return dbUserInfoModelList1;
  }

  @override
  Future<bool> dbIsExistItem(
      {required String messageId, required String fcmUid}) {
    // TODO: implement dbIsExistItem
    throw UnimplementedError();
  }
}

final DbMain dbMain = DbMain();
