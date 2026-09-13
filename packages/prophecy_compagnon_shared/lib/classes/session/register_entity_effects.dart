// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/entity_effect.dart";
import "package:prophecy_compagnon_shared/classes/session/entity_effects/combat_status.dart";
import "package:prophecy_compagnon_shared/classes/session/entity_effects/health_status.dart";

void registerEntityEffects() {
  EntityEffect.registerEntityEffectJsonFactory(
    "EffectSetCombatStatus",
    (Map<String, dynamic> json) => EffectSetCombatStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EffectClearCombatStatus",
    (Map<String, dynamic> json) => EffectClearCombatStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EffectSetHealthStatus",
    (Map<String, dynamic> json) => EffectSetHealthStatus.fromJson(json),
  );

  EntityEffect.registerEntityEffectJsonFactory(
    "EffectClearHealthStatus",
    (Map<String, dynamic> json) => EffectClearHealthStatus.fromJson(json),
  );

}
