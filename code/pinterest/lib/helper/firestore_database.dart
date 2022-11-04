
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloneapp/app/pinterest/class/system.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FirestoreDatabase {
  static CollectionReference getCollectionRoot(String path) {
    var root = path.split('/');
    CollectionReference cRoute = FirebaseFirestore.instance.collection(root.first);
    late DocumentReference dRoute;
    for(int i = 1; i < root.length; i++) {
      if((i % 2) == 0) {
        cRoute = dRoute.collection(root[i]);
      } else {
        dRoute = cRoute.doc(root[i]);
      }
    }
    return cRoute;
  }
  static DocumentReference getDocumentRoot(String path) {
    var root = path.split('/');
    CollectionReference cRoute = FirebaseFirestore.instance.collection(root.first);
    late DocumentReference dRoute;
    for(int i = 1; i < root.length; i++) {
      if((i % 2) == 0) {
        cRoute = dRoute.collection(root[i]);
      } else {
        dRoute = cRoute.doc(root[i]);
      }
    }
    return dRoute;
  }

  /// pinterest
  static dynamic setPinterestPin(Map<String, dynamic> data) async {
      var route = getCollectionRoot('app/pinterest/pin');
      try {
        await route.add(data);
      }
      catch (e) {
        print(e);
      }
  }
  static dynamic getPinterestHome() async {
    var route = getCollectionRoot('app/pinterest/pin');
    List<Pin> res = [];
    var error = await route.orderBy('createAt', descending: true).limit(25).get()
        .then((value) {
      if(value == null)
        return false;

      for(int i =0; i < value.docs.length; i++) {
        var a = Pin.fromDatabase(value.docs[i].data() as Map, value.docs[i].id);
        res.add(a);
      }
      return true;
    });
    return res;
  }
}

