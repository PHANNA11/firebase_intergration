import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/view/auth/firebase/firebase_data_con.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/product_model.dart';
import '../../../../widget/form_widget.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({
    super.key,
    this.pro,
  });
  ProductModel? pro;

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController descController = TextEditingController();
  File? fileImage;
  void setInitData() {
    setState(() {
      nameController.text = widget.pro!.name!;
      codeController.text = widget.pro!.code!;
      sizeController.text = widget.pro!.size!.toString();
      priceController.text = widget.pro!.price!.toString();
      imageController.text = widget.pro!.image!;
      descController.text = widget.pro!.description!;
    });
  }

  void clear() {
    setState(() {
      nameController.text = codeController.text = sizeController.text =
          priceController.text =
              imageController.text = descController.text = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.pro == null) {
      clear();
    } else {
      setInitData();
    }
    // downloadImageFirebaseStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShopWidget().buildForm(
                controller: nameController,
                hintText: 'Enter Name',
                isRequired: true),
            ShopWidget()
                .buildForm(controller: codeController, hintText: 'Enter Code'),

            ShopWidget().buildForm(
                controller: sizeController,
                hintText: 'Enter Size',
                keyboardType: TextInputType.number),
            ShopWidget().buildForm(
                controller: priceController,
                hintText: 'Enter Price',
                keyboardType: TextInputType.number),
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            openCameraAndGallary(
                                imageSource: ImageSource.camera);
                          },
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                        ),
                        ListTile(
                          onTap: () async {
                            openCameraAndGallary(
                                imageSource: ImageSource.gallery);
                          },
                          leading: const Icon(Icons.image),
                          title: const Text('Gallay'),
                        )
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    image: fileImage == null
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(fileImage!.path)))),
                child: fileImage == null
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)),
                          child: const Center(
                            child: Icon(
                              Icons.image_rounded,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            ShopWidget().buildForm(
                controller: imageController,
                hintText: 'Enter Image Link',
                isRequired: true),

            ShopWidget().buildForm(
                controller: descController, hintText: 'Detail product'),
            if (imageController.text.isNotEmpty)
              Image(
                  height: 200,
                  width: double.infinity,
                  image: NetworkImage(imageController.text))
            //  ShopWidget().buildForm(controller: nameController),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            widget.pro == null
                ? await CloudFireStoreController()
                    .addProduct(
                        pro: ProductModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text,
                            code: codeController.text,
                            size: double.parse(sizeController.text),
                            price: double.parse(priceController.text),
                            image: imageController.text,
                            description: descController.text,
                            backgroundColor: '#CBD7CE',
                            favorite: false,
                            qty: 0,
                            varriants: ['#008000', '#6F7D6F', '#CBD7CE']))
                    .whenComplete(() {
                    Navigator.pop(context);
                  })
                : await CloudFireStoreController()
                    .updateProduct(
                        pro: ProductModel(
                            referenceId: widget.pro!.referenceId,
                            id: widget.pro!.id.toString(),
                            name: nameController.text,
                            code: codeController.text,
                            size: double.parse(sizeController.text),
                            price: double.parse(priceController.text),
                            image: imageController.text,
                            description: descController.text,
                            backgroundColor: '#CBDCE',
                            favorite: false,
                            qty: 0,
                            varriants: ['#008000', '#6F7D6F', '#CBD7CE']))
                    .whenComplete(() {
                    Navigator.pop(context);
                  });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent),
            child: const Center(
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }

  void openCameraAndGallary({ImageSource? imageSource}) async {
    var image = await ImagePicker()
        .pickImage(source: imageSource ?? ImageSource.gallery);
    setState(() {
      fileImage = File(image!.path);
    });
    uplaodImage();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  final storageRef = FirebaseStorage.instance.ref();
  void downloadImageFirebaseStorage() async {
    await storageRef
        .child("/images/products")
        .child("/1720328365328657.png")
        .getDownloadURL()
        .then((value) {
      setState(() {
        imageController.text = value;
      });
    });
  }

  void uplaodImage() async {
    var imagePath = storageRef
        .child("/images/products")
        .child('${DateTime.now().microsecondsSinceEpoch}.png');
    try {
      await imagePath.putFile(File(fileImage!.path));
      await imagePath.getDownloadURL().then((value) {
        setState(() {
          imageController.text = value;
        });
      });
    } on FirebaseException catch (e) {
      // ...
    }
  }
}
