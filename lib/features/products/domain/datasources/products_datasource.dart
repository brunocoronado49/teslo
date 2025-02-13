import 'package:teslo/features/products/domain/domain.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductsById(String id);
  Future<List<Product>> searchPrductByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
