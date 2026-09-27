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
import 'package:prophecy_compagnon_shared/classes/session/messages/map/session_action_map.dart';

part 'get_movement_path.g.dart';

@JsonSerializable()
class SessionMapGetMovementPath extends SessionActionMapMessage {
  SessionMapGetMovementPath({
    super.source,
    required super.destination,
    super.waitResponseTimeout,
    required this.entityId,
    this.distanceMultiplier = 1.0,
  });

  final String entityId;
  final double distanceMultiplier;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionMapGetMovementPathToJson(this);

  factory SessionMapGetMovementPath.fromJson(Map<String, dynamic> json) =>
      _$SessionMapGetMovementPathFromJson(json);
}

@JsonSerializable()
class SessionMapCancelGetMovementPath extends SessionActionMapMessage {
  SessionMapCancelGetMovementPath({
    super.source,
    required super.destination,
    required this.entityId,
    this.cancelReason,
  })
    : super(hasResponse: false);

  final String entityId;
  final String? cancelReason;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionMapCancelGetMovementPathToJson(this);

  factory SessionMapCancelGetMovementPath.fromJson(Map<String, dynamic> json) =>
      _$SessionMapCancelGetMovementPathFromJson(json);
}