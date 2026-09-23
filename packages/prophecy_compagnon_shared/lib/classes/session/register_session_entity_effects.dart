// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/entity_effect.dart";
import "package:prophecy_compagnon_shared/classes/session/entity_effects/combat_status.dart";
import "package:prophecy_compagnon_shared/classes/session/entity_effects/health_status.dart";

void registerSessionEntityEffects() {
  SessionEntityEffect.registerSessionEntityEffectJsonFactory(
    "EffectSetCombatStatus",
    (Map<String, dynamic> json) => EffectSetCombatStatus.fromJson(json),
  );

  SessionEntityEffect.registerSessionEntityEffectJsonFactory(
    "EffectClearCombatStatus",
    (Map<String, dynamic> json) => EffectClearCombatStatus.fromJson(json),
  );

  SessionEntityEffect.registerSessionEntityEffectJsonFactory(
    "EffectSetHealthStatus",
    (Map<String, dynamic> json) => EffectSetHealthStatus.fromJson(json),
  );

  SessionEntityEffect.registerSessionEntityEffectJsonFactory(
    "EffectClearHealthStatus",
    (Map<String, dynamic> json) => EffectClearHealthStatus.fromJson(json),
  );

}
