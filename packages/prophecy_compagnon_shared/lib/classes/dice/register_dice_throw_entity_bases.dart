// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/luck.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/magic_skill.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/threshold.dart";

void registerDiceThrowEntityBases() {
  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseAbility",
    (Map<String, dynamic> json) => DiceThrowEntityBaseAbility.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseLuck",
    (Map<String, dynamic> json) => DiceThrowEntityBaseLuck.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseMagicSkill",
    (Map<String, dynamic> json) => DiceThrowEntityBaseMagicSkill.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseSkill",
    (Map<String, dynamic> json) => DiceThrowEntityBaseSkill.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseThresholdAbility",
    (Map<String, dynamic> json) => DiceThrowEntityBaseThresholdAbility.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseThresholdLuck",
    (Map<String, dynamic> json) => DiceThrowEntityBaseThresholdLuck.fromJson(json),
  );

}