/*
class FsStorage {
  static dynamic getJsonFile(String url) async {
    FirebaseStorage storage =  FirebaseStorage.instance; ///FirebaseStorage.instanceFor(bucket: 'akashicrecords-1');
    Directory tempDir = await getApplicationDocumentsDirectory();
    String fullPath = '${tempDir.path}/cache/document/main/aaa.json';
    String dirName = dirname(fullPath);
    final Directory dir = Directory('$dirName');
    if (!dir.existsSync()) {
      final Directory dirCreat = await dir.create(recursive: true);
    }

    var aa = await storage.ref(url).getDownloadURL();
    log(aa);


    try {
      File downloadToFile = File(fullPath);
      await storage.ref(url).writeToFile(downloadToFile);
      return downloadToFile.readAsStringSync();

    } on FirebaseException catch (e) {
      log(e.message);
      // e.g, e.code == 'canceled'
    }
  }
  static dynamic getDownloadUrl(String url) async {
    FirebaseStorage storage =  FirebaseStorage.instance; ///FirebaseStorage.instanceFor(bucket: 'akashicrecords-1');
    var aa = await storage.ref(url).getDownloadURL();
    return aa;
  }

  static dynamic createBoardArticle(String bid, {String json, String title, String tag, String summary, String thumbnailDebug, String link, bool video, Map<String, File> images }) async {
    if(FirebaseAuth.instance.currentUser == null) return false;

    if(thumbnailDebug == '') thumbnailDebug = null;

    FirebaseStorage storage =  FirebaseStorage.instance; ///FirebaseStorage.instanceFor(bucket: 'akashicrecords-1');
    try {
      var aid = DateTime.now().microsecondsSinceEpoch.toString();
      if(aid.length > 16) {
        aid = aid.substring(0, 16);
      } else {
        var c = 16 - aid.length;
        aid = aid + Setting.randomStringNum(c);
      }

      if(images.length > 0) {
        await FirestoreDatabase.createBoardArticle(root: 'boards/$bid/articles',
            aid: aid,
            data: {
              'createAt': FieldValue.serverTimestamp(),
              'url': '',
              'title': title ?? '',
              'summary': summary ?? '',
              'state': 0,
              'link': link ?? '',
              'tag': tag,
              'readCount': 0,
              'likeCount': 0,
              'commentCount': 0,
              'thumbnail': '',
              'video': video,
              'images': [],
              'uid': FirebaseAuth.instance.currentUser.uid,
              'user': {
                'displayName':  FirebaseAuth.instance.currentUser.displayName,
                'photoURL': FirebaseAuth.instance.currentUser.photoURL,
              }
            }
        );
      }

      var thumbnail;
      images.forEach((key, value) { if(!json.contains(key)) images.remove(key); });
      var urls = await uploadFiles(images, 'images/boards/$bid/$aid');
      for(int i = 0; i < urls.length; i++) {
        var key = urls.keys.elementAt(i);
        var value = urls.values.elementAt(i);

        log(value);
        if(thumbnail == null) {
          thumbnail = value;
        }
        json = json.replaceAll(key, value);
      }

      var ref = 'boards/$bid/$aid-${FirebaseAuth.instance.currentUser.uid}.json';
      final firebaseStorageRef = storage.ref(ref);
      final uploadTask = firebaseStorageRef.putString(json, metadata: SettableMetadata(contentType: 'text/json'));
      await uploadTask.whenComplete(() => null);

      await FirestoreDatabase.createBoardArticle(root: 'boards/$bid/articles',
          aid: aid,
          data: {
            'createAt': FieldValue.serverTimestamp(),
            'url': 'storage://$ref',
            'title': title ?? '',
            'summary': summary ?? '',
            'state': 0,
            'link': link ?? '',
            'tag': tag,
            'readCount': 0,
            'likeCount': 0,
            'commentCount': 0,
            'thumbnail': thumbnailDebug ?? thumbnail ?? '',
            'video': video,
            'images': [],
            'uid': FirebaseAuth.instance.currentUser.uid,
            'user': {
              'displayName':  FirebaseAuth.instance.currentUser.displayName,
              'photoURL': FirebaseAuth.instance.currentUser.photoURL,
            }
          }
      );

    } on FirebaseException catch (e) {
      log(e.message);
    }
  }

  static dynamic createNoticeArticle({String json, String title, String tag, String summary, String thumbnailDebug, String link, bool video, Map<String, File> images }) async {
    if(FirebaseAuth.instance.currentUser == null) return false;

    if(thumbnailDebug == '') thumbnailDebug = null;

    FirebaseStorage storage =  FirebaseStorage.instance; ///FirebaseStorage.instanceFor(bucket: 'akashicrecords-1');
    try {
      var aid = DateTime.now().microsecondsSinceEpoch.toString();
      if(aid.length > 16) {
        aid = aid.substring(0, 16);
      } else {
        var c = 16 - aid.length;
        aid = aid + Setting.randomStringNum(c);
      }

      if(images.length > 0) {
        await FirestoreDatabase.createBoardArticle(root: 'setting/notice/articles',
            aid: aid,
            data: {
              'createAt': FieldValue.serverTimestamp(),
              'url': '',
              'title': title ?? '',
              'summary': summary ?? '',
              'state': 0,
              'link': link ?? '',
              'tag': tag,
              'readCount': 0,
              'likeCount': 0,
              'commentCount': 0,
              'thumbnail': '',
              'video': video,
              'images': [],
              'uid': FirebaseAuth.instance.currentUser.uid,
              'user': {
                'displayName':  FirebaseAuth.instance.currentUser.displayName,
                'photoURL': FirebaseAuth.instance.currentUser.photoURL,
              }
            }
        );
      }

      var thumbnail;
      images.forEach((key, value) { if(!json.contains(key)) images.remove(key); });
      var urls = await uploadFiles(images, 'images/boards/notice/$aid');
      for(int i = 0; i < urls.length; i++) {
        var key = urls.keys.elementAt(i);
        var value = urls.values.elementAt(i);

        log(value);
        if(thumbnail == null) {
          thumbnail = value;
        }
        json = json.replaceAll(key, value);
      }

      var ref = 'boards/notice/$aid-${FirebaseAuth.instance.currentUser.uid}.json';
      final firebaseStorageRef = storage.ref(ref);
      final uploadTask = firebaseStorageRef.putString(json, metadata: SettableMetadata(contentType: 'text/json'));
      await uploadTask.whenComplete(() => null);

      await FirestoreDatabase.createBoardArticle(root: 'setting/notice/articles',
          aid: aid,
          data: {
            'createAt': FieldValue.serverTimestamp(),
            'url': 'storage://$ref',
            'title': title ?? '',
            'summary': summary ?? '',
            'state': 0,
            'link': link ?? '',
            'tag': tag,
            'readCount': 0,
            'likeCount': 0,
            'commentCount': 0,
            'thumbnail': thumbnailDebug ?? thumbnail ?? '',
            'video': video,
            'images': [],
            'uid': FirebaseAuth.instance.currentUser.uid,
            'user': {
              'displayName':  FirebaseAuth.instance.currentUser.displayName,
              'photoURL': FirebaseAuth.instance.currentUser.photoURL,
            }
          }
      );

    } on FirebaseException catch (e) {
      log(e.message);
    }
  }


  static Future<Map<String, String>> uploadFiles(Map<String, File> images, String path) async {
    var imageUrls = new Map<String, String>();
    for(int i = 0; i < images.length; i++) {
      var k = images.keys.elementAt(i);
      var img = images.values.elementAt(i);
      imageUrls[k] = await uploadFile(img, path, k.split('/').last);
    }
    return imageUrls;
  }
  static Future<String> uploadFile(File _image, String path, String name) async {
    var storageReference = FirebaseStorage.instance.ref(path).child('$name');

    var image = decodeImage(_image.readAsBytesSync());
    var imageFile;

    if(image.width > 1080) {
      imageFile = copyResize(image, width: 1080);
    }
    if(image.height > 1080) {
      imageFile = copyResize(image, height: 1080);
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    var dir = Directory('${appDocDir.path}/cache/');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    var key = Setting.randomString(length: 16);
    var fullPath = '${ dir.path }$key.${_image.path.split('.').last}';

    File uploadFile = _image;
    if(imageFile != null) {
      uploadFile = await File(fullPath).writeAsBytes(encodePng(imageFile ?? image));
    }

    var uploadTask = storageReference.putFile(uploadFile);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }

}

class FirebaseMultiDatabase {
  static void setData() async {
    FirebaseDatabase.instance.databaseURL = "https://akashicrecords-1-search.firebaseio.com/";
    final aa = FirebaseDatabase.instance.ref('/바-빟');
    await aa.update({'ad' : 'ad'});
  }

  static dynamic getMetaData() async {
    FirebaseDatabase.instance.databaseURL = "https://akashicrecords-1-default-rtdb.asia-southeast1.firebasedatabase.app/";
    final snapshot = await FirebaseDatabase.instance.ref('/meta').get();

    DatabaseMeta meta;

    if (snapshot.exists) {
      meta = new DatabaseMeta.fromDatabase(snapshot.value as Map<dynamic, dynamic>);
    } else {
      print('No data available.');
    }

    return meta;
  }
}

class DatabaseMeta {
  bool forceUpdate = false;

  String googleplay = '';
  String appstore = '';

  String version = '';
  int server = 0;
  String serverInfo = '';
  String updateInfo = '';
  DatabaseMeta.fromDatabase(Map<dynamic, dynamic> json) {
    if(json['server'] != null) {
      server = int.tryParse(json['server'].toString());
    }

    if(json['serverInfo'] != null) {
      serverInfo = json['serverInfo'] as String;
    }
    if(json['updateInfo'] != null) {
      updateInfo = json['updateInfo'] as String;
    }
    if(json['version'] != null) {
      version = json['version'] as String;
    }
    if(json['googleplay'] != null) {
      googleplay = json['googleplay'] as String;
    }
    if(json['appstore'] != null) {
      appstore = json['appstore'] as String;
    }

    if(json['forceUpdate'] != null) {
      forceUpdate = json['forceUpdate'] as bool;
    }
  }
}
*/
