import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

// ── Shared Section Header (used across sections) ─────────

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF7B1530), Color(0xFFCC5500)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textLight),
        ),
      ],
    );
  }
}

// ── About Section ─────────────────────────────────────────

class AboutUsSectionWidget extends StatelessWidget {
  const AboutUsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Container(
        width: double.infinity,
        color: const Color(0xFFFFF8F2),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 60 : 35,
        ),
        child: Column(
          children: [
            const SectionHeader(
              label: 'Our Story',
              title: 'Poojify Ke Baare Mein',
              subtitle:
              'We bring sacred traditions to your doorstep with love and devotion.',
            ),
            SizedBox(height: isMobile ? 40 : 60),
            isMobile ? const _MobileAbout() : const _DesktopAbout(),
            SizedBox(height: isMobile ? 48 : 70),
            _ValueCards(isMobile: isMobile),
          ],
        ),
      );
    });
  }
}

class _DesktopAbout extends StatelessWidget {
  const _DesktopAbout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _AboutCard()),
        SizedBox(width: 48),
        Expanded(flex: 5, child: _AboutText()),
      ],
    );
  }
}

class _MobileAbout extends StatelessWidget {
  const _MobileAbout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AboutText(),
        SizedBox(height: 36),
        _AboutCard(),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1530), Color(0xFFBF4A10)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🕉️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 18),
          Text(
            '"Har Ghar Mein\nMandir Ka Anubhav"',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Our mission is to make every puja special,\nno matter where you are.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withOpacity(0.72),
                height: 1.7),
          ),
          const SizedBox(height: 22),
          Divider(color: Colors.white.withOpacity(0.18), thickness: 0.8),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _MiniStat(value: '2022', label: 'Founded'),
              _MiniStat(value: 'Lucknow', label: 'Based In'),
              _MiniStat(value: '24/7', label: 'Support'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Humara Safar',
            style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Container(
          width: 54,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF7B1530), Color(0xFFCC5500)]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Poojify ki shuruat ek simple soch se hui — ki ghar mein pooja karna aasan aur khaas hona chahiye. Hum chahte hain ki aap apni pooja mein mann lagaye, baaki sab hum sambhal lete hain.',
          style: GoogleFonts.poppins(
              fontSize: 14.5, color: AppColors.textMid, height: 1.8),
        ),
        const SizedBox(height: 14),
        Text(
          'Hamare experienced pandits har vidhi-vidhan ko puri nishtha se karwate hain. Aur hamari delivery team ensure karti hai ki aapka saman fresh aur samay par pahunche.',
          style: GoogleFonts.poppins(
              fontSize: 14.5, color: AppColors.textMid, height: 1.8),
        ),
        const SizedBox(height: 26),
        ..._aboutPoints.map((p) => _AboutPoint(text: p)),
      ],
    );
  }
}

class _AboutPoint extends StatelessWidget {
  final String text;
  const _AboutPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 17,
            height: 17,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Color(0xFF7B1530), Color(0xFFCC5500)]),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 11),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(text,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textMid, height: 1.6)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VALUE CARDS
// ─────────────────────────────────────────────
class _ValueCards extends StatelessWidget {
  final bool isMobile;
  const _ValueCards({required this.isMobile});

  static const _cards = [
    _VD('🌿', 'Pure & Fresh', 'Only fresh, premium-quality samagri'),
    _VD('⚡', 'Fast Delivery', 'Same-day delivery available'),
    _VD('🕉️', 'Trusted Pandits', 'Experienced & verified pandits'),
    _VD('💛', 'With Devotion', 'Every task done with love & care'),
  ];

  @override
  Widget build(BuildContext context) {
    if (!isMobile) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _cards
            .map((c) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _ValueCard(data: c),
          ),
        ))
            .toList(),
      );
    }

    // ── Mobile 2×2 grid ─────────────────────────────────────────────────────
    // FIX: LayoutBuilder gives us a FINITE width so we can derive card height.
    // This avoids IntrinsicHeight (which crashes inside ScrollView because it
    // propagates the infinite height constraint down to its children).
    return LayoutBuilder(builder: (context, constraints) {
      // half width minus the 16px gap in the middle, times a height ratio
      final cardHeight = ((constraints.maxWidth - 16) / 2) * 1.15;

      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(height: cardHeight, child: _ValueCard(data: _cards[0])),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(height: cardHeight, child: _ValueCard(data: _cards[1])),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(height: cardHeight, child: _ValueCard(data: _cards[2])),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(height: cardHeight, child: _ValueCard(data: _cards[3])),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ValueCard extends StatefulWidget {
  final _VD data;
  const _ValueCard({required this.data});

  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: _h
              ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7B1530), Color(0xFFCC5500)])
              : null,
          color: _h ? null : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _h ? Colors.transparent : AppColors.divider.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: _h
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _h ? 18 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.data.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(widget.data.title,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _h ? Colors.white : AppColors.textDark)),
            const SizedBox(height: 5),
            Flexible(
              child: Text(widget.data.subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: _h
                          ? Colors.white.withOpacity(0.78)
                          : AppColors.textLight,
                      height: 1.45)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value, label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }
}

class _VD {
  final String emoji, title, subtitle;
  const _VD(this.emoji, this.title, this.subtitle);
}

const _aboutPoints = [
  'Pooja ke liye sab kuch ek hi jagah milega',
  'Anubhavi aur trusted pandits available hain',
  'Bulk orders aur event puja bhi arrange hoti hai',
  'Transparent pricing, koi hidden charges nahi',
];