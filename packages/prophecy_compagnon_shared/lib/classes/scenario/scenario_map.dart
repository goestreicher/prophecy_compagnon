/*
 * Copyright (C) 2026 Grégory Oestreicher
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

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/place_map.dart';
import 'package:uuid/uuid.dart';

part 'scenario_map.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioMap {
  ScenarioMap({
    String? uuid,
    required this.name,
    required this.placeMap,
    bool? isDefault,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      isDefault = isDefault ?? false;

  String uuid;
  String name;
  PlaceMap placeMap;
  bool isDefault;

  static void preImportFilter(Map<String, dynamic> j) {
    if(
        j['place_map'].containsKey('exportable_binary_data')
        && j['place_map']['exportable_binary_data'] != null
    ) {
      j['place_map']['exportable_binary_data'].remove('is_new');
    }
  }

  static Future<ScenarioMap?> fromStoreJsonRepresentation(Map<String, dynamic> json) async {
    if(!json.containsKey('place_map')) return null;

    var map = await PlaceMapStore().get(json['place_map']);
    if(map == null) return null;

    json['place_map'] = map.toJson();
    return ScenarioMap.fromJson(json);
  }

  Future<Map<String, dynamic>> toStoreJsonRepresentation() async {
    var j = toJson();
    j['place_map'] = placeMap.uuid;
    return j;
  }

  Future<void> willSave() async {
    await PlaceMapStore().save(placeMap);
  }

  Future<void> willDelete() async {
    await PlaceMapStore().delete(placeMap);
  }

  factory ScenarioMap.fromJson(Map<String, dynamic> json) =>
      _$ScenarioMapFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScenarioMapToJson(this);
}