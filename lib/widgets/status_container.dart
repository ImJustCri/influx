import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';

import '../../theme.dart';

class StatusContainer extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const StatusContainer({
    super.key,
    this.icon = LucideIcons.loader_pinwheel,
    this.title = "Caricamento...",
    this.description = "Nel frattempo che aspetti, caffè?",
    this.iconSize = 32,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  State<StatusContainer> createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _shouldRotate => widget.icon == LucideIcons.loader_pinwheel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (_shouldRotate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant StatusContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldRotate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!_shouldRotate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      widget.icon,
      size: widget.iconSize,
      color: widget.iconColor,
    );

    if (_shouldRotate) {
      iconWidget = RotationTransition(
        turns: _controller,
        child: iconWidget,
      );
    }

    return AppContainer(
      padding: const EdgeInsets.all(48),
      width: double.infinity,
      color: widget.backgroundColor,
      child: Column(
        children: [
          iconWidget,
          const SizedBox(height: 24),
          Text(
            widget.title,
            style: AppTypography.containerTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: AppTypography.containerBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}