import 'dart:convert';

import 'package:kplayer/models/file.dart';
import 'package:http/http.dart' as http;

Future<FileListModel> fetchFileList(String path) async {
  final resp = await http
      .get(Uri.parse('http://192.168.1.91:3002/api/fileList?path=${Uri.encodeComponent(path)}'));

  if (resp.statusCode == 200) {
    try {
      final resJson = jsonDecode(const Utf8Decoder().convert(resp.bodyBytes)) as Map<String, dynamic>;
      final data = resJson['data'] as Map<String, dynamic>;
      final list = data['list'] as List<dynamic>;
      final fileInfoList =
          list.map((file) => FileInfoModel.fromJson(file)).toList();
      return FileListModel.fromJson({'list': fileInfoList});
    } catch (e) {
      return FileListModel(list: []);
    }
  } else {
    return FileListModel(list: []);
  }
}


class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
