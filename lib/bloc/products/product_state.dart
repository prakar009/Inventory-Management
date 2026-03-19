import '../../models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;

  ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}