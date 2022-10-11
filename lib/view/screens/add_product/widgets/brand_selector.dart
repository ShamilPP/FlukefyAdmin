import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandSelector extends StatelessWidget {
  const BrandSelector({Key? key}) : super(key: key);
  static ValueNotifier<Brand?> brandNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    var brands = Provider.of<BrandsProvider>(context, listen: false).brands;

    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonHideUnderline(
          child: ValueListenableBuilder<Brand?>(
              valueListenable: brandNotifier,
              builder: (ctx, notifierValue, child) {
                return DropdownButton<Brand>(
                  value: notifierValue,
                  hint: const Text('Select brand'),
                  items: brands.map((brand) {
                    return DropdownMenuItem<Brand>(
                      value: brand,
                      child: Text(brand.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    brandNotifier.value = newValue;
                  },
                );
              }),
        ),
      ),
    );
  }
}
