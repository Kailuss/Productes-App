import 'package:flutter/material.dart';
import 'package:productes_app/screens/product_screen.dart';
import 'package:productes_app/screens/screens.dart';
import 'package:productes_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductsService())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productes App',
      initialRoute: 'login',
      routes: {
        'home': (_) => const HomeScreen(),
        'login': (_) => const LoginScreen(),
        'product': (_) => const ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}
