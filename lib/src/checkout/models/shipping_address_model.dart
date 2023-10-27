class ShippingAddressModel {
  int? addressId;
  bool? isDefault;
  Address? address;
  GAddress? gAddress;
  Contact? contact;

  ShippingAddressModel(
      {this.addressId,
      this.isDefault,
      this.address,
      this.gAddress,
      this.contact});

  ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    isDefault = json['isDefault'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    gAddress =
        json['gAddress'] != null ? GAddress.fromJson(json['gAddress']) : null;
    contact =
        json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressId'] = addressId;
    data['isDefault'] = isDefault;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (gAddress != null) {
      data['gAddress'] = gAddress!.toJson();
    }
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}

class Address {
  String? fullAddress;
  int? zip;
  String? country;
  String? state;
  String? city;
  String? landMark;

  Address(
      {this.fullAddress,
      this.zip,
      this.country,
      this.state,
      this.city,
      this.landMark});

  Address.fromJson(Map<String, dynamic> json) {
    fullAddress = json['fullAddress'];
    zip = json['zip'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    landMark = json['landMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullAddress'] = fullAddress;
    data['zip'] = zip;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['landMark'] = landMark;
    return data;
  }
}

class GAddress {
  String? lat;
  String? long;

  GAddress({this.lat, this.long});

  GAddress.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class Contact {
  String? primaryNumber;
  String? secondaryNumber;

  Contact({this.primaryNumber, this.secondaryNumber});

  Contact.fromJson(Map<String, dynamic> json) {
    primaryNumber = json['primaryNumber'];
    secondaryNumber = json['secondaryNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primaryNumber'] = primaryNumber;
    data['secondaryNumber'] = secondaryNumber;
    return data;
  }
}
