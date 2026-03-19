import '../../models/product_model.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class AddProductRequested extends ProductEvent {
  final Product product;

  AddProductRequested(this.product);
}

class UpdateProductRequested extends ProductEvent {
  final Product product;

  UpdateProductRequested(this.product);
}

class DeleteProductRequested extends ProductEvent {
  final String id;

  DeleteProductRequested(this.id);
}

class SearchProducts extends ProductEvent {
  final String query;

  SearchProducts(this.query);
}

class FilterProducts extends ProductEvent {
  final String filter;

  FilterProducts(this.filter);
}