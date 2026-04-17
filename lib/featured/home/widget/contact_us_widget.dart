import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'about_section_widget.dart';

class ContactSectionWidget extends StatelessWidget {
  const ContactSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF3E8), Color(0xFFFFF8F2)],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: isMobile ? 56 : 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Section header ──────────────────────────
            const SectionHeader(
              label: 'Get In Touch',
              title: 'Hamse Sampark Karein',
              subtitle: 'Koi bhi sawaal ho, hum yahan hain aapke liye 🙏',
            ),
            SizedBox(height: isMobile ? 40 : 56),

            // ── Body ────────────────────────────────────
            if (isMobile)
              _MobileBody(vm: vm)
            else
              _DesktopBody(vm: vm),
          ],
        ),
      );
    });
  }
}

// ── Desktop: side-by-side, equal height ──────────────────

class _DesktopBody extends StatelessWidget {
  final HomeViewModel vm;
  const _DesktopBody({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ important
      children: [
        Expanded(child: _ContactInfoCard(vm: vm)),
        const SizedBox(width: 24),
        Expanded(child: _WhatsAppCard(vm: vm)),
      ],
    );
  }
}// ── Mobile: stacked ───────────────────────────────────────

class _MobileBody extends StatelessWidget {
  final HomeViewModel vm;
  const _MobileBody({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactInfoCard(vm: vm),
        const SizedBox(height: 20),
        _WhatsAppCard(vm: vm),
      ],
    );
  }
}

// ── Contact info card ─────────────────────────────────────

class _ContactInfoCard extends StatelessWidget {
  final HomeViewModel vm;
  const _ContactInfoCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDD5B0).withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ VERY IMPORTANT
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B1530), Color(0xFFCC5500)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('📞', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Details',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Hum yahan hain aapke liye',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            width: 48,
            height: 3,
            margin: const EdgeInsets.only(left: 56),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B1530), Color(0xFFCC5500)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // ── Tiles ──
          _CTile(
            icon: Icons.phone_rounded,
            label: 'Call Us',
            value: '+91 99999 99999',
            onTap: vm.launchPhone,
          ),
          const SizedBox(height: 12),

          _CTile(
            icon: Icons.email_rounded,
            label: 'Email Us',
            value: 'support@poojify.in',
            onTap: vm.launchEmail,
          ),
          const SizedBox(height: 12),

          _CTile(
            icon: Icons.location_on_rounded,
            label: 'Location',
            value: 'Lucknow, Uttar Pradesh',
            onTap: () {},
          ),
          const SizedBox(height: 12),

          _CTile(
            icon: Icons.access_time_rounded,
            label: 'Working Hours',
            value: 'Mon–Sun: 7:00 AM – 9:00 PM',
            onTap: () {},
          ),

          const SizedBox(height: 12), // ✅ Spacer removed

        ],
      ),
    );
  }
}
// ── Contact tile ──────────────────────────────────────────

class _CTile extends StatefulWidget {
  final IconData icon;
  final String label, value;
  final VoidCallback onTap;
  const _CTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_CTile> createState() => _CTileState();
}

class _CTileState extends State<_CTile> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _h
                ? const Color(0xFF7B1530).withOpacity(0.04)
                : const Color(0xFFFAF6F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _h
                  ? const Color(0xFF7B1530).withOpacity(0.25)
                  : const Color(0xFFEDD5B0).withOpacity(0.7),
            ),
          ),
          child: Row(
            children: [
              // Icon box
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: _h
                      ? const LinearGradient(
                      colors: [Color(0xFF7B1530), Color(0xFFCC5500)])
                      : null,
                  color: _h ? null : const Color(0xFFFFEDD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: _h ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow indicator
              AnimatedOpacity(
                opacity: _h ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── WhatsApp card ─────────────────────────────────────────

class _WhatsAppCard extends StatefulWidget {
  final HomeViewModel vm;
  const _WhatsAppCard({required this.vm});

  @override
  State<_WhatsAppCard> createState() => _WhatsAppCardState();
}

class _WhatsAppCardState extends State<_WhatsAppCard> {
  bool _btnHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF054D44), Color(0xFF128C7E), Color(0xFF25D366)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withOpacity(0.28),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle top-right
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon bubble
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.25), width: 1.5),
                  ),
                  child: const Center(
                    child: Text('💬', style: TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 20),

                // Heading
                Text(
                  'WhatsApp pe Order\nKarein Abhi!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Seedha message karein aur\nturant response payein.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.white.withOpacity(0.82),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 0.6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'TAP TO CONNECT',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.45),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // CTA button
                MouseRegion(
                  onEnter: (_) => setState(() => _btnHovered = true),
                  onExit: (_) => setState(() => _btnHovered = false),
                  child: GestureDetector(
                    onTap: widget.vm.openWhatsApp,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _btnHovered
                            ? Colors.white
                            : Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(_btnHovered ? 0.18 : 0.10),
                            blurRadius: _btnHovered ? 18 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('📱',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Text(
                            'WhatsApp Now',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF054D44),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Trust badges row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TrustBadge(icon: '⚡', label: 'Instant Reply'),
                    const SizedBox(width: 20),
                    _TrustBadge(icon: '🔒', label: 'Secure'),
                    const SizedBox(width: 20),
                    _TrustBadge(icon: '🕐', label: '24/7'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String icon, label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}