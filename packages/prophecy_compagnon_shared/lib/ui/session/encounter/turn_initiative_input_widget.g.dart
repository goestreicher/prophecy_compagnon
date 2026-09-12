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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_initiative_input_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionInitiative _$ActionInitiativeFromJson(Map<String, dynamic> json) =>
    ActionInitiative(
      raw: (json['raw'] as num).toInt(),
      weaponModifier: (json['weapon_modifier'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActionInitiativeToJson(ActionInitiative instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'weapon_modifier': instance.weaponModifier,
    };

TurnInitiative _$TurnInitiativeFromJson(Map<String, dynamic> json) =>
    TurnInitiative(
      dominantHand: (json['dominant_hand'] as List<dynamic>)
          .map((e) => ActionInitiative.fromJson(e as Map<String, dynamic>))
          .toList(),
      weakHand: json['weak_hand'] == null
          ? null
          : ActionInitiative.fromJson(
              json['weak_hand'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TurnInitiativeToJson(TurnInitiative instance) =>
    <String, dynamic>{
      'dominant_hand': instance.dominantHand.map((e) => e.toJson()).toList(),
      'weak_hand': instance.weakHand?.toJson(),
    };
