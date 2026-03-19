import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product_model.dart';
import '../bloc/products/product_bloc.dart';
import '../bloc/products/product_event.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  final bool isStockOnly;

  const AddEditProductScreen({super.key, this.product, this.isStockOnly = false});

  @override
  State<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
      stockController.text = widget.product!.stockCount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Product" : "Add Product"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff00f2fe)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEdit ? Icons.edit : Icons.add_box,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      isEdit ? "Update Product" : "Add Product",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (!widget.isStockOnly) ...[
                      _field(
                        "Product Name",
                        nameController,
                        icon: Icons.inventory,
                      ),
                      const SizedBox(height: 15),

                      _field(
                        "Price",
                        priceController,
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                    ],

                    _field(
                      "Stock",
                      stockController,
                      icon: Icons.store,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (widget.isStockOnly &&
                              widget.product != null) {
                            final updatedProduct = Product(
                              id: widget.product!.id,
                              name: widget.product!.name,
                              price: widget.product!.price,
                              stockCount:
                                  int.tryParse(stockController.text) ??
                                      0,
                            );

                            context.read<ProductBloc>().add(
                                  UpdateProductRequested(
                                      updatedProduct),
                                );
                          } else {
                            final product = Product(
                              id: widget.product?.id ?? "",
                              name: nameController.text.trim(),
                              price: double.tryParse(
                                      priceController.text) ??
                                  0,
                              stockCount:
                                  int.tryParse(stockController.text) ??
                                      0,
                            );

                            if (widget.product == null) {
                              context.read<ProductBloc>().add(
                                    AddProductRequested(product),
                                  );
                            } else {
                              context.read<ProductBloc>().add(
                                    UpdateProductRequested(product),
                                  );
                            }
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          isEdit ? "Update" : "Add",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}