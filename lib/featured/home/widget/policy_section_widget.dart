import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
//  Wrapper — three policies as one tabbed widget
// ─────────────────────────────────────────────

class PolicySectionWidget extends StatefulWidget {
  const PolicySectionWidget({super.key});

  @override
  State<PolicySectionWidget> createState() => _PolicySectionWidgetState();
}

class _PolicySectionWidgetState extends State<PolicySectionWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    _TabData(icon: '💰', label: 'Refund Policy'),
    _TabData(icon: '📜', label: 'Terms & Conditions'),
    _TabData(icon: '🔒', label: 'Privacy Policy'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C1200),
              Color(0xFF6B0F2B),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: isMobile ? 56 : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section heading
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.gold.withOpacity(0.4), width: 1),
                    ),
                    child: Text(
                      'Legal & Policies',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Our Policies',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transparency and trust in everything we do.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Custom tab bar
            _PolicyTabBar(
              tabs: _tabs,
              controller: _tabController,
              isMobile: isMobile,
            ),
            const SizedBox(height: 28),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(child: _RefundPolicyContent(isMobile: isMobile)),
                  SingleChildScrollView(child: _TermsContent(isMobile: isMobile)),
                  SingleChildScrollView(child: _PrivacyContent(isMobile: isMobile)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TabData {
  final String icon;
  final String label;
  const _TabData({required this.icon, required this.label});
}

// ─────────────────────────────────────────────
//  Custom animated tab bar
// ─────────────────────────────────────────────

class _PolicyTabBar extends StatelessWidget {
  final List<_TabData> tabs;
  final TabController controller;
  final bool isMobile;

  const _PolicyTabBar({
    required this.tabs,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
      ),
      child: isMobile
          ? Column(
        children: List.generate(tabs.length, (i) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final selected = controller.index == i;
              return GestureDetector(
                onTap: () => controller.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(tabs[i].icon,
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Text(
                        tabs[i].label,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      )
          : Row(
        children: List.generate(tabs.length, (i) {
          return Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final selected = controller.index == i;
                return GestureDetector(
                  onTap: () => controller.animateTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tabs[i].icon,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            tabs[i].label,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.55),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared card widget for each policy item
// ─────────────────────────────────────────────

class _PolicyCard extends StatelessWidget {
  final String title;
  final String content;

  const _PolicyCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldLight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: Colors.white.withOpacity(0.72),
                height: 1.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Policy 1 — Refund & Cancellation
// ─────────────────────────────────────────────

class _RefundPolicyContent extends StatelessWidget {
  final bool isMobile;
  const _RefundPolicyContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const items = [
      _Item(
        'Order Cancellation',
        'You may cancel your order up to 2 hours before the scheduled delivery time. Cancellations requested after this window will not be accepted, as the items will already be in transit.',
      ),
      _Item(
        'Refund Processing',
        'Once a cancellation is confirmed, your refund will be processed within 5–7 business days back to the original payment method. You will receive a confirmation message via WhatsApp once the refund is initiated.',
      ),
      _Item(
        'Damaged or Incorrect Items',
        'If you receive a damaged or incorrect product, please contact us within 24 hours of delivery with clear photographs. We will arrange a replacement or issue a full refund after verification.',
      ),
      _Item(
        'Pandit Ji Booking Cancellation',
        'Pandit Ji bookings may be cancelled up to 24 hours before the scheduled puja. Cancellations made within 24 hours of the puja time will result in forfeiture of the advance booking amount.',
      ),
      _Item(
        'Non-Refundable Items',
        'Fresh flowers, perishable puja items (like fresh fruits and raw milk), and custom-assembled puja kits are non-refundable once dispatched, due to their perishable nature.',
      ),
      _Item(
        'Force Majeure',
        'Poojify shall not be liable for cancellations or delays caused by unforeseen circumstances such as natural disasters, government-imposed restrictions, or severe weather conditions. Refunds in such cases will be evaluated on a case-by-case basis.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last updated: January 2025',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: Colors.white.withOpacity(0.4),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((i) => _PolicyCard(title: i.title, content: i.content)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Policy 2 — Terms & Conditions
// ─────────────────────────────────────────────

class _TermsContent extends StatelessWidget {
  final bool isMobile;
  const _TermsContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const items = [
      _Item(
        'Acceptance of Terms',
        'By accessing or using the Poojify platform (website or app), you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our services.',
      ),
      _Item(
        'Service Description',
        'Poojify provides delivery of puja samagri (religious items) and facilitates bookings of qualified pandits for religious ceremonies in Lucknow, Uttar Pradesh. Services are intended solely for personal, non-commercial use.',
      ),
      _Item(
        'User Responsibilities',
        'You are responsible for providing accurate delivery address and contact details at the time of placing an order. Poojify is not liable for failed or incorrect deliveries resulting from inaccurate information provided by the user.',
      ),
      _Item(
        'Pandit Ji Availability',
        'Pandit Ji bookings are subject to availability and confirmation. We confirm pandit availability no later than 12 hours before the scheduled puja. In rare cases of unavailability, we will offer an alternative pandit or a full refund.',
      ),
      _Item(
        'Pricing & Changes',
        'Prices for puja items may vary based on seasonal availability and festival demand. The final price applicable to your order is confirmed at the time of order placement. Poojify reserves the right to update pricing with prior notice.',
      ),
      _Item(
        'Intellectual Property',
        'All content on the Poojify platform, including logos, text, graphics, and design elements, is the intellectual property of Poojify. Unauthorized reproduction or distribution is strictly prohibited.',
      ),
      _Item(
        'Limitation of Liability',
        'Poojify shall not be held liable for delivery delays caused by traffic, strikes, bandh, natural disasters, or other events beyond our reasonable control. Our total liability in any circumstance shall not exceed the value of the specific order in question.',
      ),
      _Item(
        'Governing Law & Jurisdiction',
        'These Terms are governed by the laws of India. Any disputes arising from the use of Poojify services shall be subject to the exclusive jurisdiction of courts located in Lucknow, Uttar Pradesh.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last updated: January 2025',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: Colors.white.withOpacity(0.4),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((i) => _PolicyCard(title: i.title, content: i.content)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Policy 3 — Privacy Policy
// ─────────────────────────────────────────────

class _PrivacyContent extends StatelessWidget {
  final bool isMobile;
  const _PrivacyContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const items = [
      _Item(
        'Information We Collect',
        'We collect only the information necessary to process your orders and provide our services. This includes your name, delivery address, phone number, and WhatsApp contact. We do not collect payment card details directly.',
      ),
      _Item(
        'How We Use Your Information',
        'Your information is used exclusively to confirm orders, coordinate deliveries, send order updates, and notify you of service-related communications. We do not use your data for advertising profiling or sell it to third parties.',
      ),
      _Item(
        'Data Security',
        'Your personal information is stored on secure, encrypted servers. We implement industry-standard security measures to protect your data from unauthorized access, disclosure, or alteration.',
      ),
      _Item(
        'WhatsApp Communication',
        'Your WhatsApp number is used solely for order confirmations, delivery status updates, and direct customer support. You will not receive unsolicited promotional messages. You may opt out of communications at any time by messaging "STOP".',
      ),
      _Item(
        'Cookies & Analytics',
        'Our platform may use anonymized analytics data (e.g., pages visited, session duration) to improve user experience. No personally identifiable information is linked to these analytics. You can disable cookies through your browser settings.',
      ),
      _Item(
        'Data Retention',
        'Order and contact information is retained for up to 12 months from the date of your last transaction. After this period, your data is either anonymized or deleted. You may request deletion of your data at any time by contacting us.',
      ),
      _Item(
        'Third-Party Services',
        'We may use third-party services such as payment gateways and mapping tools to fulfill orders. These services have their own privacy policies, and we are not responsible for their data practices.',
      ),
      _Item(
        'Policy Updates',
        'Any significant changes to this Privacy Policy will be communicated to you via in-app notification or WhatsApp message at least 7 days before the changes take effect. Continued use of the platform implies acceptance of the updated policy.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last updated: January 2025',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: Colors.white.withOpacity(0.4),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((i) => _PolicyCard(title: i.title, content: i.content)),
      ],
    );
  }
}

class _Item {
  final String title;
  final String content;
  const _Item(this.title, this.content);
}

// ─────────────────────────────────────────────
//  Individual wrapper widgets (for backward compat)
// ─────────────────────────────────────────────

class RefundPolicySectionWidget extends StatelessWidget {
  const RefundPolicySectionWidget({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class TermsConditionsSectionWidget extends StatelessWidget {
  const TermsConditionsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class PrivacyPolicySectionWidget extends StatelessWidget {
  const PrivacyPolicySectionWidget({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}