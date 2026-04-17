import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/generated/assets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class PoojifyNavbar extends StatefulWidget {
  const PoojifyNavbar({super.key});

  @override
  State<PoojifyNavbar> createState() => _PoojifyNavbarState();
}

class _PoojifyNavbarState extends State<PoojifyNavbar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<HomeViewModel>();
      vm.scrollController.addListener(() {
        final s = vm.scrollController.offset > 10;
        if (s != _scrolled) setState(() => _scrolled = s);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 780;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: _scrolled ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color:    Color(0xFFE87722), // burnt saffron,
          boxShadow: _scrolled
              ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 3))]
              : [],
        ),
        child: isMobile
            ? _MobileNavbar(vm: vm)
            : _DesktopNavbar(vm: vm),
      );
    });
  }
}

// ── Desktop ──────────────────────────────────────────────

class _DesktopNavbar extends StatelessWidget {
  final HomeViewModel vm;
  const _DesktopNavbar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavLogo(),
        const Spacer(),
        _NavLink(label: 'Home',    section: NavSection.home,      vm: vm),
        _NavLink(label: 'Pandit',  section: NavSection.pandit,    vm: vm),
        _NavLink(label: 'About',   section: NavSection.aboutUs,   vm: vm),
        _NavLink(label: 'Contact', section: NavSection.contactUs, vm: vm),
        const SizedBox(width: 20),
        const _PlayStoreButton(),
      ],
    );
  }
}

// ── Mobile ───────────────────────────────────────────────

class _MobileNavbar extends StatelessWidget {
  final HomeViewModel vm;
  const _MobileNavbar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _NavLogo(),
            const Spacer(),
            const _PlayStoreButton(compact: true),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: vm.toggleMobileMenu,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  vm.isMobileMenuOpen ? Icons.close : Icons.menu,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: vm.isMobileMenuOpen
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Divider(color: Colors.white24, thickness: 0.5),
              const SizedBox(height: 6),
              _NavLink(label: 'Home',    section: NavSection.home,      vm: vm, mobile: true),
              _NavLink(label: 'Pandit',  section: NavSection.pandit,    vm: vm, mobile: true),
              _NavLink(label: 'About',   section: NavSection.aboutUs,   vm: vm, mobile: true),
              _NavLink(label: 'Contact', section: NavSection.contactUs, vm: vm, mobile: true),
              const SizedBox(height: 8),
            ],
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Logo ─────────────────────────────────────────────────

class _NavLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Text('🪔', style: TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Image.asset(Assets.imagesLogo, height: 80,),
      ],
    );
  }
}

// ── Nav Link ─────────────────────────────────────────────

class _NavLink extends StatefulWidget {
  final String label;
  final NavSection section;
  final HomeViewModel vm;
  final bool mobile;

  const _NavLink({
    required this.label,
    required this.section,
    required this.vm,
    this.mobile = false,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.vm.activeSection == widget.section;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.vm.setActiveSection(widget.section),
        child: widget.mobile
            ? Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Text(
            widget.label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? AppColors.goldLight : Colors.white,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active
                      ? AppColors.goldLight
                      : (_hovered ? Colors.white : Colors.white),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: (active || _hovered) ? 18 : 0,
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Play Store Button ────────────────────────────────────

class _PlayStoreButton extends StatefulWidget {
  final bool compact;
  const _PlayStoreButton({this.compact = false});

  @override
  State<_PlayStoreButton> createState() => _PlayStoreButtonState();
}

class _PlayStoreButtonState extends State<_PlayStoreButton> {
  bool _hovered = false;

  Future<void> _open() async {
    // ← Replace with your real Play Store package name
    final uri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.poojify.app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 11 : 15,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.goldLight : const Color(0xFFFFBF47),
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(0.35),
                blurRadius: _hovered ? 14 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple play-triangle using unicode — no icon dependency issue
              const Text('▶',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2C1200),
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(
                widget.compact ? 'Play Store' : 'Get on Play Store',
                style: GoogleFonts.poppins(
                  fontSize: widget.compact ? 11.5 : 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2C1200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}