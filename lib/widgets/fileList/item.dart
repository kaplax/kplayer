import 'package:flutter/material.dart';
import 'package:kplayer/const/config.dart';
import 'package:kplayer/enum/commom.dart';
import 'package:kplayer/models/file.dart';
import 'package:kplayer/utils/icon.dart';
import 'package:kplayer/utils/url.dart';
import 'package:kplayer/utils/util.dart';
import 'package:kplayer/widgets/fileList/index.dart';
import 'package:kplayer/widgets/reader/index.dart';
import 'package:kplayer/widgets/video_player/index.dart';

class FileItem extends StatelessWidget {
  final FileInfoModel file;
  final String path;
  final int curIndex;
  final int dirIndex;
  final List<FileInfoModel> fileList;
  final FileItemShape shape;
  final VoidCallback? onLongPress;
  final bool? selected;
  final bool? selection;
  final Function(bool checked)? onChecked;

  const FileItem(
      {super.key,
      required this.file,
      required this.path,
      required this.curIndex,
      required this.dirIndex,
      required this.fileList,
      this.onLongPress,
      this.shape = FileItemShape.list,
      this.selected = false,
      this.selection = false,
      this.onChecked});

  void _onTap(BuildContext context) {
    if (file.isDir) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FileList(
                  path: '$path/${file.name}',
                  dirIndex: file.isDir ? curIndex : dirIndex)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isImageType(file.ext)
              ? Reader(
                  path: path,
                  dirIndex: dirIndex,
                )
              : VideoPlayer(
                  url: '$rootPath$path/${file.name}',
                ),
        ),
      );
    }
  }

  Widget renderCardShape(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _onTap(context),
          onLongPress: onLongPress,
          child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(0.08),
                //       spreadRadius: 1.2,
                //       blurRadius: 2,
                //       offset: const Offset(0, 1.5))
                // ],
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: file.isDir
                          ? renderIcon('dir', size: 60)
                          : isImageType(file.ext)
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        getFileNetworkPath(path, file.name),
                                      ),
                                    ),
                                  ),
                                )
                              : renderIcon(file.ext, size: 60),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(file.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ))
                          ],
                        )),
                  ])),
        ),
        selection!
            ? GestureDetector(
                onTap: () {
                  if (onChecked != null) {
                    onChecked!(!(selected ?? false));
                  }
                },
                child: Stack(children: [
                  Positioned.fill(
                      child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Stack(
                      children: [
                        Positioned(
                            right: 10,
                            top: 10,
                            child: Icon(
                                selected!
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: Colors.green))
                      ],
                    ),
                  ))
                ]),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return shape == FileItemShape.card
        ? renderCardShape(context)
        : Container(
            padding:
                const EdgeInsets.only(right: 0, top: 12, bottom: 12, left: 12),
            child: GestureDetector(
              onTap: () => _onTap(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: file.isDir
                            ? renderIcon('dir')
                            : renderIcon(file.ext),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(51, 51, 51, 1)),
                        ),
                      )
                    ],
                  ),
                  file.isDir
                      ? Container(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                          ),
                        )
                      : Container()
                ],
              ),
            ));
  }
}
