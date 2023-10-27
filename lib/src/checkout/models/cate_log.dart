// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).
class CatalogModel {
  static List<String> itemNames = [
    'Bigbanana Tshirt\nMen Black Red Colourblocked Polo Collar Pure Cotton T-shirt',
    'Thomas Scott Tshirt\nMen Blue Sustainable T-shirt',
    'Thomas Scott Tshirt\nMen White Typography Applique Sustainable T-shirt',
    'Roadster Tshirt\nWomen Lavender & Navy Printed Round Neck T-shirt',
    'Nautica Tshirt\nMen Black Solid Polo Collar Pure Cotton T-shirt',
    'Roadster Tshirt\nWomen Lavender & Navy Printed Round Neck T-shirt'
  ];

  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Item getById(int id) => Item(id, itemNames[id % itemNames.length]);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final String itemImage;
  final Color color;
  final double price;
  final List<dynamic>? options;

  Item(this.id, this.name,
      {this.price = 42.0,
      this.options = const [],
      this.itemImage =
          "https://teja8.kuikr.com/i6/20220227/international-brand-s-shirts-jeans-cotton-pants-wholesale-only-VB201705171774173-ak_WBP1805334839-1645961660.png"})

      /// To make the sample app look nicer, each item is given one of the
      /// Material Design primary colors.
      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
