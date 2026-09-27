// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/magic_skill.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart";

void registerDiceThrowEntityBases() {
  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseAbility",
    (Map<String, dynamic> json) => DiceThrowEntityBaseAbility.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseMagicSkill",
    (Map<String, dynamic> json) => DiceThrowEntityBaseMagicSkill.fromJson(json),
  );

  DiceThrowEntityBase.registerDiceThrowEntityBaseJsonFactory(
    "DiceThrowEntityBaseSkill",
    (Map<String, dynamic> json) => DiceThrowEntityBaseSkill.fromJson(json),
  );

}
