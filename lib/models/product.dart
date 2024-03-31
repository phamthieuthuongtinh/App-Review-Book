import 'package:flutter/foundation.dart';

class Product {
  final String? id;
  final String title;
  final String cate;
  final String author;
  final String imageUrl;
  final String description;
  final ValueNotifier<bool> _isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.cate,
    required this.author,
    required this.imageUrl,
    isFavorite= false,
  }): _isFavorite = ValueNotifier(isFavorite);

  set isFavorite(bool newValue){
    _isFavorite.value=newValue;
  }
  

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool>  get isFavoriteListenable{
    return _isFavorite;
  }
  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? cate,
    String? author,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cate: cate ?? this.cate,
      author: author?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'description': description,
      'cate': cate,
      'author': author,
      'imageUrl': imageUrl,
    };
  }
  static Product fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      title: json['title'], 
      description: json['description'], 
      cate: json['cate'], 
      author: json['author'], 
      imageUrl: json['imageUrl'],
      );
  }
}