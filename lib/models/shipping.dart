class shipping {
  int? id;
  var  cost;
  int? coins;
  int? status;
  String? createdAt;
  String? updatedAt;

  shipping(
      {this.id,
        this.cost,
        this.coins,
        this.status,
        this.createdAt,
        this.updatedAt});

  shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    coins = json['coins'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['coins'] = this.coins;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}