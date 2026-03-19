import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore;

  DocumentSnapshot? _lastDoc;

  ProductService(this._firestore);

  Future<List<Product>> fetchProducts({int limit = 10}) async {
    Query query = _firestore
        .collection('products')
        .orderBy('name')
        .limit(limit);

    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDoc = snapshot.docs.last;
    }

    return snapshot.docs.map((doc) {
      return Product.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  Future<void> addProduct(Product product) async {
    await _firestore
        .collection('products')
        .add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _firestore
        .collection('products')
        .doc(id)
        .delete();
  }

  void resetPagination() {
    _lastDoc = null;
  }
}