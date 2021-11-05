import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productName, category, image, weight, brand, shopName;
  final num price, comparedPrice;
  final DocumentSnapshot document;

  Product({
    this.productName,
    this.category,
    this.image,
    this.weight,
    this.brand,
    this.shopName,
    this.price,
    this.comparedPrice,
    this.document,
  });
}
