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
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_status.dart';

part 'entity_property_status.g.dart';

enum EntityMessageProperty {
  useLuckPoints,
  gainLuckPoints,
  useProficiencyPoints,
  gainProficiencyPoints,
}

@JsonSerializable()
class SessionEntitySetPropertyMessage extends SessionEntityStatusMessage {
  SessionEntitySetPropertyMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.property,
    required this.value,
  });

  EntityMessageProperty property;
  dynamic value;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionEntitySetPropertyMessageToJson(this);

  factory SessionEntitySetPropertyMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionEntitySetPropertyMessageFromJson(json);
}