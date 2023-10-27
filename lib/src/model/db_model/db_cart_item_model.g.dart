part of 'db_cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbCartItemModelAdapter extends TypeAdapter<DbCartItemModel> {
  @override
  final int typeId = 0;

  @override
  DbCartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DbCartItemModel()
      ..id = fields[0] as int
      ..cartItemApiId = fields[1] as int
      ..productId = fields[2] as int
      ..vendorId = fields[3] as int
      ..productName = fields[4] as String
      ..itemImage = fields[5] as String
      ..unitPrice = fields[6] as double
      ..subTotal = fields[7] as double
      ..quantity = fields[8] as int
      ..productDetails = fields[9] as dynamic
      ..cartItemOptionList = (fields[10] as List).cast<dynamic>()
      ..cartName = fields[11] as String;
  }

  @override
  void write(BinaryWriter writer, DbCartItemModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cartItemApiId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.vendorId)
      ..writeByte(4)
      ..write(obj.productName)
      ..writeByte(5)
      ..write(obj.itemImage)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.subTotal)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.productDetails)
      ..writeByte(10)
      ..write(obj.cartItemOptionList)
      ..writeByte(11)
      ..write(obj.cartName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbCartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
