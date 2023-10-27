/// This is main entering dart file to access flutter shopping cart
library miladtech_shopping_cart;

///Importing add flutter packages
import 'dart:convert';
import 'dart:math';

///Importing add flutter packages
import 'package:miladtech_shopping_cart/miladtech_shopping_cart.dart';
import 'package:miladtech_shopping_cart/src/checkout/models/apply_coupon_model.dart';
import 'package:miladtech_shopping_cart/src/checkout/models/cate_log.dart';
import 'package:miladtech_shopping_cart/src/db/db_main.dart';
import 'package:miladtech_shopping_cart/src/model/db_model/db_cart_item_model.dart';
import 'package:miladtech_shopping_cart/src/util/package_util.dart';

///Exporting all required files
export 'package:flutter/material.dart';

///Exporting all required files
export 'src/checkout/models/shipping_address_model.dart';
export 'src/model/cart_model.dart';
export 'src/model/cart_response_wrapper.dart';
export 'src/model/response_wrapper.dart';

/// Add part of lib files
part 'src/checkout/providers/provider_shopping_cart.dart';

/// Add part of lib files
part 'src/config.dart';

/// Add part of lib files
part 'src/shopping_cart.dart';
