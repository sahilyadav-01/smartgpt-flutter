import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const MarkdownMessage({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      // User messages: plain text
      return Text(
        text,
        style: const TextStyle(color: Colors.white),
      );
    }

    // AI messages: render as markdown
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.5,
        ),
        h1: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        h2: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        h3: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        strong: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        em: const TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
        ),
        code: TextStyle(
          backgroundColor: Colors.grey[900],
          color: Colors.amber[300],
          fontFamily: 'Courier',
          fontSize: 13,
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border.all(color: Colors.grey[700]!),
          borderRadius: BorderRadius.circular(8),
        ),
        codeblockPadding: const EdgeInsets.all(12),
        blockquote: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
        ),
        blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        listBullet: const TextStyle(
          color: Colors.white,
        ),
        a: TextStyle(
          color: Colors.teal[300],
          decoration: TextDecoration.underline,
        ),
      ),
      onTapLink: (text, href, title) {
        // Handle link taps (optional: open in browser)
        if (href != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link: $href')),
          );
        }
      },
    );
  }
}
