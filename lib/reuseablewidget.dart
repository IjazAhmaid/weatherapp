import 'package:flutter/material.dart';

class ReuseableRow extends StatelessWidget {
  final String title, value;
  const ReuseableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 21),
          ),
          Text(value)
        ],
      ),
    );
  }
}
