/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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

import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_shared/classes/object_location.dart';

const String _packagePrefix = 'packages/prophecy_compagnon_shared/';

Future<List<dynamic>> loadJSONAssetObjectList(String file) async {
  var jsonStr = await rootBundle.loadString('${_packagePrefix}assets/$file');
  var assets = json.decode(jsonStr);
  var ret = [];
  for(var asset in assets) {
    if(asset is Map) {
      asset['location'] = ObjectLocation(
        type: ObjectLocationType.assets,
        collectionUri: file,
      ).toJson();
      ret.add(asset);
    }
  }
  return ret;
}

Future<ByteData> loadAssetByteData(String file) =>
    rootBundle.load('${_packagePrefix}assets/$file');

Future<Map<String, dynamic>?> loadFilteredJsonAssetObject(String file, String uuid, String Function(Map<String, dynamic>) getId) async {
  var jsonStr = await rootBundle.loadString('${_packagePrefix}assets/$file');
  var assets = json.decode(jsonStr);
  Map<String, dynamic>? ret;
  for(var asset in assets) {
    if(asset is Map && uuid == getId(asset as Map<String, dynamic>)) {
      ret = asset;
      ret['location'] = ObjectLocation(
        type: ObjectLocationType.assets,
        collectionUri: file,
      ).toJson();
      break;
    }
  }
  return ret;
}