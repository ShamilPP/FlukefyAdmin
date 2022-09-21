import 'package:flukefy_admin/model/product_model.dart';
import 'package:flutter/material.dart';

class MoreDetails extends StatelessWidget {
  final ProductModel product;

  const MoreDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.all(borderRadius: BorderRadius.circular(2)),
      children: [
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Brand", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(product.brand == null ? 'No Brand' : product.brand!.name,
                  style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Description", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(product.description, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }
}
