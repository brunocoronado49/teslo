import 'package:dio/dio.dart';
import 'package:teslo/config/config.dart';
import 'package:teslo/features/products/domain/domain.dart';
import 'package:teslo/features/products/infrastructure/infrastructure.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessTokekn;

  ProductsDatasourceImpl({
    required this.accessTokekn
  }) : dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {
      'Authorization': 'Bearer $accessTokekn'
    }
  ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductsById(String id) {
    // TODO: implement getProductsById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/api/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for(final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchPrductByTerm(String term) {
    // TODO: implement searchPrductByTerm
    throw UnimplementedError();
  }
}

