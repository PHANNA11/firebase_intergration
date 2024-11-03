import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/view/auth/firebase/firebase_data_con.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../model/product_model.dart';
import '../product/detail_product.dart';
import 'add_edit_product.dart';

class HomeShop extends StatefulWidget {
  const HomeShop({super.key});

  @override
  State<HomeShop> createState() => _HomeShopState();
}

class _HomeShopState extends State<HomeShop> {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('Products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOP PROFILE'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productRef.snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasError
              ? const Center(
                  child: Icon(
                    Icons.info,
                    color: Colors.red,
                  ),
                )
              : snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return buildProductCard(
                          pro: ProductModel.fromMap(
                              map: snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>,
                              docId: snapshot.data!.docs[index].id),
                        );
                      },
                    );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditProduct(pro: null),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget buildProductCard({required ProductModel pro}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProduct(productModel: pro),
            ));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: pro.code!,
              child: Image(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                image: NetworkImage(pro.image!),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pro.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Colors:'),
                              CircleAvatar(
                                maxRadius: 8,
                                backgroundColor: HexColor(pro.backgroundColor!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${pro.price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditProduct(pro: pro),
                                ));
                          },
                          icon: Icon(
                            Icons.edit_document,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () async {
                            await CloudFireStoreController()
                                .deleteProduuct(docId: pro.referenceId!);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
