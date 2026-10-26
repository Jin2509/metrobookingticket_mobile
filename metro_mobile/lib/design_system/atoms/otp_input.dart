import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mobile/design_system/atoms/otp_cell.dart';

/// Nhập OTP 6 số (A3). Một `TextField` ẩn nằm dưới các ô nên tự nhảy ô,
/// dán nhanh và xóa lùi hoạt động tự nhiên. `hasError` làm ô rung.
class OtpInput extends StatefulWidget {
  const OtpInput({
    this.length = 6,
    this.controller,
    this.hasError = false,
    this.autofocus = false,
    this.onChanged,
    this.onCompleted,
    super.key,
  });

  final int length;
  final TextEditingController? controller;
  final bool hasError;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl =
      widget.controller ?? TextEditingController();
  final _focus = FocusNode();
  late final _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(OtpInput old) {
    super.didUpdateWidget(old);
    if (widget.hasError && !old.hasError) _shake.forward(from: 0);
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    _focus.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final code = _ctrl.text;
    return AnimatedBuilder(
      animation: _shake,
      builder: (_, child) {
        final t = _shake.value;
        final dx = math.sin(t * math.pi * 6) * 8 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.length; i++)
                OtpCell(
                  digit: i < code.length ? code[i] : '',
                  focused:
                      _focus.hasFocus &&
                      i == math.min(code.length, widget.length - 1),
                  hasError: widget.hasError,
                ),
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                showCursor: false,
                decoration: const InputDecoration.collapsed(hintText: null),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: _onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
