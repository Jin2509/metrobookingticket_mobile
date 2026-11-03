import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_painter.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_scene.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_train_layer.dart';

/// Sơ đồ 3D các tuyến metro. [interactive]: một ngón xoay, hai ngón phóng to và
/// dời, chạm ga gọi [onStationTap]. Bản xem trước đứng yên, không có hoạt ảnh.
class Network3dView extends StatefulWidget {
  const Network3dView({
    required this.lines,
    this.onStationTap,
    this.selectedId,
    this.visibleLineIds,
    this.interactive = true,
    this.resetTooltip,
    this.trains = const [],
    super.key,
  });

  final List<NetworkDiagramLine> lines;
  final ValueChanged<String>? onStationTap;
  final String? selectedId;
  final Set<String>? visibleLineIds;
  final bool interactive;
  final String? resetTooltip;

  /// Tàu đang chạy, vẽ ở lớp riêng để sơ đồ không phải vẽ lại theo tàu.
  final List<DiagramTrain> trains;

  @override
  State<Network3dView> createState() => _Network3dViewState();
}

class _Network3dViewState extends State<Network3dView>
    with SingleTickerProviderStateMixin {
  late Network3dScene _scene = Network3dScene.from(widget.lines);
  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..addListener(_onAnimate);
  // Bản xem trước chừa lề để nhãn ga ở mép không bị cắt.
  late var _camera = Network3dCamera(zoom: widget.interactive ? 1 : .85);
  var _from = const Network3dCamera();
  var _to = const Network3dCamera();
  double _startZoom = 1;

  @override
  void didUpdateWidget(Network3dView old) {
    super.didUpdateWidget(old);
    if (old.lines != widget.lines) _scene = Network3dScene.from(widget.lines);
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _onAnimate() => setState(() {
    _camera = Network3dCamera.lerp(
      _from,
      _to,
      Curves.easeOutCubic.transform(_animation.value),
    );
  });

  void _animateTo(Network3dCamera target) {
    _from = _camera;
    _to = target;
    _animation.forward(from: 0);
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    setState(() {
      _camera = d.pointerCount > 1
          ? _camera.copyWith(
              zoom: _startZoom * d.scale,
              pan: _camera.pan + d.focalPointDelta,
            )
          : _camera.copyWith(
              yaw: _camera.yaw - d.focalPointDelta.dx * .008,
              pitch: _camera.pitch + d.focalPointDelta.dy * .006,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final painter = Network3dPainter(
      scene: _scene,
      camera: _camera,
      selectedId: widget.selectedId,
      visibleLineIds: widget.visibleLineIds,
      showAllLabels: widget.interactive,
      onStationTap: widget.interactive ? widget.onStationTap : null,
    );
    final canvas = ClipRect(
      child: CustomPaint(painter: painter, size: Size.infinite),
    );
    if (!widget.interactive) return ExcludeSemantics(child: canvas);
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: (_) {
                _animation.stop();
                _startZoom = _camera.zoom;
              },
              onScaleUpdate: _onScaleUpdate,
              onTapUp: (d) {
                final id = painter.hitTestStation(d.localPosition, c.biggest);
                if (id != null) widget.onStationTap?.call(id);
              },
              child: canvas,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Network3dTrainLayer(
                scene: _scene,
                camera: _camera,
                trains: widget.trains,
                visibleLineIds: widget.visibleLineIds,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: IconButton.filledTonal(
              tooltip: widget.resetTooltip,
              icon: const Icon(LucideIcons.rotate3d),
              onPressed: () => _animateTo(const Network3dCamera()),
            ),
          ),
        ],
      ),
    );
  }
}
