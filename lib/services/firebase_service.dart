import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/model/enums/status.dart';

import '../model/product.dart';
import '../model/response.dart';

class FirebaseService {
  static Future<Response<List<Product>>> getAllProducts(List<Brand> brands) async {
    try {
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

  static Future<Response<Product>> createProduct(Product product) async {
    try {
      var products = FirebaseFirestore.instance.collection('products');
      List<String> imagesUrls = [];
      // Images Upload
      for (int i = 0; i < product.images.length; i++) {
        // Set image name
        String imageExtension = product.images[i].substring(product.images[i].lastIndexOf("."));
        String imageName = 'IMG ${DateTime.now().millisecondsSinceEpoch}' + imageExtension;

        // Upload image to firebase storage
        Response<String> imageUrl = await uploadImage(product.images[i], imageName);
        // to add image list
        if (imageUrl.data != null && imageUrl.status == Status.completed) imagesUrls.add(imageUrl.data!);
      }

      var result = await products.add({
        'images': imagesUrls,
        'name': product.name,
        'description': product.description,
        'category': product.brand!.docId,
        'rating': product.rating,
        'price': product.price,
        'discount': product.discount,
      });

      var newProduct = product;
      newProduct.docId = result.id;
      newProduct.images = imagesUrls;

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
        'name': product.name,
        'description': product.description,
        'category': product.brand!.docId,
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
