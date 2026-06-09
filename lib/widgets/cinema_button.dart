import 'package:flutter/material.dart';

class CinemaButton extends StatefulWidget {
  const CinemaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expanded;

  @override
  State<CinemaButton> createState() => _CinemaButtonState();
}

class _CinemaButtonState extends State<CinemaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final button = GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 160),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
            gradient: enabled
                ? const LinearGradient(colors: [Color(0xFFE5383B), Color(0xFFFF6B35)])
                : const LinearGradient(colors: [Color(0xFF343438), Color(0xFF2A2A2E)]),
          ),
          child: widget.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
        ),
      ),
    );

    return widget.expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
