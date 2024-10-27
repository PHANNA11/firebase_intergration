import 'dart:ffi';

class ProductModel {
  int? id;
  String? name;
  String? code;
  String? image;
  String? description;
  bool? favorite;
  int? qty;
  double? size;
  double? price;
  String? backgroundColor;
  List<dynamic>? varriants;
  ProductModel({
    this.code,
    this.id,
    this.backgroundColor,
    this.name,
    this.qty,
    this.price,
    this.favorite,
    this.description,
    this.size,
    this.image,
    this.varriants,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price as double,
      'description': description,
      'favorite': favorite,
      'qty': qty,
      'size': size,
      'image': image,
      'code': code,
      'varriant_colors': varriants as List<String>,
      'background_color': backgroundColor,
    };
  }

  ProductModel.fromMap({required Map<String, dynamic> map})
      : id = map['id'] as int,
        name = map['name'] as String,
        price = double.parse(map['price'].toString()),
        code = map['code'] as String,
        qty = map['qty'] as int,
        size = double.parse(map['size'].toString()),
        image = map['image'] as String,
        backgroundColor = map['background_color'] as String,
        description = map['description'] as String,
        favorite = map['favorite'] as bool,
        varriants = map['varriant_colors'];
}
