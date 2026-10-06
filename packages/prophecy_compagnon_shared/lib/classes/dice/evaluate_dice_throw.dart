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
import 'package:prophecy_compagnon_shared/classes/character/advantages.dart';
import 'package:prophecy_compagnon_shared/classes/character/disadvantages.dart';
import 'package:prophecy_compagnon_shared/classes/character/tendencies.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/threshold.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_enums.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_property_status.dart';

part 'evaluate_dice_throw.g.dart';

@JsonSerializable()
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

  factory DiceThrowEvaluation.fromJson(Map<String, dynamic> json) =>
      _$DiceThrowEvaluationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DiceThrowEvaluationToJson(this);
}

class EntityThrowBundle {
  EntityThrowBundle({
    required this.entity,
    required this.request,
    required this.result,
  })
    : _evaluated = false;

  final EntityBase entity;
  final DiceThrowRequest request;
  final DiceThrowResult result;
  bool _evaluated;

  int? get _difficulty {
    if(request.difficulty == null) return null;
    var mods = result.modifiers
      .where((DiceThrowModifier m) => m.type == DiceThrowModifierType.difficulty);
    var modSum = 0;
    if(mods.isNotEmpty) {
      modSum = mods
        .map((DiceThrowModifier m) => m.value)
        .reduce((int a, int b) => a + b);
    }
    return request.difficulty! + modSum;
  }

  int get _total => request.base.value(entity) + result.total();

  int _margin(int threshold) => _total - threshold;

  int _nr(int threshold) =>
      (result.luck ?? 0) > 0
      && !(
        entity is HumanCharacter
        && (entity as HumanCharacter).advantages.has(Advantage.chanceInouie)
      )
          ? 0
          : _margin(threshold) < 0 ? 0 : _margin(threshold) ~/ 5;
}

DiceThrowEvaluation evaluateDiceThrow(
    EntityThrowBundle actor,
    {
      EntityThrowBundle? opposing,
      dispatchPropertyUpdates = true,
    }
) {
  switch(actor.request.type) {
    case DiceThrowRequestType.raw:
      throw(ArgumentError("Impossible d'évaluer ce type de jets"));
    case DiceThrowRequestType.threshold:
      return evaluateThresholdThrow(actor);
    case DiceThrowRequestType.simple:
      return evaluateStandardThrow(
        actor,
        dispatchPropertyUpdates: dispatchPropertyUpdates,
      );
    case DiceThrowRequestType.oppositionDirect:
    case DiceThrowRequestType.oppositionNR:
      return evaluateOppositionThrow(
        actor,
        opposing!,
        dispatchPropertyUpdates: dispatchPropertyUpdates,
      );
  }
}

DiceThrowEvaluation evaluateThresholdThrow(EntityThrowBundle actor) {
  DiceThrowResultType type;
  int total = actor.result.total();
  int threshold = actor.request.base.value(actor.entity);

  if((actor.request.base as DiceThrowEntityBaseThreshold).throwSucceeds(actor.entity, actor.result.total())) {
    type = DiceThrowResultType.success;
  }
  else {
    type = DiceThrowResultType.fail;
  }

  return DiceThrowEvaluation(
    resultType: type,
    criticalType: DiceThrowResultType.none,
    margin: threshold - total,
    nr: (threshold - total) ~/ 5,
    usedLuck: false,
  );
}

DiceThrowEvaluation evaluateStandardThrow(
    EntityThrowBundle actor,
    {
      dispatchPropertyUpdates = true,
    }
) {
  if(actor.request.difficulty == null) {
    throw(ArgumentError('La difficulté doit être définie'));
  }

  var actorEvaluation = _doEvaluation(actor, actor._difficulty!);

  if(dispatchPropertyUpdates && !actor._evaluated) {
    _dispatchUsedLuckProficiencyMessages(actor);
    _dispatchGainedLuckProficiencyMessages(actorEvaluation, actor.entity);
    if(actor.entity is HumanCharacter) {
      _dispatchTendenciesUpdateMessages(
        actor.entity as HumanCharacter,
        actor,
        actorEvaluation,
      );
    }
    actor._evaluated = true;
  }

  return actorEvaluation;
}

