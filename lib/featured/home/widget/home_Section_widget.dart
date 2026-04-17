import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeSectionWidget extends StatefulWidget {
  const HomeSectionWidget({super.key});

  @override
  State<HomeSectionWidget> createState() => _HomeSectionWidgetState();
}

class _HomeSectionWidgetState extends State<HomeSectionWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _rotateCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 30))
      ..repeat();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _rotateAnim =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateCtrl);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFBF4A10), // deep burnt saffron
              Color(0xFFCF6010), // rich amber
              Color(0xFFD97C1A), // warm orange
              Color(0xFFE8A84A), // golden amber
              Color(0xFFE6BD8F), // soft cream
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Geometric mandala ring (top-right) ──
            Positioned(
              top: isMobile ? -80 : -100,
              right: isMobile ? -80 : -50,
              child: AnimatedBuilder(
                animation: _rotateAnim,
                builder: (_, child) =>
                    Transform.rotate(angle: _rotateAnim.value, child: child),
                child: _MandalaSvg(
                  size: isMobile ? 300 : 460,
                  opacity: 0.10,
                ),
              ),
            ),

            // ── Inner mandala ring (bottom-left) ──
            Positioned(
              bottom: -120,
              left: -80,
              child: AnimatedBuilder(
                animation: _rotateAnim,
                builder: (_, child) => Transform.rotate(
                    angle: -_rotateAnim.value * 0.6, child: child),
                child: _MandalaSvg(
                  size: isMobile ? 220 : 340,
                  opacity: 0.07,
                ),
              ),
            ),

            // ── Swastik top-right corner ──
            Positioned(
              top: isMobile ? 16 : 24,
              right: isMobile ? 16 : 32,
              child: Opacity(
                opacity: 0.13,
                child: Text(
                  '卐',
                  style: TextStyle(
                    fontSize: isMobile ? 40 : 64,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            // ── Om symbol (left, floating) ──
            Positioned(
              top: isMobile ? 60 : 80,
              left: isMobile ? 10 : 60,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, child) => Transform.translate(
                    offset: Offset(0, -_floatAnim.value * 0.6), child: child),
                child: Opacity(
                  opacity: 0.10,
                  child: Text(
                    '🕉',
                    style: TextStyle(
                      fontSize: isMobile ? 52 : 80,
                    ),
                  ),
                ),
              ),
            ),

            // ── Floating diya (bottom-right) ──
            Positioned(
              bottom: isMobile ? 30 : 50,
              right: isMobile ? 16 : 90,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, child) => Transform.translate(
                    offset: Offset(0, _floatAnim.value), child: child),
                child: const Text('🪔', style: TextStyle(fontSize: 52)),
              ),
            ),

            // ── Dot grid texture overlay ──
            Positioned.fill(
              child: CustomPaint(painter: _DotGridPainter()),
            ),

            // ── Main content ──
            FadeTransition(
              opacity: _fadeAnim,
              child: AnimatedBuilder(
                animation: _slideAnim,
                builder: (_, child) => Transform.translate(
                    offset: Offset(0, _slideAnim.value), child: child),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 22 : 72,
                    vertical: isMobile ? 56 : 88,
                  ),
                  child: isMobile
                      ? _MobileHero(
                      floatAnim: _floatAnim, pulseAnim: _pulseAnim)
                      : _DesktopHero(
                      floatAnim: _floatAnim, pulseAnim: _pulseAnim),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════
//  Layout variants
// ════════════════════════════════════════════════

class _DesktopHero extends StatelessWidget {
  final Animation<double> floatAnim;
  final Animation<double> pulseAnim;
  const _DesktopHero({required this.floatAnim, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 6, child: _HeroContent()),
        const SizedBox(width: 56),
        Expanded(
          flex: 5,
          child: AnimatedBuilder(
            animation: floatAnim,
            builder: (_, child) =>
                Transform.translate(offset: Offset(0, floatAnim.value), child: child),
            child: _PoojaCard(pulseAnim: pulseAnim),
          ),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  final Animation<double> floatAnim;
  final Animation<double> pulseAnim;
  const _MobileHero({required this.floatAnim, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: floatAnim,
          builder: (_, child) =>
              Transform.translate(offset: Offset(0, floatAnim.value), child: child),
          child: _PoojaCard(pulseAnim: pulseAnim),
        ),
        const SizedBox(height: 40),
        const _HeroContent(),
      ],
    );
  }
}

// ════════════════════════════════════════════════
//  Hero text + buttons
// ════════════════════════════════════════════════

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: Colors.white.withOpacity(0.45), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🙏', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              Text(
                'Sacred Essentials, Delivered',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Main title — ultra-crisp, no blur
        Text(
          'Puja Samagri\nAur Pandit Ji\nEk Jagah',
          style: GoogleFonts.playfairDisplay(
            fontSize: 54,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.18,
            // Only offset shadow, zero blur = pixel-perfect crispness
            shadows: const [
              Shadow(
                color: Color(0x33000000),
                offset: Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Gold accent line
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD966), Color(0xFFFFF3C0)],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD966).withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Description — crisp, well-spaced
        Text(
          'Ghar baithe mangwayein pooja ka saara saman — fresh flowers, diyas, incense, aur bahut kuch. Ya book karein ek anubhavi pandit ji apni pooja ke liye.',
          style: GoogleFonts.inter(
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.93),
            height: 1.65,
            letterSpacing: 0.15,
          ),
        ),

        const SizedBox(height: 40),

        // CTA buttons
        Wrap(
          spacing: 16,
          runSpacing: 14,
          children: [
            _PrimaryBtn(
                label: 'Order Puja Samagri',
                icon: '🛍️',
               ),
            _SecondaryBtn(
                label: 'Book Pandit Ji',
                icon: '🙏',
               ),
          ],
        ),

        const SizedBox(height: 52),
        const _StatsRow(),
      ],
    );
  }
}

