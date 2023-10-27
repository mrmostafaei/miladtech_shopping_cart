class CouponModel {
  int? userId;
  String? couponCode;
  double? totalAmount;

  CouponModel({this.userId, this.couponCode, this.totalAmount});

  CouponModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    couponCode = json['couponCode'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['couponCode'] = couponCode;
    data['totalAmount'] = totalAmount;
    return data;
  }
}
