import 'package:flukefy_admin/view/widgets/buttons/black_button.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flukefy_admin/view/widgets/text_field/outlined_text_field.dart';
import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/brand.dart';
import '../../../model/response.dart';

class BrandsScreen extends StatelessWidget {
  BrandsScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(
        title: 'Brands',
      ),
      body: Consumer<BrandsProvider>(
        builder: (ctx, provider, child) {
          List<Brand> brands = provider.brands;
          if (provider.brandsStatus == Status.completed) {
            return ListView.separated(
              itemCount: brands.length,
              separatorBuilder: (buildContext, index) => const Divider(height: 13, thickness: 1),
              itemBuilder: (buildContext, index) {
                return ListTile(
                  title: Text(brands[index].name),
                  trailing: IconButton(
                    tooltip: 'Delete',
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[800],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => CurvedDialog(
                          title: 'Delete ${brands[index].name}',
                          content: const Text('Are you sure you want to delete brand'),
                          closeButton: true,
                          button: BlackButton(
                            title: 'Delete',
                            onPressed: () => deleteBrand(context, brands[index]),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (provider.brandsStatus == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.brandsStatus == Status.error) {
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

  void deleteBrand(BuildContext context, Brand brand) async {
    // Close confirmation dialog
    Navigator.pop(context);
    // Show 'deleting' dialog
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
                  'Deleting....',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        });

    await Provider.of<BrandsProvider>(context, listen: false).deleteBrand(context, brand);

    //Close Dialog
    Navigator.pop(context);
  }
}
