import 'package:flutter/widgets.dart';

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = 960,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
