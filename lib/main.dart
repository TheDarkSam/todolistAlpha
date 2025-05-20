import 'package:flutter/material.dart';
import 'package:http_app/pages/home_page.dart';
import 'package:http_app/service/theme_provider_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProviderService>(
          create: (_) => ThemeProviderService(),
        ),
      ],
      child: Consumer<ThemeProviderService>(
        builder: (_, _themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme:
                _themeProvider.themeStatus
                    ? ThemeData.dark()
                    : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
