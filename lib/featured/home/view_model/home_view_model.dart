import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum NavSection { home, pandit, aboutUs, contactUs }

class HomeViewModel extends ChangeNotifier {
  NavSection _activeSection = NavSection.home;
  bool _isMobileMenuOpen = false;

  final GlobalKey homeKey    = GlobalKey();
  final GlobalKey panditKey  = GlobalKey();
  final GlobalKey aboutKey   = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  final ScrollController scrollController = ScrollController();

  NavSection get activeSection    => _activeSection;
  bool       get isMobileMenuOpen => _isMobileMenuOpen;

  void setActiveSection(NavSection section) {
    _activeSection = section;
    _isMobileMenuOpen = false;
    notifyListeners();
    _scrollToSection(section);
  }

  void toggleMobileMenu() {
    _isMobileMenuOpen = !_isMobileMenuOpen;
    notifyListeners();
  }

  void closeMobileMenu() {
    _isMobileMenuOpen = false;
    notifyListeners();
  }

  GlobalKey _keyForSection(NavSection section) {
    switch (section) {
      case NavSection.home:     return homeKey;
      case NavSection.pandit:   return panditKey;
      case NavSection.aboutUs:  return aboutKey;
      case NavSection.contactUs:return contactKey;
    }
  }

  void _scrollToSection(NavSection section) {
    final key = _keyForSection(section);
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  // ── External launchers ──────────────────────────────


  Future<void> openWhatsAppPandit({String? date, String? pujaType}) async {
    const phone = '919999999999';
    final msg = date != null
        ? 'Namaste! I want to book a Pandit Ji for $pujaType on $date. Please confirm availability 🙏'
        : 'Namaste! I want to book a Pandit Ji. Please help me 🙏';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }



  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}