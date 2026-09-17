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

import 'package:prophecy_compagnon_shared/classes/character/advantages.dart';
import 'package:prophecy_compagnon_shared/classes/character/disadvantages.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_property_status.dart';

class DiceThrowEvaluation {
  DiceThrowEvaluation({
    required this.resultType,
    required this.criticalType,
    required this.margin,
    required this.nr,
    required this.usedLuck,
  });

  DiceThrowResultType resultType;
  DiceThrowResultType criticalType;
  int margin;
  int nr;
  bool usedLuck;
}

class EntityThrowBundle {
  const EntityThrowBundle({
    required this.entity,
    required this.request,
    required this.result,
  });

  final EntityBase entity;
  final DiceThrowRequest request;
  final DiceThrowResult result;

  int? get _difficulty {
    if(request.difficulty == null) return null;
    var modSum = result.modifiers
        .where((DiceThrowModifier m) => m.type == DiceThrowModifierType.difficulty)
        .map((DiceThrowModifier m) => m.value)
        .reduce((int a, int b) => a + b);
    return request.difficulty! + modSum;
  }

  int get _total {
    var sum = request.base.value(entity) + result.total();

    if(result.criticalType(request.base.componentValue(entity)) == DiceThrowResultType.criticalSuccess) {
      sum += 5;
    }

    return sum;
  }

  int _margin(int threshold) => _total - threshold;

  int _nr(int threshold) =>
      (result.luck ?? 0) > 0
      && entity is HumanCharacter
      && (entity as HumanCharacter).advantages.has(Advantage.chanceInouie)
          ? 0
          : _margin(threshold) ~/ 5;
}

DiceThrowEvaluation evaluateDiceThrow(
    EntityThrowBundle actor,
    {
      EntityThrowBundle? opposing,
    }
) {
  if(actor.request.difficulty == null && opposing == null) {
    throw(ArgumentError('One of "difficulty" or "opposing" must be set'));
  }

  var actorEvaluation = _doEvaluation(actor, actor._difficulty ?? opposing!._total);
  if(opposing == null && actorEvaluation.resultType == DiceThrowResultType.none) {
    actorEvaluation.resultType = DiceThrowResultType.success;
  }
  _dispatchUsedLuckProficiencyMessages(actor);
  _dispatchGainedLuckProficiencyMessages(actorEvaluation, actor.entity);

  DiceThrowEvaluation? opposingEvaluation;
  if(opposing != null) {
    opposingEvaluation = _doEvaluation(opposing, actor._total);
    _dispatchUsedLuckProficiencyMessages(opposing);
    _dispatchGainedLuckProficiencyMessages(opposingEvaluation, opposing.entity);
  }

  return actorEvaluation;
}

DiceThrowEvaluation _doEvaluation(EntityThrowBundle actor, int difficulty) {
  DiceThrowResultType resultType;
  DiceThrowResultType criticalType = actor.result.criticalType(
      actor.request.base.componentValue(
          actor.entity
      )
  );
  int margin;
  int nr;

  margin = actor._margin(difficulty);
  nr = actor._nr(difficulty);

  if(margin < 0 || criticalType == DiceThrowResultType.criticalFail) {
    resultType = DiceThrowResultType.fail;
  }
  else if(margin == 0) {
    resultType = DiceThrowResultType.none;
  }
  else {
    resultType = DiceThrowResultType.success;
  }

  return DiceThrowEvaluation(
    resultType: resultType,
    criticalType: criticalType,
    margin: margin,
    nr: nr,
    usedLuck: (actor.result.luck ?? 0) > 0,
  );
}

void _dispatchUsedLuckProficiencyMessages(EntityThrowBundle bundle) {
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) return;

  if(bundle.result.luck != null) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: bundle.entity.id,
        property: EntityMessageProperty.useLuckPoints,
        value: bundle.result.luck,
      )
    );
  }

  if(bundle.result.proficiency != null) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: bundle.entity.id,
        property: EntityMessageProperty.useProficiencyPoints,
        value: bundle.result.proficiency,
      )
    );
  }
}

void _dispatchGainedLuckProficiencyMessages(DiceThrowEvaluation evaluation, EntityBase entity) {
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) return;

  var luckGain = 0;
  var proficiencyGain = 0;

  if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
    if(entity is HumanCharacter && entity.disadvantages.has(Disadvantage.malchance)) {
      luckGain = 1;
    }
    else {
      luckGain = 2;
    }
  }
  else if(evaluation.criticalType == DiceThrowResultType.criticalSuccess) {
    proficiencyGain = 2;
  }
  else if(evaluation.resultType == DiceThrowResultType.fail) {
    luckGain = 1;
  }
  else if(evaluation.resultType == DiceThrowResultType.success) {
    proficiencyGain = 1;
  }

  if(luckGain > 0) {
    if(entity is HumanCharacter && entity.advantages.has(Advantage.chance)) {
      luckGain += 1;
    }

    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entity.id,
        property: EntityMessageProperty.gainLuckPoints,
        value: luckGain,
      )
    );
  }

  if(proficiencyGain > 0) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entity.id,
        property: EntityMessageProperty.gainProficiencyPoints,
        value: proficiencyGain,
      )
    );
  }
}