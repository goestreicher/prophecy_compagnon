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

import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:uuid/uuid.dart';

class DiceThrowHistoryEntry {
  DiceThrowHistoryEntry({
    String? uuid,
    required this.actor,
    this.opposing,
    required this.request,
    this.opposingRequest,
    required this.evaluation,
  })
    : uuid = uuid ?? Uuid().v4().toString();

  final String uuid;
  final EntityBase actor;
  final EntityBase? opposing;
  final DiceThrowRequest request;
  final DiceThrowRequest? opposingRequest;
  final DiceThrowEvaluation evaluation;

  factory DiceThrowHistoryEntry.fromJson(Map<String, dynamic> json) {
    return DiceThrowHistoryEntry(
      uuid: json["uuid"]!,
      actor: GameSession.instance!.entity(json["actor"]!)!,
      opposing: json["opposing"] == null
        ? null
        : GameSession.instance!.entity(json["opposing"]!),
      request: DiceThrowRequest.fromJson(json["request"]!),
      opposingRequest: json["opposing_request"] == null
        ? null
        : DiceThrowRequest.fromJson(json["opposing_request"]!),
      evaluation: DiceThrowEvaluation.fromJson(json["evaluation"]!),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "uuid": uuid,
    "actor": actor.id,
    "opposing": opposing?.id,
    "request": request.toJson(),
    "opposing_request": opposingRequest?.toJson(),
    "evaluation": evaluation.toJson(),
  };
}