import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool numberKeyboard;
  final void Function(String)? onChanged;
  final int? maxLines;
  final String? suffixText;

  const OutlinedTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.numberKeyboard = false,
    this.onChanged,
    this.maxLines,
    this.suffixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: numberKeyboard ? TextInputType.number : null,
          decoration: InputDecoration(
              hintText: hint, labelText: hint, border: const OutlineInputBorder(), suffixText: suffixText),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// class DiscountTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hint;
//   final int currentPrice;
//
//   const DiscountTextField({
//     Key? key,
//     required this.hint,
//     required this.controller,
//     required this.currentPrice,
//   }) : super(key: key);
//
//   @override
//   State<DiscountTextField> createState() => _DiscountTextFieldState();
// }
//
// class _DiscountTextFieldState extends State<DiscountTextField> {
//   int price = 0;
//
//   @override
//   void initState() {
//     int? discount = int.tryParse(widget.controller.text);
//     if (discount != null) {
//       int discountPrice = widget.currentPrice * discount ~/ 100;
//       setState(() {
//         price = widget.currentPrice - discountPrice;
//       });
//     } else {
//       price = widget.currentPrice;
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: TextField(
//         controller: widget.controller,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//             hintText: widget.hint, border: const OutlineInputBorder(), suffixText: 'Current price $price'),
//         onChanged: (text) {
//           int? discount = int.tryParse(text);
//           if (discount != null) {
//             int discountPrice = widget.currentPrice * discount ~/ 100;
//             setState(() {
//               price = widget.currentPrice - discountPrice;
//             });
//           }
//         },
//       ),
//     );
//   }
// }
