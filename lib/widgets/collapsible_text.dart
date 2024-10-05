import 'package:flutter/material.dart';

class CollapsibleText extends StatefulWidget {
  final String text;

  const CollapsibleText({super.key, required this.text});

  @override
  State<CollapsibleText> createState() => _CollapsibleTextState();
}

class _CollapsibleTextState extends State<CollapsibleText> {
  bool collapsed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: collapsed ? 3 : 1000,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              collapsed = !collapsed;
            });
          },
          child: Text(collapsed ? "Read more" : "Read less"),
        )
      ],
    );
  }
}
