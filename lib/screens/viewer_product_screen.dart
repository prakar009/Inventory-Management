import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/bloc/auth/auth_bloc.dart';
import 'package:task1/bloc/auth/auth_event.dart';
import 'package:task1/screens/login_screen.dart';

import '../bloc/products/product_bloc.dart';
import '../bloc/products/product_event.dart';
import '../bloc/products/product_state.dart';

import '../widgets/product_tile.dart';

class ViewerProductScreen extends StatefulWidget {
  const ViewerProductScreen({super.key});

  @override
  State<ViewerProductScreen> createState() =>
      _ViewerProductScreenState();
}

class _ViewerProductScreenState extends State<ViewerProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProducts());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductBloc>().add(LoadMoreProducts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Products"),
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(
                      SearchProducts(value),
                    );
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text("No Products Found"),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: state.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.products.length) {
                        final product = state.products[index];

                        return Container(
                          margin:
                              const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: ProductTile(
                            product: product,
                            role: "viewer",
                          ),
                        );
                      } else {
                        return state.hasReachedMax
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child:
                                      CircularProgressIndicator(),
                                ),
                              );
                      }
                    },
                  );
                }

                if (state is ProductError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}