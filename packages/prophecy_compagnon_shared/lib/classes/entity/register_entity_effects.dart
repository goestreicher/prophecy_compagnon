// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/entity/effect.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/ability_change.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/ability_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/attribute_change.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/attribute_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/combat_status.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/damage.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/damage_armor.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/damage_malus_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/dice_throw_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/disadvantage.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/gain_experience.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/gain_luck.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/gain_proficiency.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/health_status.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/initiative_extra_dice.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/injury.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/injury_capacity.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/luck_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/null.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/tendency_circles.dart";

void registerEntityEffects() {
  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectChangeAbility",
    (Map<String, dynamic> json) => EntityEffectChangeAbility.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectAbilityModifier",
    (Map<String, dynamic> json) => EntityEffectAbilityModifier.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectChangeAttribute",
    (Map<String, dynamic> json) => EntityEffectChangeAttribute.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectAttributeModifier",
    (Map<String, dynamic> json) => EntityEffectAttributeModifier.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectCombatStatus",
    (Map<String, dynamic> json) => EntityEffectCombatStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectDamage",
    (Map<String, dynamic> json) => EntityEffectDamage.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectDamageArmor",
    (Map<String, dynamic> json) => EntityEffectDamageArmor.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectDamageMalusModifier",
    (Map<String, dynamic> json) => EntityEffectDamageMalusModifier.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectGlobalDiceThrowModifier",
    (Map<String, dynamic> json) => EntityEffectGlobalDiceThrowModifier.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectAddDisadvantage",
    (Map<String, dynamic> json) => EntityEffectAddDisadvantage.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectGainExperience",
    (Map<String, dynamic> json) => EntityEffectGainExperience.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectGainLuck",
    (Map<String, dynamic> json) => EntityEffectGainLuck.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectGainProficiency",
    (Map<String, dynamic> json) => EntityEffectGainProficiency.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectHealthStatus",
    (Map<String, dynamic> json) => EntityEffectHealthStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectInitiativeExtraDice",
    (Map<String, dynamic> json) => EntityEffectInitiativeExtraDice.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectInjury",
    (Map<String, dynamic> json) => EntityEffectInjury.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectInjuryCapacity",
    (Map<String, dynamic> json) => EntityEffectInjuryCapacity.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectLuckModifier",
    (Map<String, dynamic> json) => EntityEffectLuckModifier.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectNull",
    (Map<String, dynamic> json) => EntityEffectNull.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectSetTendencyCircles",
    (Map<String, dynamic> json) => EntityEffectSetTendencyCircles.fromJson(json),
  );

}
