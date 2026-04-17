import 'package:flutter/material.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/featured/home/widget/about_section_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/contact_us_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/footer_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/home_section_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/navbar_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/pandit_section_widget.dart';
import 'package:poojify_landing_site/featured/home/widget/whtsapp_fab_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      body: Stack(
        children: [
          Column(
            children: [
              const PoojifyNavbar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: vm.scrollController,
                  child: Column(
                    children: [
                      KeyedSubtree(
                        key: vm.homeKey,
                        child: const HomeSectionWidget(),
                      ),
                      KeyedSubtree(
                        key: vm.aboutKey,
                        child: const AboutUsSectionWidget(),
                      ),
                      KeyedSubtree(
                        key: vm.panditKey,
                        child: const PanditSectionWidget(),
                      ),
                      KeyedSubtree(
                        key: vm.contactKey,
                        child: const ContactSectionWidget(),
                      ),
                      const FooterWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const WhatsAppFloatingButton(),
        ],
      ),
    );
  }
}