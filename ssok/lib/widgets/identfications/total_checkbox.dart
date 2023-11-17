import 'package:flutter/material.dart';

class TotalCheckbox extends StatelessWidget {
  const TotalCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: value,
                onChanged: (bool? newValue) {
                  onChanged(newValue!);
                },
                activeColor: Color(0xFF00496F),
              ),
            ),
            Expanded(
                child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
