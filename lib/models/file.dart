class FileInfoModel {
  String name;
  int size;
  bool isDir;
  String ext;
  String lastModifiedTime;
  FileInfoModel({
    required this.lastModifiedTime,
    required this.ext,
    required this.isDir,
    required this.name,
    required this.size,
  });

  factory FileInfoModel.fromJson(Map<String, dynamic> json) {
    return FileInfoModel(
      name: json['name'] ?? "",
      size: json['size'] ?? 0,
      isDir: json['isDir'] ?? false,
      ext: json['ext'] ?? "",
      lastModifiedTime: json['lastModifiedTime'] ?? "",
    );
  }

  @override
  String toString() {
    return '{name: $name, size: $size, isDir: $isDir, ext: $ext, lastModifiedTime: $lastModifiedTime}';
  }
}

class FileListModel {
  final List<FileInfoModel> list;

  FileListModel({
    required this.list,
  });

  factory FileListModel.fromJson(Map<String, List<FileInfoModel>> json) {
    return FileListModel(list: json['list'] as List<FileInfoModel>);
  }

  @override
    String toString() {
    return 'list: $list';
      
    }
}
