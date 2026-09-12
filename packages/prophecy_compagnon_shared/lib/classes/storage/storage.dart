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

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:prophecy_compagnon_shared/classes/storage/engines/hive.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storable.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storage_engine.dart';

typedef StoreAdapterFactory = ObjectStoreAdapter Function();

class DataStorage {
  static DataStorage get instance => _instance ??= DataStorage._ctor();

  String get uriScheme => _engine.uriScheme();
  String get uriHost => _engine.uriHost();

  Future<void> init() async {
    await _engine.init();
  }

  Future<List<String>> keys<T>(String category) async {
    return _engine.keys(category);
  }

  Future<String> get(String category, String key) async {
    return await _engine.get(category, key);
  }

  Future<void> save(String category, String key, String object) async {
    await _engine.save(category, key, object);
  }

  Future<void> delete(String category, String key) async {
    await _engine.delete(category, key);
  }

  Future<Uint8List> export() async {
    var archive = Archive();

    for(var factory in _adapters.values) {
      var category = factory().storeCategory();
      for(var key in await keys(category)) {
        var archiveFile = ArchiveFile.bytes(
          '$category/$key',
          utf8.encode(await get(category, key))
        );
        archive.addFile(archiveFile);
      }
    }

    return ZipEncoder().encodeBytes(archive);
  }

  Future<void> import(Uint8List bytes) async {
    for(var category in _adapters.keys) {
      _engine.purge(category);
    }

    var archive = ZipDecoder().decodeBytes(bytes);

    for(var file in archive) {
      if(file.isFile) {
        var category = p.dirname(file.name);
        var key = p.basename(file.name);
        if(_adapters.containsKey(category)) {
          save(category, key, utf8.decode(file.content));
        }
      }
    }
  }

  static void registerStoreAdapter(
    String category,
    StoreAdapterFactory factory,
  ) {
    _adapters[category] = factory;
  }

  DataStorage._ctor()
    : _engine = HiveStorageEngine();

  final StorageEngine _engine;
  static DataStorage? _instance;
  static final Map<String, StoreAdapterFactory> _adapters =
      <String, StoreAdapterFactory>{};
}