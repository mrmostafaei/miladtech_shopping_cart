part of miladtech_shopping_cart;

/// In this class set and get configuration setting
class ConfigSetting {
  ConfigSetting._internal();
  static final ConfigSetting instance = ConfigSetting._internal();

  bool _loadFromApi = false;
  bool? _isMultiVendor = true;
  double? _taxInPer = 18.0;

  ///Set value tru or false
  set setTaxInPer(double taxInPer) {
    _taxInPer = taxInPer;
  }

  /// return value tru or false
  get getTaxInPer => _taxInPer!;

  ///Set value tru or false
  set setLoadFromApi(bool loadFromApi) {
    _loadFromApi = loadFromApi;
  }

  /// return value tru or false
  get getLoadFromApi => _loadFromApi;

  ///Set value tru or false
  set setIsMultiVendor(bool isMultiVendor) {
    _isMultiVendor = isMultiVendor;
  }

  /// return value tru or false
  get getIsMultiVendor => _isMultiVendor ?? true;
}
