import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../theme.dart';

class FullPageLoading extends StatefulWidget {
  final String? title;
  final String? description;
  final double iconSize;
  final Color iconColor;

  const FullPageLoading({
    super.key,
    this.title,
    this.description,
    this.iconSize = 48,
    this.iconColor = AppColors.white,
  });

  @override
  State<FullPageLoading> createState() => _FullPageLoadingState();
}

class _FullPageLoadingState extends State<FullPageLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
          turns: _controller,
          child: Icon(
            LucideIcons.loader_pinwheel,
            size: widget.iconSize,
            color: widget.iconColor,
          ),
        ),
        if (widget.title != null) ...[
          const SizedBox(height: 24),
          Text(
            widget.title!,
            style: AppTypography.pageTitle,
            textAlign: TextAlign.center,
          ),
        ],
        if (widget.description != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.description!,
            style: AppTypography.pageSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}