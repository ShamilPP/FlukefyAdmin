import 'package:flukefy_admin/utils/enums/status.dart';
import 'package:flukefy_admin/view/screens/add_product/add_product_screen.dart';
import 'package:flukefy_admin/view/screens/home/widgets/product_tile.dart';
import 'package:flukefy_admin/view/screens/orders/orders_screen.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flukefy_admin/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/product.dart';
import '../brands/brands_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
          title: 'Flukefy - Admin',
          backButton: false,
          trailing: PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return {'Orders', 'Brands'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (selected) async {
              switch (selected) {
                case 'Orders':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  break;
                case 'Brands':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BrandsScreen()));
                  break;
              }
            },
          )),
      body: Consumer<ProductsProvider>(
        builder: (ctx, provider, child) {
          List<Product> products = provider.products;
          if (provider.productsStatus == Status.success) {
            return body(products);
          } else if (provider.productsStatus == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.productsStatus == Status.failed) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
      ),
    );
  }

  Widget body(List<Product> products) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (buildContext, index) => const Divider(height: 13, thickness: 1),
      itemBuilder: (buildContext, index) {
        return ProductTile(product: products[index]);
      },
    );
  }
}
