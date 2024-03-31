// import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import '../../models/auth_token.dart';

import '../../models/product.dart';
import '../../services/products_service.dart';

// import '../shared/dialog_utils.dart';
// import 'package:provider/provider.dart';

class ProductsManager with ChangeNotifier{
  
  List<Product> _items = [];


  final ProductsService _productsService;
  ProductsManager([AuthToken? authToken])
      : _productsService= ProductsService(authToken);

  set authToken (AuthToken? authToken){
    _productsService.authToken= authToken;
  }
  Future<void> fetchProducts() async{
    _items = await _productsService.fetchProducts();
    notifyListeners();
  }
  Future<void> fetchUserProducts() async{
    _items= await _productsService.fetchProducts(
      filteredByUser: true,
    );
    notifyListeners();
  }
  Future<void> addProduct(Product product) async{
    final newProduct = await _productsService.addProduct(product);
    if(newProduct != null){
      _items.add(newProduct);
      notifyListeners();
    }
  }
  Future<void> updateProduct(Product product) async{
    final index = _items.indexWhere((item) => item.id ==product.id);
    if(index>=0){
      if( await _productsService.updateProduct(product)){
        _items[index]=product;
        notifyListeners();
      }
    }
  }
  Future<void> deleteProduct(String id) async{
    final index= _items.indexWhere((item) => item.id == id);
    Product? exitstingProduct =_items[index];
    _items.removeAt(index);
    notifyListeners();

    if(!await _productsService.deleteProduct(id)){
      _items.insert(index, exitstingProduct);
      notifyListeners();
    }
  }
  int get itemCount {
    return _items.length;
  }
  List<Product> get items {
    return [..._items];
  }
  List<Product> get favoriteItems{
    return _items.where((item)=> item.isFavorite).toList();
  }
  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
  Future<void> toggleFavoriteStatus(Product product) async{
    final savedStatus=product.isFavorite;
    product.isFavorite=!savedStatus;
    if( !await _productsService.saveFavoriteStatus(product)){
      product.isFavorite=savedStatus;
    }
  }
}