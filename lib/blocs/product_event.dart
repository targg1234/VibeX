import '../models/product.dart';

abstract class ProductEvent {}

class FetchProductEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Product product;

  AddProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final String id;
  final Product updatedProduct;

  UpdateProductEvent(this.id, this.updatedProduct);
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  DeleteProductEvent(this.id);
}
