import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/buttons/black_button.dart';
import '../../../widgets/general/curved_dialog.dart';
import '../../../widgets/text_field/outlined_text_field.dart';

class BrandSelector extends StatelessWidget {
  const BrandSelector({Key? key}) : super(key: key);
  static ValueNotifier<String?> brandNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Consumer<BrandsProvider>(builder: (ctx, provider, child) {
        List<Brand> brands = provider.brands;
        return ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(
            child: ValueListenableBuilder<String?>(
                valueListenable: brandNotifier,
                builder: (ctx, notifierValue, child) {
                  return DropdownButton<String?>(
                    value: notifierValue,
                    hint: const Text('Select brand'),
                    items: [
                      ...brands.map((brand) {
                        return DropdownMenuItem<String?>(
                          value: brand.docId,
                          child: Text(brand.name),
                        );
                      }).toList(),
                      DropdownMenuItem<String?>(
                        value: 'New',
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text('Add new brand', style: TextStyle(fontWeight: FontWeight.w900)),
                          ],
                        ),
                      )
                    ],
                    onChanged: (newValue) {
                      if (newValue == 'New') {
                        var controller = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return CurvedDialog(
                              title: 'Add new brand',
                              content: OutlinedTextField(hint: 'Enter brand name', controller: controller),
                              button: BlackButton(title: 'Create', onPressed: () => createBrand(context, controller.text)),
                            );
                          },
                        );
                      } else {
                        brandNotifier.value = newValue!;
                      }
                    },
                  );
                }),
          ),
        );
      }),
    );
  }

  void createBrand(BuildContext context, String brandName) async {
    if (brandName != '') {
      Brand brand = Brand(name: brandName);
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
