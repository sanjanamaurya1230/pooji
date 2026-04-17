import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poojify_landing_site/helper/response/api_response.dart';
import 'package:poojify_landing_site/helper/response/status.dart';
import 'package:poojify_landing_site/model/setting_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────
//  POLICY PAGE — fetches from API, renders dynamically
// ─────────────────────────────────────────────

class PolicyPage extends StatefulWidget {
  /// [initialType] — pass the "type" string from the API datum that was tapped.
  /// e.g. "Privacy Policy", "Terms Conditions", "Help Support"
  final String? initialType;

  const PolicyPage({super.key, this.initialType});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  // Tracks which tab (Datum) is currently selected by its `type` string
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;

    // Fetch if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AppSettingViewModel>();
      if (vm.appDetails.status != Status.COMPLETED) {
        vm.fetchAppDetails();
      } else if (_selectedType == null) {
        // Auto-select first available tab
        _selectFirst(vm.appDetails.data);
      }
    });
  }

  void _selectFirst(AppSettingModel? model) {
    if (model != null && model.data.isNotEmpty) {
      setState(() => _selectedType = model.data.first.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      appBar: _buildAppBar(),
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

          final model = response.data!;
          final items = model.data;

          if (items.isEmpty) {
            return const Center(
              child: Text('No policies found.'),
            );
          }

          // Auto-select first if nothing selected yet
          _selectedType ??= items.first.type;

          final selectedDatum = items.firstWhere(
                (d) => d.type == _selectedType,
            orElse: () => items.first,
          );

          return Column(
            children: [
              _TabHeader(
                items: items,
                selectedType: _selectedType!,
                onSelect: (type) => setState(() => _selectedType = type),
              ),
              Expanded(
                child: _PolicyContentView(datum: selectedDatum),
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFBF4A10),
      elevation: 0,
      leading: BackButton(
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
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
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TAB HEADER — built from API data
// ─────────────────────────────────────────────

class _TabHeader extends StatelessWidget {
  final List<AppData> items;
  final String selectedType;
  final ValueChanged<String> onSelect;

  const _TabHeader({
    required this.items,
    required this.selectedType,
    required this.onSelect,
  });

  // Pick an emoji for each type based on keywords
  String _emojiFor(String? type) {
    final t = (type ?? '').toLowerCase();
    if (t.contains('privacy')) return '🔒';
    if (t.contains('terms') || t.contains('condition')) return '📜';
    if (t.contains('refund') || t.contains('cancel')) return '💰';
    if (t.contains('help') || t.contains('support')) return '🙋';
    return '📄';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFBF4A10),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
          const SizedBox(height: 6),
          Text(
            'Transparency and trust in everything we do.',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 500;
            if (isMobile) {
              return Column(
                children: items
                    .map((d) => _TabChip(
                  label: '${_emojiFor(d.type)}  ${d.type ?? ''}',
                  selected: d.type == selectedType,
                  onTap: () => onSelect(d.type ?? ''),
                  bottomMargin: 8,
                ))
                    .toList(),
              );
            }
            return Row(
              children: items
                  .asMap()
                  .entries
                  .map((e) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: e.key < items.length - 1 ? 8 : 0),
                  child: _TabChip(
                    label:
                    '${_emojiFor(e.value.type)}  ${e.value.type ?? ''}',
                    selected: e.value.type == selectedType,
                    onTap: () => onSelect(e.value.type ?? ''),
                  ),
                ),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double bottomMargin;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.bottomMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: bottomMargin),
        padding:
        const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE87722)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected
                ? const Color(0xFFE87722)
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight:
            selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? Colors.white
                : Colors.white.withOpacity(0.55),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  POLICY CONTENT — renders API HTML/text content
// ─────────────────────────────────────────────

class _PolicyContentView extends StatelessWidget {
  final AppData datum;

  const _PolicyContentView({required this.datum});

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 20),

        // ── Main content card ──
        Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withOpacity(0.08),
            ),
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
              Row(
                children: [
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Text(
                  datum.content ?? 'No content available.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.75,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Footer contact note ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFFBF47).withOpacity(0.3),
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

// ─────────────────────────────────────────────
//  ERROR VIEW
// ─────────────────────────────────────────────

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
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
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