import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/helper/response/status.dart';
import 'package:poojify_landing_site/main.dart';
import 'package:poojify_landing_site/model/setting_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';

String typeToSlug(String type) =>
    type.toLowerCase().trim().replaceAll(' ', '-').replaceAll('&', 'and');

class PolicyPage extends StatefulWidget {
  final String initialSlug;
  const PolicyPage({super.key, required this.initialSlug});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  String _selectedSlug = '';

  @override
  void initState() {
    super.initState();
    _selectedSlug = widget.initialSlug;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AppSettingViewModel>();
      if (vm.appDetails.status != Status.COMPLETED) {
        vm.fetchAppDetails();
      }
    });
  }

  void _selectTab(String slug) {
    setState(() => _selectedSlug = slug);
    appRouter.go('/policy/$slug');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBF4A10),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => appRouter.go('/'),
        ),
        title: Row(children: [
          const Text('🪔', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            'Poojify — Policies',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ]),
      ),
      body: Consumer<AppSettingViewModel>(
        builder: (context, vm, _) {
          final response = vm.appDetails;

          if (response.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE87722)),
            );
          }

          if (response.status == Status.ERROR) {
            return _ErrorView(
              message: response.message ?? 'Something went wrong',
              onRetry: vm.fetchAppDetails,
            );
          }

          final items = response.data?.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No policies found.'));
          }

          final validSlug =
          items.any((d) => typeToSlug(d.type ?? '') == _selectedSlug)
              ? _selectedSlug
              : typeToSlug(items.first.type ?? '');

          final selectedDatum = items.firstWhere(
                (d) => typeToSlug(d.type ?? '') == validSlug,
            orElse: () => items.first,
          );

          return Column(
            children: [
              _TabHeader(
                items: items,
                selectedSlug: validSlug,
                onSelect: _selectTab,
              ),
              Expanded(child: _PolicyContentView(datum: selectedDatum)),
            ],
          );
        },
      ),
    );
  }
}

// ── Tab Header ────────────────────────────────────────────────────────────────

class _TabHeader extends StatelessWidget {
  final List<AppData> items;
  final String selectedSlug;
  final ValueChanged<String> onSelect;

  const _TabHeader({
    required this.items,
    required this.selectedSlug,
    required this.onSelect,
  });

  String _emojiFor(String? type) {
    final t = (type ?? '').toLowerCase();
    if (t.contains('privacy')) return '🔒';
    if (t.contains('terms') || t.contains('condition')) return '📜';
    if (t.contains('refund') || t.contains('cancel')) return '💰';
    if (t.contains('help') || t.contains('support')) return '🙋';
    return '📄';
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      color: const Color(0xFFBF4A10),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Policies',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Transparency and trust in everything we do.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.asMap().entries.map((e) {
                final slug = typeToSlug(e.value.type ?? '');
                final isSelected = slug == selectedSlug;

                return Padding(
                  padding: EdgeInsets.only(
                    right: e.key < items.length - 1 ? 8 : 0,
                    bottom: 16,
                  ),
                  child: _TabChip(
                    label:
                    '${_emojiFor(e.value.type)}  ${e.value.type ?? ''}',
                    selected: isSelected,
                    onTap: () => onSelect(slug),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE87722)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected
                ? const Color(0xFFE87722)
                : Colors.white.withOpacity(0.18),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight:
              selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
// ── Policy Content ────────────────────────────────────────────────────────────

class _PolicyContentView extends StatelessWidget {
  final AppData datum;
  const _PolicyContentView({required this.datum});

  @override
  Widget build(BuildContext context) {
    final content = datum.content ?? '';
    final isHtml = content.contains('<') && content.contains('>');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Last updated: January 2025',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: Colors.black.withOpacity(0.35),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFBF47),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    datum.type ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: isHtml
                    ? HtmlWidget(
                  content,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.black.withOpacity(0.68),
                    height: 1.8,
                  ),
                  customStylesBuilder: (element) {
                    if (element.localName == 'h2') {
                      return {
                        'font-size': '15px',
                        'font-weight': '600',
                        'margin-top': '16px',
                        'margin-bottom': '6px',
                        'color': '#1a1a1a',
                      };
                    }
                    if (element.localName == 'h3') {
                      return {
                        'font-size': '13.5px',
                        'font-weight': '600',
                        'margin-top': '12px',
                        'color': '#333333',
                      };
                    }
                    if (element.localName == 'li') {
                      return {'margin-bottom': '4px'};
                    }
                    return null;
                  },
                )
                    : Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.black.withOpacity(0.68),
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFFBF47).withOpacity(0.35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📬', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Questions about this policy? Contact us at support@poojify.in or WhatsApp us directly.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE87722),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}