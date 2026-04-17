import 'package:flutter/material.dart';
import 'package:poojify_landing_site/featured/home/view/home_view.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';


void main() {
  runApp(const PoojifyApp());
}

class PoojifyApp extends StatelessWidget {
  const PoojifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => AppSettingViewModel()),

      ],
      child: MaterialApp(
        title: 'Poojify - Sacred Essentials Delivered',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeView(),
      ),
    );
  }
}