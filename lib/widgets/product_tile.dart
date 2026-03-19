import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product_model.dart';
import '../bloc/products/product_bloc.dart';
import '../bloc/products/product_event.dart';
import '../utils/stock_utils.dart';
import '../screens/add_edit_product_screen.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final String role;

  const ProductTile({
    super.key,
    required this.product,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(
          "₹${product.price} • ${getStockStatus(product.stockCount)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (role == "admin")
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ProductBloc>().add(
                        DeleteProductRequested(product.id),
                      );
                },
              ),

            if (role == "admin")
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditProductScreen(
                        product: product,
                      ),
                    ),
                  );
                },
              ),

            if (role == "manager")
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditProductScreen(
                        product: product,
                        isStockOnly: true,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}