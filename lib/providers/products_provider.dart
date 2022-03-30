import 'package:flutter/material.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Pink Cute Hoodie',
        description: 'A pink hoodie - it is pretty comfy and cool',
        price: 300.00,
        imageUrl:
            'https://5.imimg.com/data5/TS/NG/FG/ANDROID-40591384/product-jpeg-500x500.jpg'),
    Product(
        id: 'p2',
        title: 'Black Palazzo',
        description: 'A black palazzo - Go to Party ',
        price: 1200.00,
        imageUrl: 'https://img.faballey.com/images/Product/IPL00617Z/d3.jpg'),
    Product(
        id: 'p3',
        title: 'Lace-Up Sports Shoes',
        description: 'A sports shoes - Get a Run',
        price: 900.00,
        imageUrl:
            'https://assets.ajio.com/medias/sys_master/root/hd4/h99/14092964397086/-1117Wx1400H-460455972-black-MODEL.jpg'),
    Product(
        id: 'p4',
        title: 'Crunchy Fashion Earings',
        description: 'A fashion earning - Get it Complete',
        price: 499.00,
        imageUrl:
            'https://media6.ppl-media.com/tr:h-750,w-750,c-at_max/static/img/product/134451/crunchy-fashion-monocromatic-dapper-earings_1_display_1514549697_fb1318b8.jpg'),
  ];
// var _showFavoritesOnly=false;
  List<Product> get items {
    // if(_showFavoritesOnly)
    //   {
    //    return _items.where((proditem) => proditem.isFav).toList();
    //   }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((proditem) => proditem.isFav).toList();
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly=true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly=false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct=Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct);
    notifyListeners();
  }

  void updateProduct(String id,Product newProduct){
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    if(prodIndex>=0){
      _items[prodIndex]=newProduct;
      notifyListeners();
    }
    else{
      print('...');
    }
  }
  
  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id==id);
    notifyListeners();
  }
}
