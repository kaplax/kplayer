import 'package:flutter/material.dart';
import 'package:kplayer/enum/commom.dart';
import 'package:kplayer/models/file.dart';
import 'package:kplayer/services/api_service.dart';
import 'package:kplayer/widgets/fileList/item.dart';

class FileList extends StatefulWidget {
  final String path;
  final int dirIndex;
  const FileList({super.key, required this.path, required this.dirIndex});

  @override
  State<FileList> createState() => _FileList();
}

class _FileList extends State<FileList> {
  late Future<FileListModel> futureFileList;
  // late Future<Album> futureAlbum;
  final Set<int> _selectedList = {};

  @override
  void initState() {
    futureFileList = fetchFileList(widget.path);
    // futureAlbum = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final fileList = list
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder(
            future: futureFileList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final fileList =
                    snapshot.data!.list.asMap().entries.map((entry) {
                  final index = entry.key;
                  final file = entry.value;
                  return FileItem(
                    file: file,
                    curIndex: index,
                    path: widget.path,
                    fileList: snapshot.data!.list,
                    dirIndex: file.isDir ? index : widget.dirIndex,
                    shape: FileItemShape.card,
                    selected: _selectedList.contains(index),
                    selection: _selectedList.isNotEmpty,
                    onChecked: (checked) {
                      setState(() {
                        if (checked) {
                          _selectedList.add(index);
                        } else {
                          _selectedList.remove(index);
                        }
                      });
                    },
                    onLongPress: () {
                      if (_selectedList.contains(index)) {
                        setState(() {
                          _selectedList.remove(index);
                        });
                      } else {
                        setState(() {
                          _selectedList.add(index);
                        });
                      }
                    },
                  );
                }).toList();
                // return ListView(children: fileList);
                return GridView.count(
                  padding: const EdgeInsets.all(6),
                  childAspectRatio: 5 / 6,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: fileList,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
