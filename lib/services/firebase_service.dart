import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukefy_admin/model/brand.dart';

import '../model/product.dart';
import '../model/response.dart';

class FirebaseService {
  static Future<List<Product>> getAllProducts(List<Brand> brands) async {
    List<Product> products = [];

    var collection = FirebaseFirestore.instance.collection('products');
    var allDocs = await collection.get();
    for (var product in allDocs.docs) {
      // find brand
      int index = brands.indexWhere((element) => element.docId == product.get('category'));

      products.add(Product(
        docId: product.id,
        name: product.get('name'),
        images: List<String>.from(product.get('images')),
        description: product.get('description'),
        brand: index == -1 ? null : brands[index],
        rating: product.get('rating'),
        price: product.get('price'),
        discount: product.get('discount'),
      ));
    }

    return products;
  }

  static Future<bool> uploadProduct(Product product) async {
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
      'category': product.brand!.docId,
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

  static Future<bool> removeProduct(Product product) async {
    for (int i = 0; i < product.images.length; i++) {
      await FirebaseStorage.instance.refFromURL(product.images[i]).delete();
    }
    var products = FirebaseFirestore.instance.collection('products');
    await products.doc(product.docId).delete();
    return true;
  }

  static Future<bool> updateProduct(Product product) async {
    var products = FirebaseFirestore.instance.collection('products');
    await products.doc(product.docId).update({
      'name': product.name,
      'description': product.description,
      'category': product.brand!.docId,
      'rating': product.rating,
      'price': product.price,
      'discount': product.discount,
    });
    return true;
  }

  static Future<bool> createCategory(Brand brand) async {
    var category = FirebaseFirestore.instance.collection('category');
    await category.add({
      'name': brand.name,
      'createdTime': DateTime.now(),
    });
    return true;
  }

  static Future<List<Brand>> getAllCategory() async {
    List<Brand> categorys = [];

    var collection = FirebaseFirestore.instance.collection('category');
    var allDocs = await collection.get();
    for (var category in allDocs.docs) {
      categorys.add(Brand(
        docId: category.id,
        name: category.get('name'),
      ));
    }

    return categorys;
  }

  static Future<bool> removeCategory(Brand brand) async {
    var categorys = FirebaseFirestore.instance.collection('category');
    await categorys.doc(brand.docId).delete();
    return true;
  }

  static Future<Response> getUpdateCode() async {
    int code;
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
    } catch (e) {
      return Response.error('Error detected : $e');
    }
    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("code")) {
      // if document exists, fetch version in firebase
      try {
        code = doc['code'];
        return Response.completed(code);
      } catch (e) {
        return Response.error('Error detected : $e');
      }
    } else {
      return Response.error('Error detected : Update code fetching problem');
    }
  }
}
