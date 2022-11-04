import 'dart:developer' as debug;
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileIO {
  static var localPaths = "";

  static Future<String> SET_localpath() async {
    var directory;
    directory = await getApplicationDocumentsDirectory();
    localPaths = directory.path;
    return directory.path;
  }

  static Future<File> _localFile(String morePath) async {
    final directory = await await getApplicationDocumentsDirectory();

    var drPath = morePath.split('/');
    drPath.removeLast();
    final Directory _appDocDirFolder = Directory('${directory.path}/${drPath.join('/')}/');

    if (!_appDocDirFolder.existsSync())
      await _appDocDirFolder.create(recursive: true);

    return File('${directory.path}/$morePath');
  }

  Future<String> getPath(String filename) async {
    final path = await SET_localpath();
    return '$path/$filename';
  }
  static String getPathSysn(String filename) {
    return '$localPaths/$filename';
  }
  static Future<File> getFile(String filename) async {
    final path = await SET_localpath();
    return File('$path/$filename');
  }
  static File getFileSysn(String filename) {
    var path = localPaths;
    //log(filename);
    return File('$path/$filename');
  }

  static Future<File> writeFileAsString({ String? data, String? path }) async {
    final file = await _localFile(path ?? 'cache/tmp.txt');
    return file.writeAsString(data ?? '');
  }
}