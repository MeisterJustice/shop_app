import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
    @required this.title,
  });

  Future<void> toggleFavorite() async{
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shop-app-51506.firebaseio.com/products/$id.json';
    try {
     final response =  await http.patch(
      url,
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    );
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
    }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
    
  }
}
