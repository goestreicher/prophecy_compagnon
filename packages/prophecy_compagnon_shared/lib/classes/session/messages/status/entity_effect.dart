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
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_status.dart';
import 'package:prophecy_compagnon_shared/ui/session/evaluate_dice_throw.dart';

part 'entity_effect.g.dart';

abstract class SessionEntityEffectMessage extends SessionEntityStatusMessage {
  SessionEntityEffectMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
  });
}

@JsonSerializable()
class SessionEntityAddEffectMessage extends SessionEntityEffectMessage {
  SessionEntityAddEffectMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.effect,
    this.activationDiceThrowEvaluation,
  });

  final EntityEffect effect;
  final DiceThrowEvaluation? activationDiceThrowEvaluation;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionEntityAddEffectMessageToJson(this);

  factory SessionEntityAddEffectMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityAddEffectMessageFromJson(json);
}

@JsonSerializable()
class SessionEntityUnapplyEffectMessage extends SessionEntityEffectMessage {
  SessionEntityUnapplyEffectMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.effectId,
  });

  final String effectId;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionEntityUnapplyEffectMessageToJson(this);

  factory SessionEntityUnapplyEffectMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityUnapplyEffectMessageFromJson(json);
}