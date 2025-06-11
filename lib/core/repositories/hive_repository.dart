import 'package:hive/hive.dart';

abstract class StoreRepository<T> {
  Future<T?> get(dynamic id);
  Future<void> put(String id, T object);
}

class HiveStoreRepository<T> extends StoreRepository<T> {
  HiveStoreRepository({required this.box});

  final Box box;

  @override
  Future<T?> get(dynamic id, {T? defaultValue}) async {
    if (box.keys.contains(id)) return null;

    return this.box.get(id, defaultValue: defaultValue);
  }

  @override
  Future<void> put(String id, T object) async {
    await box.put(id, object);
  }
}
