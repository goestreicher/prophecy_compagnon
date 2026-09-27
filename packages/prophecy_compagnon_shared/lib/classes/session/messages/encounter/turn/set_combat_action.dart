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
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/session_encounter_turn.dart';

part 'set_combat_action.g.dart';

@JsonSerializable()
class SessionEncounterTurnSetCombatActionMessage extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnSetCombatActionMessage({
    super.source,
    required super.destination,
    required super.actionUuid,
    required this.combatAction,
  })
    : super(waitResponseTimeout: 5);

  final CombatAction combatAction;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionEncounterTurnSetCombatActionMessageToJson(this);

  factory SessionEncounterTurnSetCombatActionMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionEncounterTurnSetCombatActionMessageFromJson(json);
}