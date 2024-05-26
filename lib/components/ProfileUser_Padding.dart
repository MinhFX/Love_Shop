import 'package:flutter/material.dart';

class profileUserPadding extends StatelessWidget {

  final String text;
  final String mainText;
  final bool longText;

  const profileUserPadding({
    super.key,
    required this.longText,
    required this.text,
    required this.mainText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              mainText,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                overflow: longText ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}