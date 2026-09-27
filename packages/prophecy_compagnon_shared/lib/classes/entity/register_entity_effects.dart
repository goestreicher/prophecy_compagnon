// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/entity/effect.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/combat_status.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/global_dice_throw_modifier.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/health_status.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/initiative_extra_dice.dart";
import "package:prophecy_compagnon_shared/classes/entity/effects/injury_capacity.dart";

void registerEntityEffects() {
  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectCombatStatus",
    (Map<String, dynamic> json) => EntityEffectCombatStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EntityEffectGlobalDiceThrowModifier",
    (Map<String, dynamic> json) => EntityEffectGlobalDiceThrowModifier.fromJson(json),
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
    "EntityEffectInjuryCapacity",
    (Map<String, dynamic> json) => EntityEffectInjuryCapacity.fromJson(json),
  );

}
