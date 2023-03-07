import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/model/user.dart';

import '../model/product.dart';
import '../model/response.dart';

class FirebaseService {
  static Future<Response<List<Product>>> getAllProducts() async {
    try {
      List<Product> products = [];

      var collection = FirebaseFirestore.instance.collection('products');
      var allDocs = await collection.get();
      for (var product in allDocs.docs) {
        products.add(Product(
          docId: product.id,
          name: product.get('name'),
          images: List<String>.from(product.get('images')),
          description: product.get('description'),
          brandId: product.get('category'),
          rating: product.get('rating'),
          price: product.get('price'),
          discount: product.get('discount'),
        ));
      }
      return Response.completed(products);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<List<Brand>>> getAllCategory() async {
    try {
      List<Brand> categorys = [];

      var collection = FirebaseFirestore.instance.collection('category');
      var allDocs = await collection.get();
      for (var category in allDocs.docs) {
        categorys.add(Brand(
          docId: category.id,
          name: category.get('name'),
        ));
      }

      return Response.completed(categorys);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<List<User>>> getAllUsers() async {
    try {
      List<User> users = [];

      var collection = FirebaseFirestore.instance.collection('users');
      var allDocs = await collection.get();
      for (var user in allDocs.docs) {
        users.add(User(
          docId: user.id,
          uid: user.get('uid'),
          name: user.get('name'),
          email: user.get('email'),
          phone: user.get('phone'),
        ));
      }

      return Response.completed(users);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<Product>> createProduct(Product product) async {
    try {
      var products = FirebaseFirestore.instance.collection('products');
      var result = await products.add({
        'images': product.images,
        'name': product.name,
        'description': product.description,
        'category': product.brandId,
        'rating': product.rating,
        'price': product.price,
        'discount': product.discount,
      });

      var newProduct = product;
      newProduct.docId = result.id;

      return Response.completed(newProduct);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<Brand>> createCategory(Brand brand) async {
    try {
      var category = FirebaseFirestore.instance.collection('category');
      var result = await category.add({
        'name': brand.name,
        'createdTime': DateTime.now(),
      });
      var newBrand = brand;
      newBrand.docId = result.id;
      return Response.completed(newBrand);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<String>> uploadImage(String imagePath, String fileName) async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(imagePath);
      var snapshot = await firebaseStorage.ref().child('product/images/$fileName').putFile(file);
      String imageUrl = await snapshot.ref.getDownloadURL();
      return Response.completed(imageUrl);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<Product>> updateProduct(Product product) async {
    try {
      var products = FirebaseFirestore.instance.collection('products');
      await products.doc(product.docId).update({
        'images' : product.images,
        'name': product.name,
        'description': product.description,
        'category': product.brandId,
        'rating': product.rating,
        'price': product.price,
        'discount': product.discount,
      });

      return Response.completed(product);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<bool>> removeProduct(Product product) async {
    try {
      for (int i = 0; i < product.images.length; i++) {
        await FirebaseStorage.instance.refFromURL(product.images[i]).delete();
      }
      var products = FirebaseFirestore.instance.collection('products');
      await products.doc(product.docId).delete();
      return Response.completed(true);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<bool>> removeCategory(Brand brand) async {
    try {
      var categorys = FirebaseFirestore.instance.collection('category');
      await categorys.doc(brand.docId).delete();
      return Response.completed(true);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<bool>> removeImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      return Response.completed(true);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<int>> getUpdateCode() async {
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
