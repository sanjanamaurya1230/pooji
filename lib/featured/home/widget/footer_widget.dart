import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/widget/policy_page.dart';
import 'package:poojify_landing_site/generated/assets.dart';
import 'package:poojify_landing_site/helper/response/status.dart';
import 'package:poojify_landing_site/model/setting_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFE87722);
  static const gold = Color(0xFFFFBF47);
  static const white = Colors.white;
  static const white80 = Color(0xCCFFFFFF);
  static const white50 = Color(0x80FFFFFF);
  static const white20 = Color(0x33FFFFFF);
  static const white08 = Color(0x14FFFFFF);
  static const iconBg = Color(0x14FFFFFF);
}

// ─────────────────────────────────────────────
//  MAIN FOOTER WIDGET — NOW StatefulWidget
//  FIX: fetchAppDetails() is called in initState
// ─────────────────────────────────────────────
class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  @override
  void initState() {
    super.initState();
    // ✅ KEY FIX: Fetch data after first frame so context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AppSettingViewModel>();
      // Only fetch if not already loaded — avoids duplicate network calls
      if (vm.appDetails.status != Status.COMPLETED) {
        vm.fetchAppDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Text(
              '🪔',
              style: TextStyle(
                fontSize: 180,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: _C.bg),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: isMobile ? 44 : 60,
            ),
            child: Column(
              children: [
                isMobile
                    ? const _MobileFooter()
                    : const _DesktopFooter(),
                const SizedBox(height: 36),
                const Divider(color: _C.white20, thickness: 0.5),
                const SizedBox(height: 20),
                // ── Dynamic policy links from API ──
                const _DynamicPolicyLinksRow(),
                const SizedBox(height: 16),
                Text(
                  '© ${DateTime.now().year} Poojify. Made with 🙏 in Lucknow.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _C.white50,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────
//  DYNAMIC POLICY LINKS — reads from ViewModel
// ─────────────────────────────────────────────

class _DynamicPolicyLinksRow extends StatelessWidget {
  const _DynamicPolicyLinksRow();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingViewModel>(
      builder: (context, vm, _) {
        final response = vm.appDetails;

        // ✅ FIX: Show shimmer/loading dots while fetching
        if (response.status == Status.LOADING) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
                  (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          );
        }

        if (response.status == Status.ERROR) {
          return Text(
            'Could not load policies',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.4),
            ),
          );
        }

        final items = response.data?.data ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _PolicyLink(datum: items[i]),

              if (i < items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 2,
                  ),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _C.white50,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SINGLE POLICY LINK BUTTON
// ─────────────────────────────────────────────

class _PolicyLink extends StatefulWidget {
  final AppData datum;
  const _PolicyLink({required this.datum});

  @override
  State<_PolicyLink> createState() => _PolicyLinkState();
}

class _PolicyLinkState extends State<_PolicyLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                // ✅ FIX: Pass the existing ViewModel so PolicyPage
                // doesn't need to re-fetch — data is already loaded
                value: context.read<AppSettingViewModel>(),
                child: PolicyPage(initialType: widget.datum.type),
              ),
            ),
          );
        },
        child: Text(
          widget.datum.type ?? '',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: _hover ? _C.gold : _C.white50,
            decoration:
            _hover ? TextDecoration.underline : TextDecoration.none,
            decorationColor: _C.gold,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DESKTOP / MOBILE LAYOUTS
// ─────────────────────────────────────────────
class _DesktopFooter extends StatelessWidget {
  const _DesktopFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 5, child: _BrandColumn()),
        SizedBox(width: 60),
        Expanded(flex: 3, child: _LinksColumn()),
        SizedBox(width: 40),
        Expanded(flex: 4, child: _ContactColumn()),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  const _MobileFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _BrandColumn(centered: true),
        SizedBox(height: 36),
        _LinksColumn(centered: true),
        SizedBox(height: 28),
        _ContactColumn(centered: true),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BRAND COLUMN
// ─────────────────────────────────────────────
class _BrandColumn extends StatefulWidget {
  final bool centered;
  const _BrandColumn({this.centered = false});

  @override
  State<_BrandColumn> createState() => _BrandColumnState();
}

class _BrandColumnState extends State<_BrandColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final align = widget.centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign =
    widget.centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Image.asset(Assets.imagesLogo, height: 80),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Har Pooja, Har Tyohaar.\nYour trusted source for puja samagri\nand pandit bookings in Lucknow.',
          textAlign: textAlign,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _C.white80,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 22),
        _PlayStoreButton(),
        const SizedBox(height: 22),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialBtn(icon: '📸', tooltip: 'Instagram'),
            const SizedBox(width: 10),
            _SocialBtn(icon: '💬', tooltip: 'WhatsApp'),
            const SizedBox(width: 10),
            _SocialBtn(icon: '👤', tooltip: 'Facebook'),
            const SizedBox(width: 10),
            _SocialBtn(icon: '▶', tooltip: 'YouTube'),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PLAY STORE BUTTON
// ─────────────────────────────────────────────
class _PlayStoreButton extends StatefulWidget {
  @override
  State<_PlayStoreButton> createState() => _PlayStoreButtonState();
}

class _PlayStoreButtonState extends State<_PlayStoreButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.poojify.app',
          );
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: _hover
                ? _C.gold.withOpacity(0.22)
                : _C.gold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hover
                  ? _C.gold.withOpacity(0.85)
                  : _C.gold.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _C.gold,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Icon(Icons.play_arrow_rounded,
                      color: Color(0xFF7A3500), size: 18),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Download on',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: _C.gold.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    'Google Play',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _C.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SOCIAL BUTTON
