import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static SharedPreferences? _prefs;
  static List<String>? _items;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _items = await getItems();
  }

  @override
  Future<int> getItemCount() async {
    if (_prefs == null) await _initPrefs();
    if (_items != null) return _items!.length;
    return 0;
  }

  @override
  Future<int> getDeletedCount() async {
    if (_prefs == null) await _initPrefs();
    return _prefs!.getInt('deleted') ?? 0;
  }

  @override
  Future<List<String>> getItems() async {
    if (_items == null) {
      if (_prefs == null) await _initPrefs();
      return _prefs!.getStringList('tasks') ?? [];
    } else {
      return _items!;
    }
  }

  @override
  Future<void> addItem(String item) async {
    if (_prefs == null) await _initPrefs();
    if (item.isNotEmpty && !_items!.contains(item)) _items!.add(item);
    await _prefs!.setStringList('tasks', _items!);
  }

  @override
  Future<void> deleteItem(int index) async {
    if (_prefs == null) await _initPrefs();
    _items!.removeAt(index);
    int count = await getDeletedCount();
    await _prefs!.setStringList('tasks', _items!);
    count++;
    await _prefs!.setInt('deleted', count);
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    if (_prefs == null) await _initPrefs();
    if (newItem.isNotEmpty && !_items!.contains(newItem)) {
      _items![index] = newItem;
      await _prefs!.setStringList('tasks', _items!);
    }
  }
}
