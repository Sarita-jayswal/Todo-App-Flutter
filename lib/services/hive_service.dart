import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<Box> initialize() async {
    if (Hive.isBoxOpen("TODOs")) {
      return Hive.box("TODOs");
    } else {
      await Hive.initFlutter();
      Box box = await Hive.openBox("TODOs");
      return box;
    }
  }

  saveTODOs(List<String> todos) {
    Box _box = Hive.box("TODOs");
    _box.put("inputTaskList", todos);
  }

  List<String> getTODOs() {
    Box _box = Hive.box("TODOs");
    if (_box.get("inputTaskList") != null) {
      return _box.get("inputTaskList");
    } else {
      return [];
    }
  }
}