DiceThrowEvaluation evaluateOppositionThrow(
    EntityThrowBundle actor,
    EntityThrowBundle opposing,
    {
      dispatchPropertyUpdates = true,
    }
) {
  DiceThrowEvaluation actorEvaluation;
  int actorValue;
  DiceThrowEvaluation opposingEvaluation;
  int opposingValue;

  if(actor.request.difficulty != null) {
    actorEvaluation = _doEvaluation(actor, actor._difficulty!);
    opposingEvaluation = _doEvaluation(opposing, opposing._difficulty!);

    if(
        actorEvaluation.resultType == DiceThrowResultType.success
        && opposingEvaluation.resultType == DiceThrowResultType.success
    ) {
      if(actor.request.type == DiceThrowRequestType.oppositionDirect) {
        actorValue = actorEvaluation.margin;
        opposingValue = opposingEvaluation.margin;
      }
      else {
        actorValue = actorEvaluation.nr;
        opposingValue = opposingEvaluation.nr;
      }

      if(actorEvaluation.criticalType == DiceThrowResultType.criticalFail) {
        actorValue = 0;
      }

      if(actorValue > opposingValue) {
        opposingEvaluation.resultType = DiceThrowResultType.fail;
      }
      else if(actorValue < opposingValue) {
        actorEvaluation.resultType = DiceThrowResultType.fail;
      }
      else {
        actorEvaluation.resultType = DiceThrowResultType.none;
        opposingEvaluation.resultType = DiceThrowResultType.none;
      }

      if(actor.request.type == DiceThrowRequestType.oppositionDirect) {
        actorEvaluation.margin = actorValue - opposingValue;
        opposingEvaluation.margin = opposingValue - actorValue;
      }
      else {
        actorEvaluation.nr = (actorValue - opposingValue < 0) ? 0 : actorValue - opposingValue;
        opposingEvaluation.nr = (opposingValue - actorValue < 0) ? 0 : opposingValue - actorValue;
      }
    }
  }
  else {
    actorEvaluation = _doEvaluation(actor, opposing._total);
    opposingEvaluation = _doEvaluation(opposing, actor._total);

    if(actor.request.type == DiceThrowRequestType.oppositionDirect) {
      actorValue = actorEvaluation.margin;
      opposingValue = opposingEvaluation.margin;
    }
    else {
      actorValue = actorEvaluation.nr;
      opposingValue = opposingEvaluation.nr;
    }

    if(actorEvaluation.criticalType == DiceThrowResultType.criticalFail) {
      actorValue = 0;
      actorEvaluation.margin = 0;
    }
    if(opposingEvaluation.criticalType == DiceThrowResultType.criticalFail) {
      actorValue += opposing._total;
      actorEvaluation.margin += opposing._total;
    }

    if(actorValue > opposingValue) {
      opposingEvaluation.resultType = DiceThrowResultType.fail;
    }
    else if(actorValue < opposingValue) {
      actorEvaluation.resultType = DiceThrowResultType.fail;
    }
    else {
      actorEvaluation.resultType = DiceThrowResultType.none;
      opposingEvaluation.resultType = DiceThrowResultType.none;
    }
  }

  if(dispatchPropertyUpdates) {
    if(!actor._evaluated) {
      _dispatchUsedLuckProficiencyMessages(actor);
      _dispatchGainedLuckProficiencyMessages(actorEvaluation, actor.entity);
      if (actor.entity is HumanCharacter) {
        _dispatchTendenciesUpdateMessages(
          actor.entity as HumanCharacter,
          actor,
          actorEvaluation,
        );
      }
      actor._evaluated = true;
    }

    if(!opposing._evaluated) {
      _dispatchUsedLuckProficiencyMessages(opposing);
      _dispatchGainedLuckProficiencyMessages(opposingEvaluation, opposing.entity);
      if (opposing.entity is HumanCharacter) {
        _dispatchTendenciesUpdateMessages(
          opposing.entity as HumanCharacter,
          opposing,
          opposingEvaluation,
        );
      }
      opposing._evaluated = true;
    }
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
  var margin = actor._margin(difficulty);
  var nr = actor._nr(difficulty);

  if(margin < 0 || criticalType == DiceThrowResultType.criticalFail) {
    resultType = DiceThrowResultType.fail;
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

void _dispatchTendenciesUpdateMessages(
    HumanCharacter entity,
    EntityThrowBundle bundle,
    DiceThrowEvaluation evaluation,
) {
  if(!bundle.result.usedTendencies) return;
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) return;

  var updates = <CharacterTendencyUpdate>[];

  if(bundle.result.announcedTendency == bundle.result.keptTendency) {
    if(evaluation.criticalType == DiceThrowResultType.criticalSuccess) {
      updates.add(
        CharacterTendencyUpdate(
          tendency: bundle.result.keptTendency!,
          circlesDelta: 2,
        )
      );
    }
    else if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
      updates.add(
        CharacterTendencyUpdate(
          tendency: bundle.result.keptTendency!,
          circlesDelta: -1,
        )
      );
    }
    else if(evaluation.resultType == DiceThrowResultType.success) {
      updates.add(
        CharacterTendencyUpdate(
          tendency: bundle.result.keptTendency!,
          circlesDelta: 1,
        )
      );
    }
  }
  else {
    int announcedUpdate;
    int keptUpdate;

    if(evaluation.criticalType == DiceThrowResultType.criticalSuccess) {
      announcedUpdate = -3;
      keptUpdate = 3;
    }
    else {
      int keptDie;

      switch(bundle.result.keptTendency!) {
        case Tendency.dragon:
          keptDie = bundle.result.dragonDie!;
        case Tendency.fatality:
          keptDie = bundle.result.fatalityDie!;
        case Tendency.human:
          keptDie = bundle.result.humanDie!;
      }

      if(keptDie == 10) {
        announcedUpdate = -2;
        keptUpdate = 2;
      }
      else {
        announcedUpdate = -1;
        keptUpdate = 1;
      }
    }

    updates.add(
      CharacterTendencyUpdate(
        tendency: bundle.result.announcedTendency!,
        circlesDelta: announcedUpdate,
      )
    );
    updates.add(
      CharacterTendencyUpdate(
        tendency: bundle.result.keptTendency!,
        circlesDelta: keptUpdate,
      )
    );
  }

  for(var update in updates) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entity.id,
        property: EntityMessageProperty.updateTendency,
        value: update,
      )
    );
  }
}