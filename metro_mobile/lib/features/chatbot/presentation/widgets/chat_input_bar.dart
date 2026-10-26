import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[Nhập câu hỏi…            ] [➤]`.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({required this.onSend, required this.enabled, super.key});

  final ValueChanged<String> onSend;
  final bool enabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (!widget.enabled || _ctrl.text.trim().isEmpty) return;
    widget.onSend(_ctrl.text);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: m.card,
        border: Border(top: BorderSide(color: m.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: MetroTextField(
                  hint: context.l10n.askHint,
                  controller: _ctrl,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                ),
              ),
              MetroIconButton(
                icon: LucideIcons.sendHorizontal,
                tooltip: context.l10n.send,
                color: context.colors.primary,
                onPressed: widget.enabled ? _send : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
