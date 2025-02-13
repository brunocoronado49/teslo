import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/providers.dart';
import 'package:teslo/features/products/domain/domain.dart';
import 'package:teslo/features/products/infrastructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? ''; // Accede al token del auth provider

  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(accessTokekn: accessToken)
  );

  return productsRepository;
});

