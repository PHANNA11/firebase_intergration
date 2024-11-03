import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/model/product_model.dart';

class CloudFireStoreController {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference favoriteProductRef =
      FirebaseFirestore.instance.collection('Favorites');
  Future<void> addProduct({required ProductModel pro}) async {
    await productRef.add(pro.toMap());
  }

  Future<void> updateProduct({required ProductModel pro}) async {
    await productRef.doc(pro.referenceId).set(pro.toMap());
  }

  Future<void> deleteProduuct({required String docId}) async {
    await productRef.doc(docId).delete();
  }
  // Favorite Collection

  Future<void> addFavoriteProduuct({required ProductModel pro}) async {
    pro.favorite == true
        ? await favoriteProductRef.add(pro.toMap())
        : await favoriteProductRef.doc(pro.referenceId).delete();
  }
}
