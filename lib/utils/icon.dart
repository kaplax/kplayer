import 'package:flutter/material.dart';

Widget _buildIcon(IconData icon,
    {Color color = Colors.yellow, double size = 30}) {
  return Icon(icon, color: color, size: size);
}

final Map<RegExp, IconData> _iconMap = {
  RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false): Icons.image,
  RegExp(r'\.(mp4|avi)$', caseSensitive: false): Icons.movie,
  RegExp(r'^dir$'): Icons.folder,
  // 其他类型和图标可以在这里添加
};

Widget renderIcon(String filename,
    {Color color = Colors.yellow, double size = 30}) {
  // 遍历映射，查找匹配的文件类型
  for (var entry in _iconMap.entries) {
    if (entry.key.hasMatch(filename)) {
      return _buildIcon(entry.value, color: color, size: size);
    }
  }
  // 没有匹配的文件类型，返回默认图标
  return _buildIcon(Icons.text_snippet, color: color, size: size);
}
