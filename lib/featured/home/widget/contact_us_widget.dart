import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import 'about_section_widget.dart';

class ContactSectionWidget extends StatelessWidget {
  const ContactSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    final pvm = Provider.of<AppSettingViewModel>(context);
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
              _MobileBody(vm: vm, pvm: pvm,)
            else
              _DesktopBody(vm: vm, pvm: pvm,),
          ],
        ),
      );
    });
  }
}

// ── Desktop: side-by-side, equal height ──────────────────

class _DesktopBody extends StatelessWidget {
  final HomeViewModel vm;
  final AppSettingViewModel pvm;
  const _DesktopBody({required this.vm, required this.pvm});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ important
      children: [
        Expanded(child: _ContactInfoCard(vm: vm)),
        const SizedBox(width: 24),
        Expanded(child: _WhatsAppCard(vm: vm, pvm: pvm,)),
      ],
    );
  }
}// ── Mobile: stacked ───────────────────────────────────────

class _MobileBody extends StatelessWidget {
  final HomeViewModel vm;
  final AppSettingViewModel pvm;
  const _MobileBody({required this.vm, required this.pvm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactInfoCard(vm: vm),
        const SizedBox(height: 20),
        _WhatsAppCard(vm: vm, pvm: pvm, ),
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
    return Consumer2<HomeViewModel, AppSettingViewModel>(
      builder: (context, vm, pvm,  child) {
        /// API List
        final supportList = pvm.appDetails.data?.customerSupport ?? [];

        String phone = '+91 99999 99999';
        String email = 'support@poojify.in';

        for (var item in supportList) {
          final type = item.type?.toLowerCase();

          if (type == 'phone') {
            phone = item.value ?? phone;
          } else if (type == 'email') {
            email = item.value ?? email;
          }
        }

        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFEDD5B0).withOpacity(0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
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
                      child: Text(
                        '📞',
                        style: TextStyle(fontSize: 20),
                      ),
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

              /// Dynamic Phone
              _CTile(
                icon: Icons.phone_rounded,
                label: 'Call Us',
                value: phone,
                onTap: () => _launchPhone(phone),
              ),

              const SizedBox(height: 12),

              /// Dynamic Email
              _CTile(
                icon: Icons.email_rounded,
                label: 'Email Us',
                value: email,
                onTap: () => _launchEmail(email),
              ),

              const SizedBox(height: 12),

              /// Static Address
              _CTile(
                icon: Icons.location_on_rounded,
                label: 'Location',
                value: 'Lucknow, Uttar Pradesh',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              /// Static Time
              _CTile(
                icon: Icons.access_time_rounded,
                label: 'Working Hours',
                value: 'Mon–Sun: 7:00 AM – 9:00 PM',
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _launchEmail(String email) async {
    final uri = Uri.parse("mailto:$email");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }


}// ── Contact tile ──────────────────────────────────────────

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
  final AppSettingViewModel pvm;
  const _WhatsAppCard({required this.vm, required this.pvm});

  @override
  State<_WhatsAppCard> createState() => _WhatsAppCardState();
}

class _WhatsAppCardState extends State<_WhatsAppCard> {
  bool _btnHovered = false;

  @override
  Widget build(BuildContext context) {
    final supportList =
        widget.pvm.appDetails.data?.customerSupport ?? [];

    String whatsapp = '';

    for (var item in supportList) {
      final type = item.type?.toLowerCase();

      if (type == 'whatsapp') {
        whatsapp = item.value ?? '';
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF054D44),
            Color(0xFF128C7E),
            Color(0xFF25D366)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💬',
              style: TextStyle(fontSize: 50),
            ),

            const SizedBox(height: 20),

            Text(
              'WhatsApp pe Order\nKarein Abhi!',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Seedha message karein aur\nTurant response payein.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 28),

            MouseRegion(
              onEnter: (_) => setState(() => _btnHovered = true),
              onExit: (_) => setState(() => _btnHovered = false),
              child: GestureDetector(
                onTap: () => _launchWhatsApp(whatsapp),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'WhatsApp Now',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF054D44),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchWhatsApp(String number) async {
    final uri = Uri.parse("https://wa.me/$number");

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
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