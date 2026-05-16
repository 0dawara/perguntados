import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CategoryModel {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory CategoryModel.fromParse(ParseObject object) {
    final name = object.get<String>('name') ?? 'Unknown';
    return CategoryModel(
      id: object.objectId!,
      name: name,
      color: _hexToColor(object.get<String>('color') ?? '#2196F3'),
      icon: _getIconForCategory(name),
    );
  }

  static IconData _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'geografia':
        return Icons.public;
      case 'ciências':
        return Icons.science;
      case 'esportes':
        return Icons.sports_basketball;
      case 'história':
        return Icons.history_edu;
      case 'pop':
        return Icons.movie;
      case 'artes':
        return Icons.palette;
      case 'coroa':
        return Icons.workspace_premium;
      default:
        return Icons.help_outline;
    }
  }

  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
