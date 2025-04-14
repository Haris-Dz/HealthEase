import 'package:flutter/material.dart';

class MasterScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const MasterScreen({
    super.key,
    required this.title,
    required this.child,
    this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: child,
    );
  }
}
