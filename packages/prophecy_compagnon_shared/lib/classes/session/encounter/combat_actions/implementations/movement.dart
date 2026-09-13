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

import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/movement_path.dart';

part 'movement.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CombatActionAssignedMovement extends CombatAction {
  CombatActionAssignedMovement({
    required super.entityId,
    required super.rank,
    required this.movementType,
    super.interpolate = false,
    this.distanceMultiplier = 1.0,
  })
    : super(type: CombatActionType.movement);

  final CombatActionMovementType movementType;
  final double distanceMultiplier;

  factory CombatActionAssignedMovement.fromJson(Map<String, dynamic> json) =>
      _$CombatActionAssignedMovementFromJson(json);

  @override
  Map<String, dynamic> combatActionToJson() =>
      _$CombatActionAssignedMovementToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CombatActionMovement extends CombatActionAssignedMovement {
  CombatActionMovement({
    required super.entityId,
    required super.rank,
    required super.movementType,
    super.distanceMultiplier,
    required this.mapId,
    required this.path,
  })
    : super(interpolate: true);

  final String mapId;
  final MovementPath path;

  @override
  CombatAction? lerp(int rank, double x) {
    final ret = CombatActionMovement(
      rank: rank,
      movementType: movementType,
      mapId: mapId,
      entityId: entityId,
      path: MovementPath(),
    );

    if(x == 1.0) {
      ret.path.segments.addAll(path.segments);
      return ret;
    }

    var interpolatedLength = path.length * x;
    MovementPathSegment finalSegment = path.segments.first;

    for(var s in path.segments.sublist(1)) {
      if((interpolatedLength - finalSegment.length) <= 0.0) {
        break;
      }

      interpolatedLength -= finalSegment.length;
      ret.path.segments.add(finalSegment);
      finalSegment = s;
    }

    var segmentLengthRatio = interpolatedLength / finalSegment.length;
    var partialSegment = MovementPathSegment(
      start: finalSegment.start,
      end: Offset(
        finalSegment.start.dx + ((finalSegment.end.dx - finalSegment.start.dx) * segmentLengthRatio),
        finalSegment.start.dy + ((finalSegment.end.dy - finalSegment.start.dy) * segmentLengthRatio),
      ),
    );
    ret.path.segments.add(partialSegment);

    return ret;
  }

  factory CombatActionMovement.fromJson(Map<String, dynamic> json) =>
      _$CombatActionMovementFromJson(json);

  @override
  Map<String, dynamic> combatActionToJson() =>
      _$CombatActionMovementToJson(this);
}