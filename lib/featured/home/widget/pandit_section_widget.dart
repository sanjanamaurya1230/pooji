import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

const _kSaffron = Color(0xFFBF4A10);
const _kAmber   = Color(0xFFD4720A);
const _kGold    = Color(0xFFE6BD8F);
const _kMaroon  = Color(0xFF7B1530);
const _kCream   = Color(0xFFFFF3E8);
const _kCreamer = Color(0xFFFFF8F0);

class PanditSectionWidget extends StatelessWidget {
  const PanditSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Container(
        width: double.infinity,
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 25 : 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopBadge(),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 26 : 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  height: 1.25,
                ),
                children: const [
                  TextSpan(text: 'Anubhavi aur '),
                  TextSpan(text: 'Prashikshit', style: TextStyle(color: _kSaffron)),
                  TextSpan(text: ' Pandits'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Har pooja ke liye sahi pandit — vedic vidhaan ke saath, shudh ucharan ke saath, aur poori shraddha ke saath.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 48,
              height: 3,
              decoration: BoxDecoration(
                color: _kSaffron,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),

            // Stats strip
            _StatsGrid(crossAxisCount: isMobile ? 2 : 4),
            const SizedBox(height: 40),

            // Pandit cards
            isMobile
                ? Column(
              children: _pandits
                  .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PanditCard(pandit: p),
              ))
                  .toList(),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 360, // adjust as needed
              ),
              itemCount: _pandits.length,
              itemBuilder: (_, i) => _PanditCard(pandit: _pandits[i]),
            ),
            const SizedBox(height: 40),

            // Puja types
            Text(
              'Kaunsi poojas hum cover karte hain',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _pujaTypes
                  .map((p) => _PujaChip(label: p.name, highlight: p.highlight))
                  .toList(),
            ),
            const SizedBox(height: 40),

            const _VedicStrip(),
          ],
        ),
      );
    });
  }
}

// ── Top badge ─────────────────────────────────────────────

class _TopBadge extends StatelessWidget {
  const _TopBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _kCream,
        border: Border.all(color: _kGold),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: _kSaffron),
          ),
          const SizedBox(width: 8),
          Text(
            'Hamare Pandit Ji',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _kMaroon,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats grid ────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final int crossAxisCount;
  const _StatsGrid({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 70, // ✅ instead of aspect ratio
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) => _StatBox(stat: _stats[i]),
    );
  }
}

class _StatBox extends StatelessWidget {
  final _Stat stat;
  const _StatBox({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        border: Border(left: BorderSide(color: _kSaffron, width: 3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ FIX
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20, // 👈 slightly reduced
              fontWeight: FontWeight.w700,
              color: _kSaffron,
            ),
          ),
          const SizedBox(height: 2),
          Flexible( // ✅ FIX (prevents overflow)
            child: Text(
              stat.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ── Pandit card ───────────────────────────────────────────

class _PanditCard extends StatelessWidget {
  final _Pandit pandit;
  const _PanditCard({required this.pandit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: _kSaffron.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top gradient strip
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_kMaroon, _kSaffron, _kAmber]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D6),
                    shape: BoxShape.circle,
                    border: Border.all(color: _kGold, width: 1.5),
                  ),
                  child: Center(
                    child: Text(pandit.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  pandit.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pandit.title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _kSaffron,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    _StarRow(rating: pandit.rating),
                    const SizedBox(width: 6),
                    Text(
                      '${pandit.rating}',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMid),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${pandit.pujaCount} poojas)',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  pandit.experience,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Speciality tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: pandit.specialities
                      .map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _kCream,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _kGold),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _kMaroon,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Languages
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Bolte hain:',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
                    ),
                    ...pandit.languages.map((l) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(
                        l,
                        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMid),
                      ),
                    )),
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

// ── Star row ──────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 14,
          color: _kAmber,
        );
      }),
    );
  }
}

// ── Puja chip ─────────────────────────────────────────────

