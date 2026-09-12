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

import 'package:json_annotation/json_annotation.dart';

part 'object_source.g.dart';

enum ObjectSourceType {
  original(title: 'Original'),
  officiel(title: 'Officiel'),
  scenario(title: 'Scénario'),
  // communaute(title: 'Communauté'),
  ;

  final String title;

  const ObjectSourceType({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ObjectSource {
  factory ObjectSource({
    required ObjectSourceType type,
    required String name,
    String? uuid,
  }) {
    ObjectSource ret;

    if(!_instances.containsKey(type)) {
      _instances[type] = <String, ObjectSource>{};
    }

    if(!_instances[type]!.containsKey(name)) {
      ret = ObjectSource._create(type: type, name: name, uuid: uuid);
      _instances[type]![name] = ret;
    }
    else {
      ret = _instances[type]![name]!;
    }

    return ret;
  }

  static List<ObjectSource> forType(ObjectSourceType type) {
    return _instances[type]?.values.toList() ?? <ObjectSource>[];
  }

  static const ObjectSource local = ObjectSource._create(
      type: ObjectSourceType.original,
      name: "LOCAL_CREATED"
  );

  final ObjectSourceType type;
  final String name;
  @JsonKey(includeIfNull: false)
    final String? uuid;

  @override
  int get hashCode => Object.hash(type, name, uuid);

  @override
  bool operator==(Object other) {
    return other is ObjectSource
        && other.type == type
        && other.name == name
        && other.uuid == uuid;
  }

  factory ObjectSource.fromJson(Map<String, dynamic> j) => _$ObjectSourceFromJson(j);
  Map<String, dynamic> toJson() => _$ObjectSourceToJson(this);

  const ObjectSource._create({ required this.type, required this.name, this.uuid });

  static final Map<ObjectSourceType, Map<String, ObjectSource>> _instances =
    <ObjectSourceType, Map<String, ObjectSource>>{};
}