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

import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/encounter_entity_factory.dart';
import 'package:prophecy_compagnon_shared/classes/entity_instance.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:uuid/uuid.dart';

part 'scenario_encounter.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EncounterEntity {
  EncounterEntity({ required this.id, this.min = 1, this.max = 1 });

  final String id;
  int min;
  int max;

  Map<String, dynamic> toJson() => _$EncounterEntityToJson(this);
  factory EncounterEntity.fromJson(Map<String, dynamic> json) => _$EncounterEntityFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioEncounter {
  ScenarioEncounter({
    String? uuid,
    required this.name,
    List<EncounterEntity>? entities,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      entities = entities ?? <EncounterEntity>[];

  final String uuid;
  final String name;
  final List<EncounterEntity> entities;

  Future<SessionEncounter> instantiate({
    required List<PlayerCharacter> characters,
  }) async {
    var npcs = <EntityInstance>[];

    for(var entity in entities) {
      var count = entity.min;
      if(entity.max > count) {
        count = Random().nextInt(entity.max - entity.min + 1) + entity.min;
      }

      var split = entity.id.split(':');
      if(split.length < 2) continue;
      if(!EncounterEntityFactory.instance.hasFactory(split[0])) continue;

      var factory = EncounterEntityFactory.instance.getInstanceFactory(split[0])!;
      npcs.addAll(await factory(split[1], count));
    }

    return SessionEncounter(
      name: name,
      characters: characters,
      npcs: npcs
    );
  }

  Map<String, dynamic> toJson() => _$ScenarioEncounterToJson(this);
  factory ScenarioEncounter.fromJson(Map<String, dynamic> json) => _$ScenarioEncounterFromJson(json);
}