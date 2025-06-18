import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart'; // Annahme: AppColors ist hier definiert

class CardiacScanWidget extends StatefulWidget {
  const CardiacScanWidget({super.key});

  @override
  State<CardiacScanWidget> createState() => _CardiacScanWidgetState();
}

class _CardiacScanWidgetState extends State<CardiacScanWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cardiac MRI Scan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.fullscreen, size: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 20),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Scan Visualization
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip
                    .antiAlias, // Verhindert, dass Kinder über den Rand malen
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background grid pattern
                    _buildScanBackground(),

                    // Heart visualization
                    Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _pulseAnimation,
                          _rotationAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value * 0.1,
                              child: _buildHeartVisualization(),
                            ),
                          );
                        },
                      ),
                    ),

                    // Scan lines
                    _buildScanLines(),

                    // Corner indicators
                    _buildCornerIndicators(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanBackground() {
    return Positioned.fill(child: CustomPaint(painter: ScanGridPainter()));
  }

  Widget _buildHeartVisualization() {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radialer Gradient als Hintergrund
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [
                  AppColors.primary.withAlpha(204),
                  AppColors.primary.withAlpha(102),
                  AppColors.primary.withAlpha(26),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(153),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Stack(
              children: [
                // Stilisierte Herzkammern
                Positioned(top: 20, left: 20, child: _buildHeartChamber(35)),
                Positioned(top: 20, right: 20, child: _buildHeartChamber(35)),
                Positioned(
                  bottom: 20,
                  left: 30,
                  child: _buildHeartChamber(60, 40),
                ),
              ],
            ),
          ),

          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = index * 0.3;
                // Stellt sicher, dass der Wert immer zwischen 0.0 und 1.0 bleibt
                final animationValue = (_pulseController.value + delay) % 1.0;

                return Center(
                  // Das Opacity-Widget steuert die Transparenz performant.
                  child: Opacity(
                    opacity: 1.0 - animationValue,
                    child: Container(
                      width: 120 + (animationValue * 60),
                      height: 120 + (animationValue * 60),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          // Die Farbe selbst ist jetzt konstant, kein neues Objekt pro Frame.
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // Hilfs-Widget für die stilisierten Herzkammern
  Widget _buildHeartChamber(double size, [double? height]) {
    return Container(
      width: size,
      height: height ?? size,
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(230),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }

  Widget _buildScanLines() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Horizontale Scan-Linie
                Positioned(
                  top: constraints.maxHeight * _rotationAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.info.withAlpha(204),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Vertikale Scan-Linie
                Positioned(
                  left: constraints.maxWidth * _rotationAnimation.value,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.info.withAlpha(204),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCornerIndicators() {
    return const Stack(
      children: [
        Positioned(top: 10, left: 10, child: _CornerIndicator()),
        Positioned(top: 10, right: 10, child: _CornerIndicator()),
        Positioned(bottom: 10, left: 10, child: _CornerIndicator()),
        Positioned(bottom: 10, right: 10, child: _CornerIndicator()),
      ],
    );
  }
}

class _CornerIndicator extends StatelessWidget {
  const _CornerIndicator();

  @override
  Widget build(BuildContext context) {
    // Ein einfacher Indikator, könnte auch ein CustomPainter sein
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _CornerPainter(color: AppColors.info.withAlpha(153)),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Oben-Links
    path.moveTo(0, size.height * 0.5);
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.5, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ScanGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.info.withAlpha(26)
      ..strokeWidth = 0.5;

    const double horizontalSpacing = 20.0;
    const double verticalSpacing = 20.0;

    int horizontalLines = (size.height / verticalSpacing).floor();
    int verticalLines = (size.width / horizontalSpacing).floor();

    // Vertikale Linien zeichnen
    for (int i = 1; i <= verticalLines; i++) {
      final x = i * horizontalSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontale Linien zeichnen
    for (int i = 1; i <= horizontalLines; i++) {
      final y = i * verticalSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
