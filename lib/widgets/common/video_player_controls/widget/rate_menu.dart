import 'package:flutter/material.dart';

final List<double> rateOption = [2.0, 1.5, 1];

class RateMenu extends StatelessWidget {
  final double? value;
  final Function(double rate) onTap;
  const RateMenu({
    super.key,
    this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: rateOption.map((rate) {
        return ListTile(
          title: Text(
            rate.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: value == rate
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : null,
          onTap: () => onTap(rate),
        );
      }).toList(),
    );
  }
}
