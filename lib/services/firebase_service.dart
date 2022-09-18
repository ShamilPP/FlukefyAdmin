import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukefy_admin/model/brand_model.dart';

import '../model/product_model.dart';

class FirebaseService {
  static Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];

    var collection = FirebaseFirestore.instance.collection('products');
    var allDocs = await collection.get();
    for (var product in allDocs.docs) {
      products.add(ProductModel(
        docId: product.id,
        name: product.get('name'),
        images: List<String>.from(product.get('images')),
        description: product.get('description'),
        category: product.get('category'),
        rating: product.get('rating'),
        price: product.get('price'),
        discount: product.get('discount'),
      ));
    }

    return products;
  }

  static Future<bool> uploadProduct(ProductModel product) async {
    List<String> imagesUrl = [];
    // Images Upload
    for (int i = 0; i < product.images.length; i++) {
      String imageExtension = product.images[i].substring(product.images[i].lastIndexOf("."));
      String imageName = 'IMG ${DateTime.now().millisecondsSinceEpoch}' + imageExtension;
      imagesUrl.add(await uploadImage(product.images[i], imageName));
    }

    var products = FirebaseFirestore.instance.collection('products');

    products.add({
      'images': imagesUrl,
      'name': product.name,
      'description': product.description,
      'category': product.category,
      'rating': product.rating,
      'price': product.price,
      'discount': product.discount,
    });

    return true;
  }

  static Future<String> uploadImage(String imagePath, String fileName) async {
    final firebaseStorage = FirebaseStorage.instance;

    var file = File(imagePath);

    var snapshot = await firebaseStorage.ref().child('product/images/$fileName').putFile(file);

    return snapshot.ref.getDownloadURL();
  }

  static Future<bool> removeProduct(ProductModel product) async {
    for (int i = 0; i < product.images.length; i++) {
      await FirebaseStorage.instance.refFromURL(product.images[i]).delete();
    }
    var products = FirebaseFirestore.instance.collection('products');
    await products.doc(product.docId).delete();
    return true;
  }

  static Future<bool> updateProduct(ProductModel product) async {
    var products = FirebaseFirestore.instance.collection('products');
    await products.doc(product.docId).update({
      'name': product.name,
      'description': product.description,
      'category': product.category,
      'rating': product.rating,
      'price': product.price,
      'discount': product.discount,
    });
    return true;
  }

  static Future<bool> createCategory(BrandModel brand) async {
    var category = FirebaseFirestore.instance.collection('category');
    await category.add({
      'name': brand.name,
    });
    return true;
  }

  static Future<List<BrandModel>> getAllCategory() async {
    List<BrandModel> categorys = [];

    var collection = FirebaseFirestore.instance.collection('category');
    var allDocs = await collection.get();
    for (var category in allDocs.docs) {
      categorys.add(BrandModel(
        docId: category.id,
        name: category.get('name'),
      ));
    }

    return categorys;
  }

  static Future<bool> removeCategory(BrandModel brand) async {
    var categorys = FirebaseFirestore.instance.collection('category');
    await categorys.doc(brand.docId).delete();
    return true;
  }
}
