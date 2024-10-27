import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/model/product_model.dart';
import 'package:firebase_app/view/auth/firebase/intergration_firebase.dart';
import 'package:firebase_app/view/auth/screen/login.dart';
import 'package:firebase_app/view/store/screen/product/detail_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeStoreScreen extends StatefulWidget {
  const HomeStoreScreen({super.key});

  @override
  State<HomeStoreScreen> createState() => _HomeStoreScreenState();
}

class _HomeStoreScreenState extends State<HomeStoreScreen> {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('Products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  await FirebaseController().logOutUser().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),
                        (route) => false);
                  });
                },
                title: const Text('Log Out'),
                trailing: const Icon(Icons.logout),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: productRef.snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasError
                ? const Center(
                    child: Icon(
                      Icons.info,
                      color: Colors.red,
                      size: 40,
                    ),
                  )
                : snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(4),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return buildProductCard(
                              pro: ProductModel.fromMap(
                                  map: snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            //  height: 5,
                            thickness: 2,
                            color: Colors.grey,
                          );
                        },
                      );
          }),
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
        //  margin: EdgeInsets.all(8),
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                maxRadius: 20,
                backgroundImage: NetworkImage(
                    'https://imgs.search.brave.com/dfwPXf5z9iiT2hGH2bFgi5wgPji80IhKqbly-nDYcBI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzQxLzM5LzA1/LzM2MF9GXzI0MTM5/MDU5M19MM2ZuRGlw/WGVsN2ozOERRS1dY/TFJ6cEdQdUdRMW1Z/RC5qcGc'),
              ),
              title: Text(pro.name!),
              subtitle: Text(DateTime.now().toString()),
              trailing: Icon(
                pro.favorite! ? Icons.favorite : Icons.favorite_border,
                color: pro.favorite! ? Colors.red : Colors.black,
              ),
            ),
            Hero(
              tag: pro.code!,
              child: Image(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(pro.image!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${pro.price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
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
                  const Icon(Icons.shopping_cart)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
