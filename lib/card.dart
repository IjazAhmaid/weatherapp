// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temprature;
  const CardWidget({
    Key? key,
    required this.icon,
    required this.time,
    required this.temprature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temprature),
          ],
        ),
      ),
    );
  }
}