// ─────────────────────────────────────────────
class _SocialBtn extends StatefulWidget {
  final String icon;
  final String tooltip;
  const _SocialBtn({required this.icon, required this.tooltip});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hover ? _C.gold.withOpacity(0.18) : _C.white08,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color:
              _hover ? _C.gold.withOpacity(0.45) : _C.white20,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              widget.icon,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  QUICK LINKS COLUMN
// ─────────────────────────────────────────────
class _LinksColumn extends StatelessWidget {
  final bool centered;
  const _LinksColumn({this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        _ColHeading('Quick Links', centered: centered),
        const SizedBox(height: 16),
        _FooterNavLink('Home', centered: centered, onTap: () {}),
        _FooterNavLink('Puja Samagri', centered: centered, onTap: () {}),
        _FooterNavLink('Pandit Booking',
            centered: centered, onTap: () {}),
        _FooterNavLink('About Us', centered: centered, onTap: () {}),
        _FooterNavLink('Contact Us', centered: centered, onTap: () {}),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CONTACT COLUMN
// ─────────────────────────────────────────────
class _ContactColumn extends StatelessWidget {
  final bool centered;
  const _ContactColumn({this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingViewModel>(
      builder: (context, vm, child) {
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

        return Column(
          crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            _ColHeading('Contact', centered: centered),
            const SizedBox(height: 16),

            if (phone.isNotEmpty)
              _ContactRow(
                icon: '📞',
                label: 'Call Us',
                value: phone,
                centered: centered,
                onTap: () => _launchPhone(phone),
              ),

            if (whatsapp.isNotEmpty)
              _ContactRow(
                icon: '💬',
                label: 'WhatsApp',
                value: _formatWhatsAppNumber(whatsapp),
                centered: centered,
                onTap: () => _launchWhatsApp(whatsapp),
              ),

            if (email.isNotEmpty)
              if (email.isNotEmpty)
                _ContactRow(
                  icon: '✉️',
                  label: 'Email',
                  value: _formatEmail(email),
                  centered: centered,
                  onTap: () => _launchEmail(email),
                ),
          ],
        );
      },
    );
  }

  static String _formatWhatsAppNumber(String value) {
    String number = value.trim();

    // remove url
    number = number.replaceAll('https://wa.me/', '');
    number = number.replaceAll('http://wa.me/', '');

    // keep + if indian code
    if (!number.startsWith('+') && number.startsWith('91')) {
      number = '+$number';
    }

    return number;
  }

  static String _formatEmail(String value) {
    return value.replaceAll('mailto:', '').trim();
  }


  static Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _launchEmail(String value) async {
    String finalUrl = value.trim();

    if (!finalUrl.startsWith('mailto:')) {
      finalUrl = "mailto:$finalUrl";
    }

    final uri = Uri.parse(finalUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _launchWhatsApp(String value) async {
    String finalUrl = value.trim();

    if (finalUrl.startsWith('http')) {
      finalUrl = finalUrl.replaceAll('+', '');
    } else {
      final number = finalUrl.replaceAll('+', '');
      finalUrl = "https://wa.me/$number";
    }

    final uri = Uri.parse(finalUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
// ─────────────────────────────────────────────
//  CONTACT ROW ITEM
// ─────────────────────────────────────────────
class _ContactRow extends StatefulWidget {
  final String icon;
  final String label;
  final String value;
  final bool centered;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.centered = false,
    this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize:
        widget.centered ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color:
              _hover ? _C.gold.withOpacity(0.18) : _C.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.icon,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: _C.white50,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: _hover ? _C.white : _C.white80,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(onTap: widget.onTap, child: content),
    );
  }
}

// ─────────────────────────────────────────────
//  COLUMN HEADING
// ─────────────────────────────────────────────
class _ColHeading extends StatelessWidget {
  final String text;
  final bool centered;
  const _ColHeading(this.text, {this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          text.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _C.gold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: 2,
          decoration: BoxDecoration(
            color: _C.gold.withOpacity(0.35),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  FOOTER NAV LINK
// ─────────────────────────────────────────────
class _FooterNavLink extends StatefulWidget {
  final String label;
  final bool centered;
  final VoidCallback onTap;
  const _FooterNavLink(this.label,
      {required this.onTap, this.centered = false});

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink>
    with SingleTickerProviderStateMixin {
  bool _hover = false;
  late final AnimationController _ctrl;
  late final Animation<double> _underline;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _underline =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hover = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hover = false);
        _ctrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: widget.centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.only(left: _hover ? 6 : 0),
                child: Text(
                  widget.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: _hover ? _C.white : _C.white80,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedBuilder(
                animation: _underline,
                builder: (_, __) => FractionallySizedBox(
                  widthFactor: _underline.value,
                  alignment: Alignment.center,
                  child: Container(
                    height: 1,
                    color: _C.gold.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}