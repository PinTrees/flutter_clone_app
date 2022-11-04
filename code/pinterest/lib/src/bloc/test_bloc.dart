
import 'package:rxdart/subjects.dart';

class TestBloc {
  var initTest = 'test init';

  static final TestBloc _instance = TestBloc._internal();

  final _testSubject = BehaviorSubject<String>();
  Stream<String> get testResult => _testSubject.stream;

  factory TestBloc() => _instance;
  TestBloc._internal() {
    _testSubject.sink.add(initTest);
  }

  Future<String> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    return 'test click';
  }

  void click() async {
    var test = await fetchData();
    _testSubject.sink.add(test);
  }
}