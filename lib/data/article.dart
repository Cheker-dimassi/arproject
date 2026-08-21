import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Miroir exact de `ArticleDto` cote backend. Pas de champ "note/avis" —
/// ce champ n'existe pas dans le backend, donc l'app n'en affiche pas
/// (mieux vaut ne rien montrer que d'inventer une donnee).
class Article {
  final String id;
  final String name;
  final String category;
  final String description;
  final String glbAsset;
  final String usdzAsset;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double price;
  final String material;
  final String dimensions;
  final String accentColor;
  final String icon;
  final bool featured;
  final String placement;

  const Article({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.glbAsset,
    required this.usdzAsset,
    this.imageUrl,
    this.thumbnailUrl,
    required this.price,
    required this.material,
    required this.dimensions,
    required this.accentColor,
    required this.icon,
    required this.featured,
    this.placement = 'floor',
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      glbAsset: json['glbAsset'] as String,
      usdzAsset: json['usdzAsset'] as String,
      imageUrl: (json['imageUrl'] as String?)?.trim().isEmpty ?? true
          ? null : json['imageUrl'] as String,
      thumbnailUrl: (json['thumbnailUrl'] as String?)?.trim().isEmpty ?? true
          ? null : json['thumbnailUrl'] as String,
      price: (json['price'] as num).toDouble(),
      material: json['material'] as String? ?? '',
      dimensions: json['dimensions'] as String? ?? '',
      accentColor: json['accentColor'] as String? ?? 'E8A33D',
      icon: json['icon'] as String? ?? 'chair',
      featured: json['featured'] as bool? ?? false,
      placement: json['placement'] as String? ?? 'floor',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'glbAsset': glbAsset,
    'usdzAsset': usdzAsset,
    'imageUrl': imageUrl,
    'thumbnailUrl': thumbnailUrl,
    'price': price,
    'material': material,
    'dimensions': dimensions,
    'accentColor': accentColor,
    'icon': icon,
    'featured': featured,
    'placement': placement,
  };


  bool get isWallMounted => placement.toLowerCase() == 'wall';
  ArPlacement get arPlacement => isWallMounted ? ArPlacement.wall : ArPlacement.floor;
  String? get displayImage => thumbnailUrl ?? imageUrl;

  Color get accentColorValue {
    final hex = accentColor.replaceAll('#', '');
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFFE8A33D);
    }
  }

  IconData get iconData {
    switch (icon.toLowerCase()) {
      case 'sofa': case 'canape': case 'weekend': return Icons.weekend;
      case 'lamp': case 'lampe': case 'lightbulb': return Icons.lightbulb_outline;
      case 'wb_incandescent': case 'wb_iridescent': case 'flare': return Icons.wb_incandescent;
      case 'table': case 'table_bar': case 'table_restaurant': return Icons.table_restaurant;
      case 'chair': case 'chaise': return Icons.chair_alt;
      case 'shelf': case 'etagere': return Icons.shelves;
      case 'bed': case 'lit': return Icons.bed;
      case 'camera_alt': return Icons.camera_alt_outlined;
      case 'museum': return Icons.museum_outlined;
      case 'account_balance': return Icons.account_balance_outlined;
      case 'local_florist': return Icons.local_florist_outlined;
      case 'airline_seat_recline_normal': return Icons.airline_seat_recline_normal;
      default: return Icons.chair_alt;
    }
  }
}
