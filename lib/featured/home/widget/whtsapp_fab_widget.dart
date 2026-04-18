import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class WhatsAppFloatingButton extends StatefulWidget {
  const WhatsAppFloatingButton({super.key});

  @override
  State<WhatsAppFloatingButton> createState() => _WhatsAppFloatingButtonState();
}

class _WhatsAppFloatingButtonState extends State<WhatsAppFloatingButton>
    with TickerProviderStateMixin {
  // Ripple animation
  late AnimationController _rippleCtrl;
  late Animation<double> _ripple1;
  late Animation<double> _ripple2;

  // Bounce animation
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceY;

  // Tooltip visibility
  bool _showTooltip = false;

  // Hover
  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    // Ripple — two rings staggered
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _ripple1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleCtrl,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    _ripple2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Bounce — subtle up-down
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounceY = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );

    // Show tooltip after 2 seconds automatically
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showTooltip = true);
    });
    // Auto-hide after 5s
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _showTooltip = false);
    });
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AppSettingViewModel>();

    final supportList = vm.appDetails.data?.customerSupport ?? [];

    String phone = '';
    String email = '';
    String whatsapp = '';

    for (var item in supportList) {
      final type = item.type?.toLowerCase();

      if (type == 'phone') {
        phone = item.value ?? '';
      } else if (type == 'email') {
        email = item.value ?? '';
      } else if (type == 'whatsapp') {
        whatsapp = item.value ?? '';
      }
    }



    return Positioned(
      bottom: 28,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tooltip popup
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                    begin: const Offset(0.1, 0), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
            ),
            child: _showTooltip
                ? GestureDetector(
              key: const ValueKey('tooltip'),
              onTap: () {
              _launchWhatsApp(whatsapp);

                setState(() => _showTooltip = false);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF25D366).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // WA icon in tooltip
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF25D366),
                      ),
                      child: Center(
                        child: SvgPicture.string(
                          _whatsappSvg,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Order on WhatsApp!',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF075E54),
                          ),
                        ),
                        Text(
                          'Tap to chat with us 🙏',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () =>
                          setState(() => _showTooltip = false),
                      child: const Icon(Icons.close,
                          size: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),

          // Main FAB with ripples
          AnimatedBuilder(
            animation: Listenable.merge([_rippleCtrl, _bounceCtrl]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceY.value),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple ring 1
                    _RippleRing(
                      progress: _ripple1.value,
                      baseSize: 64,
                      maxExtra: 30,
                      color: const Color(0xFF25D366),
                    ),
                    // Ripple ring 2
                    _RippleRing(
                      progress: _ripple2.value,
                      baseSize: 64,
                      maxExtra: 22,
                      color: const Color(0xFF25D366),
                    ),
                    // Main button
                    child!,
                  ],
                ),
              );
            },
            child: MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onTap: () {
                  setState(() => _showTooltip = !_showTooltip);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _hovered ? 68 : 64,
                  height: _hovered ? 68 : 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366)
                            .withOpacity(_hovered ? 0.6 : 0.4),
                        blurRadius: _hovered ? 24 : 16,
                        spreadRadius: _hovered ? 3 : 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      _whatsappSvg,
                      width: 34,
                      height: 34,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchWhatsApp(String number) async {
    final uri = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Ripple ring widget ──────────────────────────────────
class _RippleRing extends StatelessWidget {
  final double progress;
  final double baseSize;
  final double maxExtra;
  final Color color;

  const _RippleRing({
    required this.progress,
    required this.baseSize,
    required this.maxExtra,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = baseSize + maxExtra * progress;
    final opacity = (1 - progress) * 0.35;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(opacity),
          width: 2,
        ),
      ),
    );
  }
}

// ── WhatsApp SVG path ───────────────────────────────────
const String _whatsappSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z"/>
  <path d="M12 0C5.373 0 0 5.373 0 12c0 2.12.554 4.12 1.525 5.855L.057 23.215a.75.75 0 0 0 .92.92l5.36-1.468A11.94 11.94 0 0 0 12 24c6.627 0 12-5.373 12-12S18.627 0 12 0zm0 21.75a9.726 9.726 0 0 1-4.98-1.366l-.356-.213-3.702 1.014 1.014-3.702-.213-.356A9.726 9.726 0 0 1 2.25 12C2.25 6.615 6.615 2.25 12 2.25S21.75 6.615 21.75 12 17.385 21.75 12 21.75z"/>
</svg>
''';