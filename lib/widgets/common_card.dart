import 'package:flutter/material.dart';

enum CardType {
  plain,
  filled,
}

class CommonCard extends StatelessWidget {
  final CardType type;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const CommonCard({
    super.key,
    this.type = CardType.plain,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultPadding = padding ?? const EdgeInsets.all(16);
    final defaultMargin = margin ?? const EdgeInsets.all(12);

    return Container(
      margin: defaultMargin,
      child: Card(
        elevation: type == CardType.filled ? 1 : 0,
        color: type == CardType.filled
            ? colorScheme.surfaceContainerHighest
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: type == CardType.plain
              ? BorderSide(color: colorScheme.outline)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: defaultPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
