import 'package:kplayer/const/config.dart';

dynamic encodeUriParam(dynamic str) {
  if (str is String) {
    return Uri.encodeComponent(str);
  } else if (str is List<String>) {
    return str.map((s) => Uri.encodeComponent(s)).toList();
  } else {
    return str;
  }
}

String getFileNetworkPath(String path, String name) {
  return '$rootPath/${encodeUriParam(path.replaceFirst(RegExp(r'^/'), ''))}/$name';
}
