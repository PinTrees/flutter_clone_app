
class Pin {
  var title = '';
  var desc = '';
  var link = '';
  var thumbnail = '';
  var tag = '';
  var createAt = '';
  var user = {};

  Pin.fromDatabase(Map<dynamic, dynamic> json, String id) {
    title = json['title'] != null ? json['title'] : '';
    desc = json['desc'] != null ? json['desc'] : '';
    link = json['link'] != null ? json['link'] : '';
    thumbnail = json['thumbnail'] != null ? json['thumbnail'] : '';
    tag = json['tag'] != null ? json['tag'] : '';
    user = json['user'] != null ? json['user'] as Map : {};
  }
}