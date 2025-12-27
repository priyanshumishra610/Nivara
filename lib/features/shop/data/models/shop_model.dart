import 'package:equatable/equatable.dart';

class ShopItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final List<String> tags;
  final bool isRecommended;
  final String? aiReason;
  
  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.tags,
    required this.isRecommended,
    this.aiReason,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    tags,
    isRecommended,
    aiReason,
  ];
}

class ShopCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  
  const ShopCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
  
  @override
  List<Object?> get props => [id, name, icon];
}

