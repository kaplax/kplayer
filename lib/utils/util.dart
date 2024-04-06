bool isImageType(String name) {
  return RegExp(r'\.(jpg|jpeg|png)$').hasMatch(name);
}


bool isVideoType(String name) {
  return RegExp(r'\.(mp4|webm|ogg)$').hasMatch(name);
}
