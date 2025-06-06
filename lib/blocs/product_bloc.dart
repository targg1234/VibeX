import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../services/product_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<FetchProductEvent>(_onFetchProduct);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }
  Future<void> _onFetchProduct(
      FetchProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productService.fetchAllProduct();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.createProduct(event.product);
      add(FetchProductEvent());
    } catch (e) {
      emit(ProductError('failed to add products: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.updateProduct(event.id, event.updatedProduct);
      add(FetchProductEvent());
    } catch (e) {
      emit(ProductError('failed to update products: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.deleteProduct(event.id);
      add(FetchProductEvent());
    } catch (e) {
      emit(ProductError('failed to delete products: ${e.toString()}'));
    }
  }
}
