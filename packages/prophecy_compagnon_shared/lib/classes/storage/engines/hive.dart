/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:hive_flutter/adapters.dart';
import 'package:prophecy_compagnon_shared/classes/storage/exceptions.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storage_engine.dart';

class HiveStorageEngine implements StorageEngine {
  HiveStorageEngine();

  @override
  String uriScheme() => 'hive';

  @override
  String uriHost() => 'localdb';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<List<String>> keys(String category) async {
    var box = await Hive.openLazyBox('${category}Box');
    return box.keys.toList().cast<String>();
  }

  @override
  Future<String> get(String category, String key) async {
    var box = await Hive.openLazyBox('${category}Box');
    var res = await box.get(key);
    if(res == null) throw KeyNotFoundException(category, key);
    return res;
  }

  @override
  Future<void> save(String category, String key, String data) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.put(key, data);
  }

  @override
  Future<void> delete(String category, String key) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.delete(key);
  }

  @override
  Future<void> purge(String category) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.clear();
  }
}