import 'package:flukefy_admin/utils/colors.dart';
import 'package:flukefy_admin/view/animations/slide_animation.dart';
import 'package:flukefy_admin/view/screens/brands/widgets/brand_card.dart';
import 'package:flukefy_admin/view/widgets/buttons/black_button.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flukefy_admin/view/widgets/text_field/outlined_text_field.dart';
import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/brand.dart';
import '../../../model/result.dart';

class BrandsScreen extends StatelessWidget {
  BrandsScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CurvedAppBar(title: 'Brands'),
      body: Consumer<BrandsProvider>(
        builder: (ctx, provider, child) {
          List<Brand> brands = provider.brands;
          if (provider.status == Status.success) {
            return ListView.builder(
              itemCount: brands.length,
              itemBuilder: (buildContext, index) {
                return SlideAnimation(delay: index * 100, child: BrandCard(brand: brands[index]));
              },
            );
          } else if (provider.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.status == Status.error) {
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
          showDialog(
            context: context,
            builder: (ctx) {
              return CurvedDialog(
                title: 'Add new brand',
                content: OutlinedTextField(hint: 'Enter brand name', controller: controller),
                button: BlackButton(title: 'Create', onPressed: () => createBrand(context)),
              );
            },
          );
        },
      ),
    );
  }

  void createBrand(BuildContext context) async {
    Brand brand = Brand(name: controller.text);
    if (brand.name != '') {
      // Close Dialog
      Navigator.pop(context);
      // Show creating dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 25),
                  Text(
                    'Creating...',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          });
      await Provider.of<BrandsProvider>(context, listen: false).createBrand(context, brand);
      // Close Dialog
      Navigator.pop(context);
    } else {
      showDialog(context: context, builder: (ctx) => const CurvedDialog(title: 'Brand name is empty'));
    }
  }
}
