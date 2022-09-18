import 'package:flukefy_admin/view_model/brand_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandSelector extends StatelessWidget {
  const BrandSelector({Key? key}) : super(key: key);
  static ValueNotifier<String?> brandNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    var brandModels = Provider.of<BrandsViewModel>(context, listen: false).brands;
    List<String> brands = brandModels.map((brand) => brand.name).toList();
    if (!brands.contains(brandNotifier.value)) brandNotifier.value = null;

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
          child: ValueListenableBuilder<String?>(
              valueListenable: brandNotifier,
              builder: (ctx, value, child) {
                return DropdownButton<String>(
                  value: value,
                  hint: const Text('Select category'),
                  items: brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
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
