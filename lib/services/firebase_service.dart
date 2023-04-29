import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/model/user.dart';

import '../model/product.dart';
import '../model/result.dart';

class FirebaseService {
  static Future<Result<List<Product>>> getAllProducts() async {
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
          stock: product.get('stock'),
          discount: product.get('discount'),
        ));
      }
      return Result.success(products);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<List<Brand>>> getAllCategory() async {
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

      return Result.success(categorys);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<List<User>>> getAllUsers() async {
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
          createdTime: (user.get('createdTime') as Timestamp).toDate(),
          lastLoggedTime: (user.get('lastLogged') as Timestamp).toDate(),
        ));
      }

      return Result.success(users);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<Product>> createProduct(Product product) async {
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
        'stock': product.stock,
      });

      var newProduct = product;
      newProduct.docId = result.id;

      return Result.success(newProduct);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<Brand>> createCategory(Brand brand) async {
    try {
      var category = FirebaseFirestore.instance.collection('category');
      var result = await category.add({
        'name': brand.name,
        'createdTime': DateTime.now(),
      });
      var newBrand = brand;
      newBrand.docId = result.id;
      return Result.success(newBrand);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<String>> uploadImage(String imagePath, String fileName) async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(imagePath);
      var snapshot = await firebaseStorage.ref().child('product/images/$fileName').putFile(file);
      String imageUrl = await snapshot.ref.getDownloadURL();
      return Result.success(imageUrl);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<Product>> updateProduct(Product product) async {
    try {
      var products = FirebaseFirestore.instance.collection('products');
      await products.doc(product.docId).update({
        'images': product.images,
        'name': product.name,
        'description': product.description,
        'category': product.brandId,
        'rating': product.rating,
        'price': product.price,
        'discount': product.discount,
        'stock': product.stock,
      });

      return Result.success(product);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<bool>> removeProduct(Product product) async {
    try {
      for (int i = 0; i < product.images.length; i++) {
        await FirebaseStorage.instance.refFromURL(product.images[i]).delete();
      }
      var products = FirebaseFirestore.instance.collection('products');
      await products.doc(product.docId).delete();
      return Result.success(true);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<bool>> removeCategory(Brand brand) async {
    try {
      var categorys = FirebaseFirestore.instance.collection('category');
      await categorys.doc(brand.docId).delete();
      return Result.success(true);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<bool>> removeImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      return Result.success(true);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<int>> getUpdateCode() async {
    int code;
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
    } catch (e) {
      return Result.error('Error detected : $e');
    }
    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("admin")) {
      // if document exists, fetch version in firebase
      try {
        code = doc['admin'];
        return Result.success(code);
      } catch (e) {
        return Result.error('Error detected : $e');
      }
    } else {
      return Result.error('Error detected : Update code fetching problem');
    }
  }
}
