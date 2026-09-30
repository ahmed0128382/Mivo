class PayPalPackage {
  int? id;
  int? coins;
  double? price;
  int? status;
  PayPalPackage(
      {this.id,
        this.coins,
        this.price,
        this.status,
     });

  PayPalPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coins = json['coins'];
    price = json['price'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coins'] = this.coins;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}