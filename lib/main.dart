import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'bloc/products/product_event.dart';

import 'services/auth_service.dart';
import 'services/product_service.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authService = AuthService(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  final productService = ProductService(
    FirebaseFirestore.instance,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authService),
        ),
        BlocProvider(
          create: (_) => ProductBloc(productService)
            ..add(LoadProducts()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}