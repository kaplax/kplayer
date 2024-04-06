import 'package:flutter/material.dart';
import 'package:kplayer/const/config.dart';
import 'package:kplayer/models/file.dart';
import 'package:kplayer/services/api_service.dart';
import 'package:kplayer/utils/url.dart';
import 'package:kplayer/widgets/common/center_tap_detector.dart';


// TODO: jump to previous route with dirIndex param

class Reader extends StatefulWidget {
  final String path;
  final int dirIndex;
  final String _parentPath;

  Reader({
    super.key,
    required this.path,
    required this.dirIndex,
  }) : _parentPath = _init(path);

  static String _init(String path) {
    RegExp regExp = RegExp(r'\/[^\/]*$');
    return path.replaceFirst(regExp, '');
  }

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late Future<FileListModel> futureParentFileList;
  late Future<FileListModel> futureFileList;
  FileListModel? parentFileList;
  FileListModel? _fileList;
  String _dirName = '';
  int _dirIndex = 0;
  bool _prevDisabled = false;
  bool _nextDisabled = false;

  @override
  void initState() {
    super.initState();
    _initFetchData();
    _dirIndex = widget.dirIndex;
  }

  void _initFetchData() async {
    futureParentFileList = fetchFileList(widget._parentPath);
    parentFileList = await futureParentFileList;
    final curFile = parentFileList!.list[_dirIndex];
    futureFileList = fetchFileList('${widget._parentPath}/${curFile.name}');
    final fileList = await futureFileList;
    if (mounted) {
      setState(() {
        _dirName = curFile.name;
        _fileList = fileList;
        _prevDisabled = _dirIndex == 0;
        _nextDisabled = parentFileList!.list.length <= 1;
      });
    }
  }

  _onPrevious() async {
    final parentFiles = parentFileList!.list;
    final nextFile = parentFiles[_dirIndex - 1];
    final fileList =
        await fetchFileList('${widget._parentPath}/${nextFile.name}');
    setState(() {
      _dirName = nextFile.name;
      _dirIndex = _dirIndex - 1;
      _fileList = fileList;
      _nextDisabled = false;
      if (_dirIndex == 0) {
        _prevDisabled = true;
      }
    });
  }

  _onNext() async {
    final parentFiles = parentFileList!.list;
    final nextFile = parentFiles[_dirIndex + 1];
    final fileList =
        await fetchFileList('${widget._parentPath}/${nextFile.name}');
    setState(() {
      _dirName = nextFile.name;
      _dirIndex = _dirIndex + 1;
      _fileList = fileList;
      _prevDisabled = false;
      if (parentFiles.length <= _dirIndex + 1) {
        _nextDisabled = true;
      }
    });
  }

  void showBottomPopup() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (BuildContext context) {
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(0, 0, 0, .6),
              ),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: _prevDisabled
                          ? null
                          : () {
                              Navigator.pop(context);
                              _onPrevious();
                            },
                      icon: Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: _prevDisabled ? Colors.white24 : Colors.white,
                      )),
                  IconButton(
                      onPressed: _nextDisabled
                          ? null
                          : () {
                              Navigator.pop(context);
                              _onNext();
                            },
                      icon: Icon(
                        Icons.chevron_right,
                        size: 40,
                        color: _nextDisabled ? Colors.white24 : Colors.white,
                      )),
                ],
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fileList == null
          ? const CircularProgressIndicator()
          : CenterTapDetector(
              onCenterTap: showBottomPopup,
              child: ListView(
                  children: _fileList!.list
                      .map((fileInfo) => Image(
                          image: NetworkImage(
                              '$rootPath/${encodeUriParam(widget._parentPath)}/${_dirName}/${fileInfo.name}')))
                      .toList()),
            ),
    );
  }
}
