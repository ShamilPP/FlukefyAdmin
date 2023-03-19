import 'package:flukefy_admin/model/brand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/brand_provider.dart';
import '../../../widgets/buttons/black_button.dart';
import '../../../widgets/general/curved_dialog.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(brand.name),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(child: Text('Delete')),
                  ];
                },
                onSelected: (selected) async {
                  showDialog(
                    context: context,
                    builder: (ctx) => CurvedDialog(
                      title: 'Delete ${brand.name}',
                      content: const Text('Are you sure you want to delete brand'),
                      closeButton: true,
                      button: BlackButton(
                        title: 'Delete',
                        onPressed: () => deleteBrand(context, brand),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
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
