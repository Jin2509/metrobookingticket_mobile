import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nút đèn flash 🔦 trên khung camera.
class TorchButton extends StatefulWidget {
  const TorchButton({required this.onToggle, super.key});

  final VoidCallback onToggle;

  @override
  State<TorchButton> createState() => _TorchButtonState();
}

class _TorchButtonState extends State<TorchButton> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _on ? Colors.white : const Color(0x66000000),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: _on ? context.l10n.torchOff : context.l10n.torchOn,
        icon: Icon(
          _on ? LucideIcons.flashlightOff : LucideIcons.flashlight,
          color: _on ? Colors.black : Colors.white,
        ),
        onPressed: () {
          setState(() => _on = !_on);
          widget.onToggle();
        },
      ),
    );
  }
}
