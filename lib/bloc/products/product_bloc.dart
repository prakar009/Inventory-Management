import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/product_service.dart';
import '../../models/product_model.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  List<Product> _allProducts = [];
  bool _hasReachedMax = false;
  bool _isFetching = false;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      try {
        productService.resetPagination();

        final data = await productService.fetchProducts();
        _allProducts = data;

        _hasReachedMax = data.isEmpty;

        emit(ProductLoaded(
          products: _allProducts,
          hasReachedMax: _hasReachedMax,
        ));
      } catch (e) {
        emit(ProductError("Failed to load products"));
      }
    });

    on<LoadMoreProducts>((event, emit) async {
      if (_hasReachedMax || _isFetching) return;

      if (state is ProductLoaded) {
        try {
          _isFetching = true;

          final moreData = await productService.fetchProducts();

          if (moreData.isEmpty) {
            _hasReachedMax = true;
          } else {
            _allProducts.addAll(moreData);
          }

          emit((state as ProductLoaded).copyWith(
            products: List.from(_allProducts),
            hasReachedMax: _hasReachedMax,
          ));

          _isFetching = false;
        } catch (e) {
          _isFetching = false;
          emit(ProductError("Pagination error"));
        }
      }
    });

    on<AddProductRequested>((event, emit) async {
      try {
        await productService.addProduct(event.product);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError("Add failed"));
      }
    });

    on<UpdateProductRequested>((event, emit) async {
      try {
        await productService.updateProduct(event.product);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError("Update failed"));
      }
    });

    on<DeleteProductRequested>((event, emit) async {
      try {
        await productService.deleteProduct(event.id);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError("Delete failed"));
      }
    });

    on<SearchProducts>((event, emit) {
      final results = _allProducts
          .where((p) =>
              p.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(ProductLoaded(
        products: results,
        hasReachedMax: true,
      ));
    });

    on<FilterProducts>((event, emit) {
      List<Product> results;

      if (event.filter == "low") {
        results =
            _allProducts.where((p) => p.stockCount < 10).toList();
      } else if (event.filter == "out") {
        results =
            _allProducts.where((p) => p.stockCount == 0).toList();
      } else {
        results = _allProducts;
      }

      emit(ProductLoaded(
        products: results,
        hasReachedMax: true,
      ));
    });
  }
}