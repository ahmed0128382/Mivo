
import 'package:ahlachat/models/ShopModel.dart';

class Salesmodel {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Sales>? sales;

  Salesmodel(
      {this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.sales});

  Salesmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((v) {
        sales!.add(new Sales.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sales != null) {
      data['sales'] = this.sales!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sales {
  int? id;
  int? itemId;
  int? userId;
  int? status;
  int? day;
  int? price;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  Items? item;

  Sales(
      {this.id,
        this.itemId,
        this.userId,
        this.status,
        this.day,
        this.price,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.item});

  Sales.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    userId = json['user_id'];
    status = json['status'];
    day = json['day'];
    price = json['price'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    item = json['item'] != null ? new Items.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['day'] = this.day;
    data['price'] = this.price;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    return data;
  }
}

