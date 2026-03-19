import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/screens/add_edit_product_screen.dart';
import 'package:task1/screens/login_screen.dart';
import 'package:task1/screens/viewer_product_screen.dart';

import '../bloc/products/product_bloc.dart';
import '../bloc/products/product_state.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

import '../widgets/dashboard_card.dart';
import 'product_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;

  const DashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
  onPressed: () {
    context.read<AuthBloc>().add(LogoutRequested());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  },
  icon: const Icon(Icons.logout),
)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductLoaded) {
              final products = state.products;

              final total = products.length;
              final lowStock =
                  products.where((p) => p.stockCount < 10).length;

              final totalValue = products.fold(
                0.0,
                (sum, p) => sum + (p.price * p.stockCount),
              );

              return Column(
                children: [
                 Row(
  children: [
    Expanded(
      child: DashboardCard(
        title: "Total Products",
        value: total.toString(),
        icon: Icons.inventory,
        color: Colors.blue,
      ),
    ),
    Expanded(
      child: DashboardCard(
        title: "Low Stock",
        value: lowStock.toString(),
        icon: Icons.warning,
        color: Colors.red,
      ),
    ),
  ],
),
                  const SizedBox(height: 10),
                 DashboardCard(
  title: "Total Value",
  value: "₹${totalValue.toStringAsFixed(0)}",
  icon: Icons.currency_rupee,
  color: Colors.green,
),
                  const SizedBox(height: 10),
                  Expanded(
  child: role == "viewer"
      ? const ViewerProductScreen()
      : ProductListScreen(role: role),
),
                ],
              );
            }

            return const Center(child: Text("No Data"));
          },
        ),
      ),
     floatingActionButton: role == "admin"
    ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
    : null,
    );
  }
}