class _PujaChip extends StatelessWidget {
  final String label;
  final bool highlight;
  const _PujaChip({required this.label, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? _kCream : AppColors.bgLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: highlight ? _kGold : AppColors.divider),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: highlight ? _kMaroon : AppColors.textMid,
          fontWeight: highlight ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ── Vedic strip ───────────────────────────────────────────

class _VedicStrip extends StatelessWidget {
  const _VedicStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCreamer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kGold.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📿', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shuddh Vedic Parampara ka Paalon',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _kMaroon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hamare sabhi pandits ko unke ucharan, vidhi-vidhaan, aur shastrokta paddhati ke liye personally verify kiya gaya hai. Koi bhi pandit bina certification ke registered nahi hota. Pooja mein istemaal hone wali saari samagri shudh aur praamaanik hoti hai.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textMid,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────

class _Pandit {
  final String emoji, name, title, experience;
  final double rating;
  final int pujaCount;
  final List<String> specialities, languages;

  const _Pandit({
    required this.emoji,
    required this.name,
    required this.title,
    required this.experience,
    required this.rating,
    required this.pujaCount,
    required this.specialities,
    required this.languages,
  });
}

class _Stat {
  final String value, label;
  const _Stat(this.value, this.label);
}

class _PujaType {
  final String name;
  final bool highlight;
  const _PujaType(this.name, {this.highlight = false});
}

// ── Static data ───────────────────────────────────────────

const _stats = [
  _Stat('200+', 'Verified pandits'),
  _Stat('15+',  'Avg. years experience'),
  _Stat('50+',  'Puja types covered'),
  _Stat('4.9',  'Average rating'),
];

const _pandits = [
  _Pandit(
    emoji: '🧘',
    name: 'Pt. Ramesh Chandra Sharma',
    title: 'Jyotish Acharya & Karmakand Visheshagya',
    experience: '22 saal ka anubhav · Kashi Vidyapeeth se shikshit',
    rating: 5.0,
    pujaCount: 312,
    specialities: ['Satyanarayan Katha', 'Griha Pravesh', 'Rudrabhishek'],
    languages: ['Hindi', 'Sanskrit', 'Awadhi'],
  ),
  _Pandit(
    emoji: '🙏',
    name: 'Pt. Vikram Tiwari',
    title: 'Vastu Shastra & Navgraha Specialist',
    experience: '18 saal ka anubhav · Sampoornanand Sanskrit Vishwavidyalaya',
    rating: 4.9,
    pujaCount: 187,
    specialities: ['Vastu Shanti', 'Navgraha Shanti', 'Vivah Puja'],
    languages: ['Hindi', 'Sanskrit', 'English'],
  ),
  _Pandit(
    emoji: '🕉️',
    name: 'Pt. Suresh Mishra',
    title: 'Tantra & Shakti Upasana Visheshagya',
    experience: '25 saal ka anubhav · Gorakhpur Peeth se prashikshit',
    rating: 4.8,
    pujaCount: 243,
    specialities: ['Durga Saptashati', 'Sunderkand', 'Namkaran'],
    languages: ['Hindi', 'Sanskrit', 'Bhojpuri'],
  ),
  _Pandit(
    emoji: '🪔',
    name: 'Pt. Dinesh Shukla',
    title: 'Lagna & Vivah Sanskar Visheshagya',
    experience: '12 saal ka anubhav · Lucknow se prashikshit',
    rating: 4.7,
    pujaCount: 98,
    specialities: ['Vivah Puja', 'Griha Pravesh', 'Diwali Puja'],
    languages: ['Hindi', 'Sanskrit', 'Urdu'],
  ),
];

const _pujaTypes = [
  _PujaType('Satyanarayan Katha',  highlight: true),
  _PujaType('Griha Pravesh',       highlight: true),
  _PujaType('Namkaran Sanskar',    highlight: true),
  _PujaType('Vivah Puja',          highlight: true),
  _PujaType('Navgraha Shanti'),
  _PujaType('Diwali Lakshmi Puja'),
  _PujaType('Durga Saptashati'),
  _PujaType('Rudrabhishek'),
  _PujaType('Sunderkand Path'),
  _PujaType('Vastu Shanti'),
  _PujaType('Mundan Sanskar'),
  _PujaType('Annaprashan'),
  _PujaType('Pitru Paksha Shradh'),
  _PujaType('Maha Mrityunjaya Jaap'),
];