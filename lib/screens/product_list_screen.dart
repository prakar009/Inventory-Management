import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/products/product_bloc.dart';
import '../bloc/products/product_event.dart';
import '../bloc/products/product_state.dart';

import '../widgets/product_tile.dart';

class ProductListScreen extends StatefulWidget {
  final String role;

  const ProductListScreen({super.key, required this.role});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final bloc = context.read<ProductBloc>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (bloc.state is ProductLoaded) {
          final currentState = bloc.state as ProductLoaded;

          if (!currentState.hasReachedMax) {
            bloc.add(LoadMoreProducts());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search products...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              context.read<ProductBloc>().add(SearchProducts(value));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _filterButton("All", "all"),
              _filterButton("Low", "low"),
              _filterButton("Out", "out"),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Products Found",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.products.length) {
                      final product = state.products[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ProductTile(
                          product: product,
                          role: widget.role,
                        ),
                      );
                    }

                    if (state.hasReachedMax) {
                      return const SizedBox();
                    }

                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
    );
  }

  Widget _filterButton(String text, String value) {
    return TextButton(
      onPressed: () {
        context.read<ProductBloc>().add(FilterProducts(value));
      },
      child: Text(text),
    );
  }
}