// ════════════════════════════════════════════════
//  Right-side Pooja Card (replaces old illustration)
// ════════════════════════════════════════════════

class _PoojaCard extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _PoojaCard({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: Colors.white.withOpacity(0.35), width: 1.5),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.22),
        //     blurRadius: 48,
        //     offset: const Offset(0, 18),
        //   ),
        //   BoxShadow(
        //     color: const Color(0xFFFFD966).withOpacity(0.08),
        //     blurRadius: 24,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header strip with diya glow
            _CardHeader(pulseAnim: pulseAnim),

            // Thin gold divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Services list
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                children: _services
                    .map((s) => _ServiceRow(service: s))
                    .toList(),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Lucknow & nearby areas',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.88),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🌸', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _CardHeader({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Column(
        children: [
          // Animated diya glow orb
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, child) => Transform.scale(
                scale: pulseAnim.value, child: child),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFE082),
                    const Color(0xFFFFB300).withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD966).withOpacity(0.55),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🪔', style: TextStyle(fontSize: 42)),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Poojify',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
              shadows: const [
                Shadow(
                    color: Color(0x22000000),
                    offset: Offset(0, 2),
                    blurRadius: 0),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Har Pooja • Har Tyohaar',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.80),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
//  Service row item
// ════════════════════════════════════════════════

class _ServiceRow extends StatelessWidget {
  final _Svc service;
  const _ServiceRow({required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          // Icon tile
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: Center(
              child: Text(service.emoji,
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              service.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ),
          // Gold check
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD966).withOpacity(0.2),
              border: Border.all(
                  color: const Color(0xFFFFD966).withOpacity(0.6),
                  width: 1.2),
            ),
            child: const Center(
              child: Icon(Icons.check,
                  size: 12, color: Color(0xFFFFE082)),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
//  Stats row
// ════════════════════════════════════════════════

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(value: '500+', label: 'Happy Families'),
        _Divider(),
        _StatItem(value: '50+', label: 'Pandit Ji'),
        _Divider(),
        _StatItem(value: '100+', label: 'Puja Items'),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withOpacity(0.25),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFFE082),
            // Sharp shadow instead of blur
            shadows: const [
              Shadow(
                color: Color(0x44000000),
                offset: Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.82),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════
//  Buttons
// ════════════════════════════════════════════════

class _PrimaryBtn extends StatefulWidget {
  final String label;
  final String icon;
  const _PrimaryBtn(
      {required this.label, required this.icon, });

  @override
  State<_PrimaryBtn> createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<_PrimaryBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(_hover ? 0.22 : 0.12),
                blurRadius: _hover ? 24 : 14,
                offset: const Offset(0, 8),
              ),
              if (_hover)
                BoxShadow(
                  color:
                  const Color(0xFFFFD966).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.icon,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFBF4A10),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryBtn extends StatefulWidget {
  final String label;
  final String icon;
  const _SecondaryBtn(
      {required this.label, required this.icon,});

  @override
  State<_SecondaryBtn> createState() => _SecondaryBtnState();
}

class _SecondaryBtnState extends State<_SecondaryBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
        decoration: BoxDecoration(
          color: _hover
              ? Colors.white.withOpacity(0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.white.withOpacity(0.9), width: 1.8),
          boxShadow: _hover
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.icon,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
//  Mandala custom painter (geometric, HD, no blur)
// ════════════════════════════════════════════════

class _MandalaSvg extends StatelessWidget {
  final double size;
  final double opacity;
  const _MandalaSvg({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(size, size),
        painter: _MandalaRingPainter(),
      ),
    );
  }
}

class _MandalaRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..isAntiAlias = true;

    final r = size.width / 2;

    // Concentric rings
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, r * i / 5.5, paint);
    }

    // 16 petal lines
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi * 2) / 16;
      canvas.drawLine(
        center,
        center + Offset(math.cos(angle) * r, math.sin(angle) * r),
        paint..strokeWidth = 0.7,
      );
    }

    // Outer petals
    final petalPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final petalCenter = center +
          Offset(math.cos(angle) * r * 0.7, math.sin(angle) * r * 0.7);
      canvas.drawCircle(petalCenter, r * 0.18, petalPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════
//  Subtle dot grid background texture
// ════════════════════════════════════════════════

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════
//  Data
// ════════════════════════════════════════════════

class _Svc {
  final String emoji, name;
  const _Svc(this.emoji, this.name);
}

const _services = [
  _Svc('🌸', 'Fresh Flowers & Malas'),
  _Svc('🪔', 'Diyas & Agarbatti'),
  _Svc('🙏', 'Pandit Ji Booking'),
  _Svc('📦', 'Same Day Delivery'),
  _Svc('🍚', 'Prasad & Naivedya'),
];